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

  execute_arango: (query, cb, transform_cb, bind_vars, count=false, batch_size=null) ->
    post_data = {"query" : query, "bindVars": bind_vars, "count" : count, "batchSize" : batch_size}

    d3.request config.db.address
      .header 'Authorization', config.db.auth
      .post JSON.stringify(post_data), (data) =>
        result = JSON.parse(data.responseText).result

        if transform_cb?
          result = transform_cb result
        if cb?
          cb result

  query_starting_point: (context, starting_point, cb) ->
    @execute_arango "RETURN DOCUMENT('nodes/#{starting_point}')", cb, null, {}

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

    query = """
    LET list = (
      FOR list, edge IN 1 ANY @id GRAPH 'graph'
      FILTER edge.type == 'in_list'
      LET list_items = (
        FOR v,e IN 1 ANY list GRAPH 'graph'
        SORT v.order
        RETURN v
      )
      RETURN list_items
    )
    LET subspaces = (
      FOR subspace, edge IN ANY @id GRAPH 'graph'
      FILTER edge.type == 'subspace'
      RETURN [subspace, LENGTH(edge) > 0]
    )
    LET vfs_path = (
      FOR vertex, edge IN 0..10 INBOUND @id GRAPH 'graph'
      FILTER edge.type == 'subspace'
      RETURN vertex
    )
    LET nodes = (
      FOR vertex, edge IN ANY @id GRAPH 'graph'
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
    """
    @execute_arango query, cb, transform_cb, {id: 'nodes/'+id}

  query_target: (id, cb) ->
    transform_cb = (data) -> if data? then data[0] else undefined
    query = """
    LET position = (
      FOR v,e IN 1..2 OUTBOUND @id GRAPH 'graph'
        FILTER HAS(e, 'x') AND HAS(e, 'y')
      RETURN {x: e.x, y: e.y, floor: +e.floor}
    )
    LET floors = (
      FOR p in position
      RETURN +p.floor
    )
    RETURN MERGE(IS_NULL(FIRST(position)) ? {} : FIRST(position), DOCUMENT(@id), {floors: floors})
    """
    @execute_arango query, cb, transform_cb, {id: 'nodes/'+id}

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

  query_directions: (ids, cb) ->
    # Retrieve data about from or to
    if ids.from is '_' or ids.to is '_'
      transform_cb = (data) ->
        data[0].path = undefined
        return data[0]

      query = """
      LET start = (RETURN DOCUMENT(@from))
      LET end = (RETURN DOCUMENT(@to))
      RETURN {from: start[0], to: end[0]}
      """
      @execute_arango query, cb, transform_cb, {from: 'nodes/'+ids.from, to: 'nodes/'+ids.to} 
    # Execute dijkstra only when both from and to exist
    else
      transform_cb = (data) -> 
        path = data[0].path

        starting_floor = path[0].floor
        ending_floor = path[path.length-1].floor

        path = path
          .map (d,i) -> {d..., index: i}
        path
          .sort (a,b) ->
            if a.multifloor and b.multifloor
              if ending_floor-starting_floor > 0
                return a.floor - b.floor
              else
                return b.floor - a.floor
            else
              return a.index - b.index

        data[0].path = path.map (d,i) ->
          if path[i+1]? and d.multifloor
            if d.floor < path[i+1].floor
              d.floorswitch = 'up'
              d.icon = 'arrow-up'
              
              path[i+1].floorswitch = 'down'
              path[i+1].icon = 'arrow-down'
            else
              d.floorswitch = 'down'
              d.icon = 'arrow-down'

              path[i+1].floorswitch = 'up'
              path[i+1].icon = 'arrow-up'
          d.layer = 'directions'
          return d

        return data[0]

      query = """
      LET from = (
        LET pos = (
          FOR v,e IN 2 OUTBOUND @from GRAPH 'graph'
            FILTER HAS(e, 'x') AND HAS(e, 'y')
          RETURN e
          )
        RETURN LENGTH(pos) > 0 ? pos[0]._from : @from
      )
      LET to = (
        LET pos = (
          FOR v,e IN 2 OUTBOUND @to GRAPH 'graph'
            FILTER HAS(e, 'x') AND HAS(e, 'y')
          RETURN e
        )
        RETURN LENGTH(pos) > 0 ? pos[0]._from : @to
      )
      LET sp = (
        FOR v,e IN ANY SHORTEST_PATH
          from[0] TO to[0]
          GRAPH 'paths'
          OPTIONS {weightAttribute: 'weight'}
        RETURN {e:e, v:v}
      )
      LET weights = (
        FOR d in sp
        RETURN d.e.weight
      )
      LET path = FLATTEN( 
        FOR item IN sp
          LET edges = (
            FOR space, edge IN 1 OUTBOUND item.v._id GRAPH 'graph'
              FILTER HAS(edge, 'x') AND HAS(edge, 'y')
            RETURN edge
          )
          LET main = (
            FOR e IN edges
              FILTER e.main == true
            RETURN e
          )
          RETURN LENGTH(edges) == 1 
            ? MERGE(edges[0], item.v)
            : LENGTH(main) == 1
              ? MERGE(main[0], item.v)
              : (FOR e in edges RETURN MERGE(e, item.v, {multifloor: true}))
      )
      RETURN {path: path, from: path[0], to: path[LENGTH(path)-1], weight: SUM(weights)}
      """
      @execute_arango query, cb, transform_cb, {from: 'nodes/'+ids.from, to: 'nodes/'+ids.to}

  query_node: (str, cb) ->
    transform_cb = (data) -> if Array.isArray(data[0]) then data[0] else data

    str = str.split ' '
      .filter (s) -> s isnt ''
      .map (s) -> "prefix:#{s}"
      .join ','

    query = """
    LET n1 = (FOR n IN FULLTEXT(nodes, 'label', '#{str}', 5) RETURN n)
    LET n2 = (FOR n IN FULLTEXT(nodes, 'tel', '#{str}', 5) RETURN n)
    LET n3 = (FOR n IN FULLTEXT(nodes, 'tags', '#{str}', 5) RETURN n)
    RETURN UNION(n1,n2,n3)
    """
    @execute_arango query, cb, transform_cb, {}

  query_events: (cb) ->
    transform_cb = (data) -> if Array.isArray(data[0]) then data[0] else data

    query = """
    LET today = DATE_NOW()
      FOR doc IN events
        FILTER ABS(DATE_DIFF(today, doc.day, 'd')) < 30
        SORT doc.day
        RETURN doc
    """
    @execute_arango query, cb, transform_cb, {}

  query_presences: (cb) ->
    transform_cb = (data) -> if Array.isArray(data[0]) then data[0] else data

    query = " FOR doc in presence RETURN doc"
    @execute_arango query, cb, transform_cb, {}
    
}
