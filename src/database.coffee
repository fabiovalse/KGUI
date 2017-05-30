config = require('./config.coffee')

module.exports = {
  execute: (payload, callback) ->
    payload = JSON.stringify payload

    d3.request config.db.address
      .header 'Accept', 'application/json'
      .header 'X-stream', true
      .header 'Content-Type', 'application/json;charset=utf-8'
      .header 'X-Ajax-Browser-Auth', true
      .header 'Authorization', config.db.auth
      .post payload, callback

  query_starting_point: (context, starting_point) ->
    payload = {query: "MATCH (n:Info) WHERE n.id={starting_point} RETURN n;", params: {starting_point: starting_point}}
    @execute payload, (data) ->
      result = JSON.parse(data.responseText)

      context.commit '_set_starting_point', result.data[0][0].data

  query_nodes: (context, id) ->
    payload = {query: "MATCH (n:Info)-[]-(a:Annotation)-[]-(s:Space {id: {id}}) RETURN n, a.x, a.y, a;", params: {id: id}} #FIXME: only a should be returned
    @execute payload, (data) ->
      nodes = JSON.parse(data.responseText).data.map (d) ->
        r = d[0].data
        r.position = [d[1], d[2]]
        r.data = d[3].data
        return r

      context.commit '_set_nodes', nodes

  query_space: (context, id) ->
    @execute {query: "MATCH (the_space:Space {id: {id}}) RETURN the_space", params: {id: id}}, (data) =>
      space = JSON.parse(data.responseText).data[0][0].data
      @execute {query: "MATCH (the_space:Space {id: {id}})-[{type: 'in_list'}]->(list) MATCH (list)<-[{type: 'in_list'}]-(s) RETURN s ORDER BY s.order", params: {id: id}}, (data) =>
        space.list = JSON.parse(data.responseText).data.map (d) -> d[0].data
        @execute {query: "MATCH (the_space:Space {id: {id}})-[{type: 'subspace'}]->(s) RETURN s", params: {id: id}}, (data) =>
          space.subspaces = JSON.parse(data.responseText).data.map (d) -> d[0].data
          @execute {query: "MATCH (:Space {id: {id}})-[r {type: 'subspace'}]-() RETURN COUNT(r)", params: {id: id}}, (data) =>
            space.vfs_enabled = JSON.parse(data.responseText).data[0][0] > 0
            @execute {query: "MATCH path=(:Space)-[*0.. {type: 'subspace'}]->({id: {id}}) WITH nodes(path) AS path ORDER BY length(path) RETURN path[0]", params: {id: id}}, (data) =>
              space.vfs_path = JSON.parse(data.responseText).data.map (d) -> d[0].data
              space.vfs_path.reverse()
              context.commit '_set_space', space

    @query_nodes context, id

  query_previews: (context, id) ->
    @execute {query: "MATCH (the_space:Space {id: {id}}) RETURN the_space", params: {id: id}}, (data) =>
      space = JSON.parse(data.responseText).data[0][0].data
      @execute {query: "MATCH (the_space:Space {id: {id}})-[{type: 'in_list'}]->(list) MATCH (list)<-[{type: 'in_list'}]-(s) RETURN s ORDER BY s.order", params: {id: id}}, (data) =>
        space.list = JSON.parse(data.responseText).data.map (d) -> d[0].data
        @execute {query: "MATCH (the_space:Space {id: {id}})-[{type: 'subspace'}]->(s) RETURN s", params: {id: id}}, (data) =>
          space.subspaces = JSON.parse(data.responseText).data.map (d) -> d[0].data
          @execute {query: "MATCH (:Space {id: {id}})-[r {type: 'subspace'}]-() RETURN COUNT(r)", params: {id: id}}, (data) =>
            space.vfs_enabled = JSON.parse(data.responseText).data[0][0] > 0
            @execute {query: "MATCH path=(:Space)-[*0.. {type: 'subspace'}]->({id: {id}}) WITH nodes(path) AS path ORDER BY length(path) RETURN path[0]", params: {id: id}}, (data) =>
              space.vfs_path = JSON.parse(data.responseText).data.map (d) -> d[0].data
              space.vfs_path.reverse()
              context.commit '_set_previews', space

  query_info: (context, id, mutation_name) ->
    _this = @

    payload = {query: "OPTIONAL MATCH (target {id: {id}}) OPTIONAL MATCH (target {id: {id}})-[]-(a:Annotation {ghost: false})-[]-(space) OPTIONAL MATCH (target {id: {id}})-[]->(out) WHERE labels(out)='Info' OPTIONAL MATCH (target {id: {id}})<-[]-(in) WHERE labels(in)='Info' RETURN {node: target, position: [a.x, a.y]}, collect(DISTINCT out) AS out, collect(DISTINCT in) AS in, space;", params: {id: id}}
    @execute payload, (data) =>
      result = JSON.parse(data.responseText).data[0]
      node = result[0].node.data
      node.position = if result[0].position[0] is null then undefined else result[0].position

      node.out = result[1].filter((d) -> d.data?).map (d) -> d.data
      node.in = result[2].filter((d) -> d.data?).map (d) -> d.data

      context.commit mutation_name, node

      # Change space if necessary
      if result[3]? and (not context.state.space? or result[3].data.id isnt context.state.space.id)
        _this.query_space context, result[3].data.id

  query_directions: (context, from_id, to_id) ->
    to_id = if to_id? then to_id else '""' # Undefined is replaced by quotes. In this way it is possible to write only a Cypher query using the OPTIONAL MATCH operator.
    from_id = if from_id? then from_id else '""'

    payload = {query: "OPTIONAL MATCH (start:Info) WHERE start.id={from_id} OPTIONAL MATCH (end:Info) WHERE end.id={to_id} RETURN start, end", params: {from_id: from_id, to_id: to_id}}
    @execute payload, (data) ->
      result = JSON.parse(data.responseText)

      if result.data.length is 0 # If a node has no position, dijkstra fails, result is undefined, then switch to fullmap_mode
        context.commit 'fullmap_mode'
        return

      [start, end] = result.data[0]

      if start isnt null
        from_node = start.data
        from_node.id = from_id
      if end isnt null
        to_node = end.data
        to_node.id = to_id

      context.commit '_set_directions_state', {path: undefined, weight: undefined, from: from_node, to: to_node}

  query_directions_dijkstra: (context, from_id, to_id) ->
    payload = {query: "MATCH (start:Info), (end:Info) WHERE start.id={from_id} AND end.id={to_id} CALL apoc.algo.dijkstra(start, end, 'related', 'weight') YIELD path, weight UNWIND nodes(path) AS point MATCH (point)-[:body]-(a:Annotation {ghost: false})-[:target]-(space) RETURN collect(DISTINCT {node: point, position: [a.x, a.y], space: space}) AS nodes, rels(path) AS rels, weight", params: {from_id: from_id, to_id: to_id}}

    @execute payload, (data) =>
      result = JSON.parse(data.responseText)

      [nodes, links, weight] = result.data[0]

      nodes = nodes.map (d) ->
        n = d.node.data
        n.position = d.position
        n.space = d.space
        return n

      context.commit '_set_space', nodes[0].space.data
      context.commit '_set_directions_state', {path: {nodes: nodes, links: links, weight: weight}, from: nodes[0], to: nodes[nodes.length-1]}

      @query_nodes context, nodes[0].space.data.id

  query_node: (str, callback) ->
    payload = {query: "MATCH (n:Info) WHERE lower(n.label) CONTAINS {str} RETURN n LIMIT 5", params: {str: str.toLowerCase()}}
    @execute payload, callback

}
