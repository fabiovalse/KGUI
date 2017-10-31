MAIN_URI = '//wafi.iit.cnr.it/campusmap'

module.exports = {
  main_uri: MAIN_URI,
  layout: {
    searchbar: true,
    infobox: true,
    searchdirectionsbox: true,
    view: true
  },
  default_local_path: '/map@area.cnr.it/target/area@area.cnr.it',
  default_space: 'map@area.cnr.it',
  default_starting_point: '37',
  db: {
    # NEO4j
    #address: 'http://campusmap:7474/db/data/cypher',
    #address: 'http://wafi.iit.cnr.it:17474/db/data/cypher',
    # ARANGO
    #address: 'http://campusmap:8529/_db/campusmap/_api/cursor'
    address: 'http://wafi.iit.cnr.it:8529/_db/campusmap/_api/cursor'
    auth: 'Basic cmVhZG9ubHk6cmVhZG9ubHk='
  },
  global_class_declaration: {},
  global_config: {},
  templates: {
    area: [
      {t: 'image'}
      {t: 'header', title: '{{label}}', subtitle: '{{description}}'}
      {t: 'list', items: [
        {label: 'Indirizzo', value: '{{address}}', icon: 'placemark'}
        {label: 'Centralino', value: '{{phone}}', icon: 'phone'}
        {label: 'Sito Web', value: '{{url}}', icon: 'url'}
      ]}
      {t: 'text', text: '{{about}}'}
      {t: 'timetable', title: 'Orari di apertura', value: '{{timetables}}'}
      {t: 'related', label: '{{short_label}}', title: 'Istituti', query: "FOR vertex, edge IN ANY @id GRAPH 'CampusMap' FILTER edge.type == 'located_in' AND (vertex.description == 'Istituto' OR vertex.description == 'Sezione Istituto') SORT vertex.short_label RETURN vertex"} # {t: 'related', label: '{{short_label}}', title: 'Istituti', query: "MATCH (:Info {id: {current}})-[{type: 'located_in'}]-(n:Info) WHERE n.description='Istituto' OR n.description='Sezione Istituto' RETURN DISTINCT(n) ORDER BY n.short_label ASC"}
      {t: 'text', text: '{{comitato}}', title: "Comitato d'Area", collapsible: true}
      {t: 'text', text: '{{come_raggiungerci}}', title: 'Come raggiungerci', collapsible: true}
      {t: 'related', title: 'Vita di Area', type: "list", query: "FOR vertex, edge IN ANY @id GRAPH 'CampusMap' FILTER edge.type == 'located_in' AND vertex.description == 'Attività' SORT vertex.label RETURN vertex"} # {t: 'related', title: 'Vita di Area', type: "list", query: "MATCH (:Info {id: {current}})-[{type: 'located_in'}]-(n:Info {description: 'Attività'}) RETURN DISTINCT(n) ORDER BY n.label ASC"}
    ],
    poi: [
      {t: 'image'}
      {t: 'header', title: '{{label}}', subtitle: '{{description}}'}
      {t: 'list', items: [
        {label: 'Telefono', value: '{{phone}}', icon: 'phone'}
        {label: 'Fax', value: '{{fax}}', icon: 'fax'}
        {label: 'Sito Web', value: '{{url}}', icon: 'url'}
        {label: 'Email', value: '{{email}}', icon: 'email'}
        {label: 'Capacità', value: '{{capacity}}', icon: 'group'}
      ]}
      {t: 'timetable', title: 'Orari di apertura', value: '{{timetables}}'}
      {t: 'ciclopi', title: 'Stato stalli'}
      {t: 'related', title: 'Persone', query: "FOR v, e IN ANY @id GRAPH 'CampusMap' FILTER e.type == 'in' SORT v.label RETURN v"}
      {t: 'text', text: '{{about}}', collapsible: true}
    ],
    institute: [
      {t: 'image'}
      {t: 'header', title: '{{label}}'}
      {t: 'list', items: [
        {label: 'Telefono', value: '{{phone}}', icon: 'phone'}
        {label: 'Sito Web', value: '{{url}}', icon: 'url'}
        {label: 'Email', value: '{{email}}', icon: 'email'}
      ]}
      {t: 'text', text: '{{about}}', collapsible: true}
      {t: 'related', title: 'Gruppi di Ricerca', type: 'list', query: "FOR v, e IN ANY @id GRAPH 'CampusMap' FILTER e.type == 'in' AND v.type == 'Gruppo di Ricerca' RETURN v"} # {t: 'related', title: 'Gruppi di Ricerca', type: 'list', query: "MATCH (:Info {id: {current}})-[{type: 'in'}]-(n:Info {type: 'Gruppo di Ricerca'}) RETURN DISTINCT(n) ORDER BY n.label ASC"}
      {t: 'related', title: 'Servizi Generali', type: 'list', query: "FOR v, e IN ANY @id GRAPH 'CampusMap' FILTER e.type == 'in' AND v.type == 'Servizi Generali' RETURN v"} # {t: 'related', title: 'Servizi Generali', type: 'list', query: "MATCH (:Info {id: {current}})-[{type: 'in'}]-(n:Info {type: 'Servizi Generali'}) RETURN DISTINCT(n) ORDER BY n.label ASC"}
      {t: 'related', title: 'Struttura Tecnica di Servizio', type: 'list', query: "FOR v, e IN ANY @id GRAPH 'CampusMap' FILTER e.type == 'in' AND v.type == 'Struttura Tecnica di Servizio' RETURN v"} # {t: 'related', title: 'Strutture Tecniche di Servizio', type: 'list', query: "MATCH (:Info {id: {current}})-[{type: 'in'}]-(n:Info {type: 'Struttura Tecnica di Servizio'}) RETURN DISTINCT(n) ORDER BY n.label ASC"}
    ],
    group: [
      {t: 'image'}
      {t: 'header', title: '{{label}}', subtitle: '{{type}}'}
      {t: 'list', items: [
        {label: 'Sito Web', value: '{{url}}', icon: 'url'}
      ]}
      {t: 'text', text: '{{description}}', collapsible: true}
      {t: 'related', title: 'Persone', aggregator: 'position', query: "FOR v, e IN ANY @id GRAPH 'CampusMap' FILTER e.type == 'in' AND v.template == 'person' SORT v.label RETURN v"} # {t: 'related', title: 'Persone', aggregator: 'position', query: "MATCH (:Info {id: {current}})-[{type: 'in'}]-(n:Info {template: 'person'}) RETURN DISTINCT(n) ORDER BY n.label ASC"}
    ],
    person: [
      {t: 'image', circled: true}
      {t: 'header', title: '{{label}}', subtitle: '{{position_plaintext}}'}
      {t: 'reference'}
      {t: 'list', items: [
        {label: 'Telefono', value: '{{tel}}', icon: 'phone'}
        {label: 'Cellulare', value: '{{cel}}', icon: 'mobile'}
        {label: 'Fax', value: '{{fax}}', icon: 'fax'}
        {label: 'Sito Web', value: '{{url}}', icon: 'url'}
        {label: 'Email', value: '{{email}}', icon: 'email'}
      ]}
      {t: 'text', text: '{{about}}', collapsible: true}
      {t: 'text', text: '{{tags}}', title: 'Tags', collapsible: true}
    ],
    room: [
      {t: 'header', title: '{{label}}'}
      {t: 'list', items: [
        {label: '**Floor**', value: '{{floor}}'}
        {label: '**Entrance**', value: '{{entrance}}'}
      ]}
      {t: 'related', title: 'Persone', query: "FOR v, e IN ANY @id GRAPH 'CampusMap' FILTER e.type == 'in' SORT v.label RETURN v"} # "MATCH ({id: {current}})-[{type: 'in'}]-(n) RETURN DISTINCT(n) ORDER BY n.label ASC"}
    ]
  }
}
