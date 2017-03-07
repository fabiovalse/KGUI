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
    payload = JSON.stringify({query: "MATCH (n:Node) WHERE ID(n)=#{starting_point} RETURN n;", "params": {}})
    @cypher payload, (data) ->
      result = JSON.parse(data.responseText)

      node = result.data[0][0].data
      node.id = result.data[0][0].metadata.id

      context.commit '_set_starting_point', node

  query_nodes: (context, id) ->
    payload = JSON.stringify({query: "MATCH (n:Node)-[]-(l:Locus)-[]-(s:Space {label: '#{id}'}) RETURN n,l.x,l.y;", "params": {}})
    @cypher payload, (data) ->
      nodes = JSON.parse(data.responseText).data.map (d) ->
        r = d[0].data
        r.id = d[0].metadata.id
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

    payload = JSON.stringify({query: "MATCH (s1:Space {label: '#{id}'})-[r1:in_list]->(n) WITH n MATCH (s)-[r:in_list]->(n) RETURN s, r ORDER BY r.order", params: {}})
    @cypher payload, (data) =>
      result = JSON.parse(data.responseText).data

      spaces = result.map (s) -> 
        space = s[0].data
        space.order = s[1].data.order
        space.current = false
        space.labels = s[0].metadata.labels

        if space.label is id
          space.current = true
          context.commit '_set_layers', if space.layers? then space.layers.map((l) -> {label: l, status: get_status l}) else []

        return space

      context.commit '_set_spaces', spaces

    @query_nodes context, id

  query_info: (context, id, mutation_name) ->
    _this = @

    payload = JSON.stringify({query: "OPTIONAL MATCH (target) WHERE ID(target)=#{id} OPTIONAL MATCH (target)-[]-(l:Locus)-[]-(space) WHERE ID(target)=#{id} OPTIONAL MATCH (target)-[]->(out) WHERE ID(target)=#{id} AND labels(out)='Node' OPTIONAL MATCH (target)<-[]-(in) WHERE ID(target)=#{id} AND labels(in)='Node' RETURN {node: target, position: [l.x, l.y]}, collect(DISTINCT out) AS out, collect(DISTINCT in) AS in, collect(DISTINCT space) AS spaces;", params: {}})
    @cypher payload, (data) =>
      result = JSON.parse(data.responseText).data[0]
      node = result[0].node.data
      node.position = result[0].position

      node.out = result[1].filter((d) -> d.data?).map (d) ->
        r = d.data
        r.id = d.metadata.id
        return r
      node.in = result[2].filter((d) -> d.data?).map (d) ->
        r = d.data
        r.id = d.metadata.id
        return r
      node.id = id

      context.commit mutation_name, node

      # Change space if necessary
      if context.state.spaces?
        current_space = context.state.spaces.filter((s) -> s.current)[0]
        new_spaces = result[3].map (s) -> s.data.index
        
        if not(current_space.index?) or not(current_space.index in new_spaces)
          min_index = d3.min result[3], (d) -> d.data.index
          _this.query_space context, result[3].filter((s) -> s.data.index is min_index)[0].data.label

  query_directions: (context, from_id, to_id) ->
    to_id = if to_id? then to_id else '""' # Undefined is replaced by quotes. In this way it is possible to write only a Cypher query using the OPTIONAL MATCH operator.
    from_id = if from_id? then from_id else '""'

    payload = JSON.stringify({query: "OPTIONAL MATCH (start:Node) WHERE ID(start)=#{from_id} OPTIONAL MATCH (end:Node) WHERE ID(end)=#{to_id} RETURN start,end;", params: {}})
    @handle_query_directions context, payload, from_id, to_id

  query_directions_dijkstra: (context, from_id, to_id) ->
    payload = JSON.stringify({query: "MATCH (start:Node), (end:Node) WHERE ID(start)=#{from_id} AND ID(end)=#{to_id} CALL apoc.algo.dijkstra(start, end, 'related', 'weight') YIELD path, weight UNWIND nodes(path) AS point MATCH (point)-[:locus]-(l:Locus) RETURN start, end, collect(DISTINCT {node: point, position: [l.x, l.y], id: ID(point)}) AS path, weight", params: {}})
    # payload = JSON.stringify({query: "MATCH (start:Node), (end:Node) WHERE ID(start)=#{from_id} AND ID(end)=#{to_id} CALL apoc.algo.dijkstra(start, end, 'related', 'weight') YIELD path, weight RETURN start, end, nodes(path), weight", params: {}})
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
        n.id = d.id
        return n)) else undefined
      
      context.commit '_set_directions_state', {path: path, weight: weight, from: from_node, to: to_node}

  query_node: (str, callback) ->
    payload = JSON.stringify({query: "MATCH (n:Node) WHERE lower(n.label) CONTAINS '#{str}' RETURN n LIMIT 5", params: {}})
    @cypher payload, callback

}

