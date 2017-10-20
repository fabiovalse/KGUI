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

  execute_arango: (query, bind_vars, count, batch_size, transform_cb, cb) ->
    post_data = {"query" : query, "bindVars": bind_vars, "count" : count, "batchSize" : batch_size}

    d3.request 'http://campusmap:8529/_db/campusmap/_api/cursor'
      .header 'Authorization', 'Basic cm9vdDpjMjVhMjAxNw=='
      .post JSON.stringify(post_data), (data) =>
        result = JSON.parse(data.responseText).result

        if transform_cb?
          result = transform_cb result
        if cb?
          cb result

  query_starting_point: (context, starting_point) ->
    payload = {query: "MATCH (n:Info) WHERE n.id={starting_point} RETURN n;", params: {starting_point: starting_point}}
    @execute payload, (data) ->
      result = JSON.parse(data.responseText)

      context.commit '_set_starting_point', result.data[0][0].data

  query_space: (id, cb) ->
    transform_cb = (data) -> 
      if data?
        obj = {
          data[0].space...
          data[0]...
          id: data[0].space._id
        }
        #obj.space.nodes = data[0].nodes
        return obj
      return {}

    @execute_arango """
    LET list = (
      FOR list, edge IN 1 ANY @id GRAPH 'CampusMap'
      FILTER edge.type == 'in_list'
      LET list_items = (
        FOR v,e IN 1 ANY list GRAPH 'CampusMap'
        SORT v.order
        RETURN v
      )
      RETURN list_items
    )
    LET subspaces = (
      FOR subspace, edge IN ANY @id GRAPH 'CampusMap'
      FILTER edge.type == 'subspace'
      RETURN [subspace, LENGTH(edge) > 0]
    )
    LET vfs_path = (
      FOR vertex, edge IN 0..10 INBOUND @id GRAPH 'CampusMap'
      FILTER edge.type == 'subspace'
      RETURN vertex
    )
    LET nodes = (
      FOR vertex, edge IN ANY @id GRAPH 'CampusMap'
      FILTER HAS(edge, 'x') AND HAS(edge, 'y')
      RETURN MERGE(edge, vertex)
    )
    RETURN {
      space: DOCUMENT(@id),
      list: list[0], 
      subspaces: subspaces[0][0], 
      vfs_enabled: subspaces[0][1], 
      vfs_path: vfs_path, 
      nodes: nodes
    }
    """, {id: 'CampusMap_nodes/'+id}, true, null, transform_cb, cb

  query_target: (id, cb) ->
    transform_cb = (data) -> if data? then data[0] else undefined
    @execute_arango """
    FOR n IN CampusMap_nodes
      LET position = (
        FOR v,e IN 1..2 ANY @id GRAPH 'CampusMap'
        FILTER HAS(e, 'x') AND HAS(e, 'y')
        RETURN {x: e.x, y: e.y}
      )
      FILTER n._key == @key
      RETURN MERGE(IS_NULL(FIRST(position)) ? {} : FIRST(position), n)
    """, {key: id, id: 'CampusMap_nodes/'+id}, true, null, transform_cb, cb

  query_family: (id, type, cb) ->
    @execute {query: "MATCH (:Space {id: {id}})-[{type: {type}}]->(parent) RETURN parent", params: {id: id, type: type}}, (data) =>
      row = JSON.parse(data.responseText).data[0]
      if not row?
        cb {}
        return

      parent = row[0].data
      @execute {query: "MATCH (parent {id: {id}})<-[{type: {type}}]-(sibling) RETURN sibling ORDER BY sibling.order", params: {id: parent.id, type: type}}, (data) =>
        siblings = JSON.parse(data.responseText).data.map (d) -> d[0].data

        cb {parent: parent, siblings: siblings}

  query_children: (id, type, rec, cb) ->
    @execute {query: "MATCH (:Space {id: {id}})<-[" + (if rec then '*0.. ' else '') + "{type: {type}}]-(child) RETURN child", params: {id: id, type: type}}, (data) =>
      children = JSON.parse(data.responseText).data.map (d) -> d[0].data

      cb children

#  query_directions: (context, from_id, to_id) ->
#    to_id = if to_id? then to_id else '""' # Undefined is replaced by quotes. In this way it is possible to write only a Cypher query using the OPTIONAL MATCH operator.
#    from_id = if from_id? then from_id else '""'
#
#    payload = {query: "OPTIONAL MATCH (start:Info) WHERE start.id={from_id} OPTIONAL MATCH (end:Info) WHERE end.id={to_id} RETURN start, end", params: {from_id: from_id, to_id: to_id}}
#    @execute payload, (data) ->
#      result = JSON.parse(data.responseText)
#
#      if result.data.length is 0 # If a node has no position, dijkstra fails, result is undefined, then switch to fullmap_mode
#        context.commit 'set_mode', undefined
#        return
#
#      [start, end] = result.data[0]
#
#      if start isnt null
#        from_node = start.data
#        from_node.id = from_id
#      if end isnt null
#        to_node = end.data
#        to_node.id = to_id
#
#      context.commit '_set_directions_state', {path: undefined, weight: undefined, from: from_node, to: to_node}

  query_directions: (ids, cb) ->
    # Retrieve data about from or to
    if ids.from is '_' or ids.to is '_'
      @execute {query: "OPTIONAL MATCH (start:Info) WHERE start.id={from_id} OPTIONAL MATCH (end:Info) WHERE end.id={to_id} RETURN start, end", params: {from_id: ids.from, to_id: ids.to}}, (data) ->
        result = JSON.parse(data.responseText)

        #if result.data.length is 0 # If a node has no position, dijkstra fails, result is undefined, then switch to fullmap_mode
        #  context.commit 'set_mode', undefined
        #  return

        [start, end] = result.data[0]

        if start isnt null
          from_node = start.data
          from_node.id = ids.from
        if end isnt null
          to_node = end.data
          to_node.id = ids.to

        cb {path: undefined, from: from_node, to: to_node}
    # Execute dijkstra when both from and to exist
    else
      @execute {query: "MATCH (start:Info), (end:Info) WHERE start.id={from_id} AND end.id={to_id} CALL apoc.algo.dijkstra(start, end, 'related', 'weight') YIELD path, weight UNWIND nodes(path) AS point MATCH (point)-[{type: 'body'}]-(a:Annotation {ghost: false})-[{type: 'target'}]-(space) RETURN collect(DISTINCT {node: point, position: [a.x, a.y], space: space}) AS nodes, rels(path) AS rels, weight", params: {from_id: ids.from, to_id: ids.to}}, (data) =>
        result = JSON.parse(data.responseText)

        [nodes, links, weight] = result.data[0]

        nodes = nodes.map (d) ->
          n = d.node.data
          n.position = d.position
          n.space = d.space
          return n

        cb {path: {nodes: nodes, links: links, weight: weight}, from: nodes[0], to: nodes[nodes.length-1]}

  query_node: (str, cb) ->
    transform_cb = (data) -> if Array.isArray(data[0]) then data[0] else data

    str = str.split ' '
      .filter (s) -> s isnt ''
      .map (s) -> "prefix:#{s}"
      .join ','

    @execute_arango """
    LET n1 = (FOR n IN FULLTEXT(CampusMap_nodes, 'label', '#{str}', 5) RETURN n)
    LET n2 = (FOR n IN FULLTEXT(CampusMap_nodes, 'tel', '#{str}', 5) RETURN n)
    RETURN UNION(n1,n2)
    """, {}, true, null, transform_cb, cb
}
