config = require('./config.coffee')

module.exports = {
  cypher: (payload, callback) ->
    d3.request config.db.address
      .header 'Accept', 'application/json'
      .header 'X-stream', true
      .header 'Content-Type', 'application/json;charset=utf-8'
      .header 'X-Ajax-Browser-Auth', true
      .header 'Authorization', config.db.auth
      .post payload, callback

  query_starting_point: (context, starting_point) ->
    payload = JSON.stringify({query: "MATCH (n:Node) WHERE n.id={starting_point} RETURN n;", params: {starting_point: starting_point}})
    @cypher payload, (data) ->
      result = JSON.parse(data.responseText)

      context.commit '_set_starting_point', result.data[0][0].data

  query_nodes: (context, id) ->
    payload = JSON.stringify({query: "MATCH (n:Node)-[]-(a:Annotation)-[]-(s:Space {id: {id}}) RETURN n, a.x, a.y;", params: {id: id}})
    @cypher payload, (data) ->
      nodes = JSON.parse(data.responseText).data.map (d) ->
        r = d[0].data
        r.position = [d[1], d[2]]
        return r

      context.commit '_set_nodes', nodes

  query_space: (context, id) ->
    get_status = (layer) ->
      if context.state.layers?
        old_layer = context.state.layers.filter((l) -> l.label is layer)
        return if old_layer.length is 1 then old_layer[0].status else false
      else
        return false

    payload = JSON.stringify({query: "MATCH (s1:Space {id: {id}})-[r1:in_list]->(n) WITH n MATCH (s)-[r:in_list]->(n) RETURN s, r ORDER BY r.order", params: {id: id}})
    @cypher payload, (data) =>
      result = JSON.parse(data.responseText).data

      spaces = result.map (s) ->
        space = s[0].data
        space.order = s[1].data.order
        space.current = false
        space.labels = s[0].metadata.labels

        if space.id.toString() is id.toString()
          space.current = true
          context.commit '_set_layers', if space.layers? then space.layers.map((l) -> {label: l, status: get_status l}) else []
          context.commit '_set_space', space

        return space

      context.commit '_set_spaces', spaces

      if context.state.mode is 'directions' and context.state.from? and context.state.to?
        @query_directions_dijkstra context, context.state.from.id, context.state.to.id

    @query_nodes context, id

  query_info: (context, id, mutation_name) ->
    _this = @

    payload = JSON.stringify({query: "OPTIONAL MATCH (target {id: {id}}) OPTIONAL MATCH (target {id: {id}})-[]-(a:Annotation)-[]-(space) OPTIONAL MATCH (target {id: {id}})-[]->(out) WHERE labels(out)='Node' OPTIONAL MATCH (target {id: {id}})<-[]-(in) WHERE labels(in)='Node' RETURN {node: target, position: [a.x, a.y]}, collect(DISTINCT out) AS out, collect(DISTINCT in) AS in, collect(DISTINCT space) AS spaces;", params: {id: id}})
    @cypher payload, (data) =>
      result = JSON.parse(data.responseText).data[0]

      node = result[0].node.data
      node.position = if result[0].position[0] is null then undefined else result[0].position

      node.out = result[1].filter((d) -> d.data?).map (d) -> d.data
      node.in = result[2].filter((d) -> d.data?).map (d) -> d.data

      context.commit mutation_name, node

      # Change space if necessary
      if context.state.spaces? and result[3].length > 0
        new_spaces = result[3].map (s) -> s.data.index

        if not(context.state.space.index?) or not(context.state.space.index in new_spaces)
          min_index = d3.min result[3], (d) -> d.data.index
          _this.query_space context, result[3].filter((s) -> s.data.index is min_index)[0].data.id

  query_directions: (context, from_id, to_id) ->
    to_id = if to_id? then to_id else '""' # Undefined is replaced by quotes. In this way it is possible to write only a Cypher query using the OPTIONAL MATCH operator.
    from_id = if from_id? then from_id else '""'

    payload = JSON.stringify({query: "OPTIONAL MATCH (start:Node) WHERE start.id={from_id} OPTIONAL MATCH (end:Node) WHERE end.id={to_id} RETURN start,end;", params: {from_id: from_id, to_id: to_id}})
    @handle_query_directions context, payload, from_id, to_id

  query_directions_dijkstra: (context, from_id, to_id) ->
    payload = JSON.stringify({query: "MATCH (start:Node), (end:Node), (space:Space {index: {index}}) WHERE start.id={from_id} AND end.id={to_id} CALL apoc.algo.dijkstra(start, end, 'related', 'weight') YIELD path, weight UNWIND nodes(path) AS point MATCH (point)-[:body]-(a:Annotation {ghost: false})-[:target]-(space) RETURN start, end, collect(DISTINCT {node: point, position: [a.x, a.y], id: ID(point)}) AS path, weight", params: {index: (if context.state.space? then context.state.space.index else 0), from_id: from_id, to_id: to_id}})
    @handle_query_directions context, payload, from_id, to_id

  handle_query_directions: (context, payload, from_id, to_id) ->
    @cypher payload, (data) ->
      result = JSON.parse(data.responseText)

      if result.data.length is 0 # If a node has no position, dijkstra fails, result is undefined, then switch to fullmap_mode
        context.commit 'fullmap_mode'
        return

      [start, end, path, weight] = result.data[0]

      if start isnt null
        from_node = start.data
        from_node.id = from_id
      if end isnt null
        to_node = end.data
        to_node.id = to_id

      path = if path? then (path.map((d) ->
        n = d.node
        n.position = d.position
        return n)) else undefined

      context.commit '_set_directions_state', {path: path, weight: weight, from: from_node, to: to_node}

  query_node: (str, callback) ->
    payload = JSON.stringify({query: "MATCH (n:Node) WHERE lower(n.label) CONTAINS {str} RETURN n LIMIT 5", params: {str: str.toLowerCase()}})
    @cypher payload, callback

}
