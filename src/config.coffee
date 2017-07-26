MAIN_URI = '//wafi.iit.cnr.it/annotarium'

module.exports = {
  main_uri: MAIN_URI,
  layout: {
    searchbar: true,
    infobox: true,
    view: true
  },
  default_local_path: '/kge_vfs|root',
  default_space: 'kge_vfs|root',
  db: {
    #address: 'http://annotarium:7474/db/data/cypher',
    address: 'http://wafi.iit.cnr.it:27474/db/data/cypher',
    auth: 'Basic bmVvNGo6YzI1YTIwMTc='
  },
  global_class_declaration: {},
  global_config: {},
  view_templates: {
    map: [
      {t: 'zoomableimage', fullscreen: false, closeable: true}
      {t: 'list', items: [
        {label: '**Authors**', value: '{{authors}}'}
        {label: '**Printer**', value: '{{printer}}'}
        {label: '**Language**', value: '{{language}}'}
        {label: '**Publication Date**', value: '{{publicationDate}}'}
        {label: '**Publication Place**', value: '{{publicationPlace}}'}
        {label: '**Scale**', value: '{{scale}}'}
      ]}
      {t: 'image', href: "#{MAIN_URI}/images/{{size_diagram}}", caption: "{{size_diagram_caption}}", width: "60%"}
      {t: 'text', title: 'Location and infomation of extant maps', text: '{{existingCopies}}'}
      {t: 'text', title: 'Map versions', text: '{{versions}}'}
      {t: 'annotation', title: 'Contains'}
      {t: 'source', sources: '{{sources}}'}
    ]
    planetarysystem: [
      {t: 'planetarysystem', boxing: false}
    ]
    celestial_body: [
      {t: 'image', href: "#{MAIN_URI}/images/depictions/{{id}}.jpg", width: "50%", boxing: false}
      {t: 'list', items: [
        {label: '**Symbol**', value: '{{symbol}}'}
        {label: '**Type**', value: '{{type}}'}
        {label: '**Subtype**', value: '{{subtype}}'}
        {label: '**Distance from primary (km)**', value: '{{distance_from_primary_km}}'}
        {label: '**Equatorial radius (km)**', value: '{{equatorial_radius_km}}'}
        {label: '**Mass (kg)**', value: '{{mass_kg}}'}
        {label: '**Volume (cubical km)**', value: '{{volume_km3}}'}
        {label: '**Orbital period (years)**', value: '{{orbital_period_years}}'}
        {label: '**Inclination (degrees)**', value: '{{inclination_degrees}}'}
        {label: '**Axial tilt (degrees)**', value: '{{axial_tilt_degrees}}'}
      ]}
      {t: 'annotation', title: 'Is Cited by'}
      {t: 'text', title: 'Description', text: '{{description}}'}
    ]
    folio: [
      {t: 'zoomableimage', fullscreen: true, closeable: false}
    ]
    title: [
      {t: 'title', text: '{{label}}'}
    ]
    subtitle: [
      {t: 'subtitle', text: '{{subtitle}}'}
    ]
    image: [
      {t: 'image', href: "#{MAIN_URI}/images/depictions/{{id}}.jpg"}
    ]
    description: [
      {t: 'description', text: '{{description}}'}
    ]
    mailing: [
      {t: 'mailing'}
    ]
    planet: [
      {t: 'planet'}
    ]
    painting: [
      {t: 'zoomableimage', fullscreen: false, closeable: true}
      {t: 'list', items: [
        {label: '**Authors**', value: '{{authors}}'}
        {label: '**Date**', value: '{{publicationDate}}'}
        {label: '**Place**', value: '{{publicationPlace}}'}
        {label: '**Type**', value: '{{type}}'}
        {label: '**Dimensions**', value: '{{dimensions}}'}
      ]}
      {t: 'text', title: 'The artwork', text: "{{picture}}"}
      {t: 'text', title: 'Existing copies', text: '{{existingCopies}}'}
      {t: 'text', title: 'Map versions', text: '{{versions}}'}
      {t: 'source', sources: '{{sources}}'}
    ]
    'foaf:Person': [
      {t: 'image', href: "#{MAIN_URI}/images/depictions/{{id}}.jpg", width: "30%", boxing: false}
      {t: 'time', start_date: '{{birthDate}}', end_date: '{{deathDate}}', range: [0, 408], ref: {label: 'Ricci', id: 'clavius_nes|person-103', start_date: 1552, end_date: 1610}}
      {t: 'related', title: 'Made', query: "MATCH (:Info {id: {current}})-[{type: 'made'}]-(n:Info) RETURN DISTINCT(n) ORDER BY n.label ASC"}
      {t: 'related', title: 'Knew', query: "MATCH (:Info {id: {current}})-[{type: 'knew'}]-(n:Info) RETURN DISTINCT(n) ORDER BY n.label ASC"}
      {t: 'source', sources: '{{sources}}'}
    ]
  }
  templates: {
    'foaf:Person': [
      {t: 'image', href: "#{MAIN_URI}/images/depictions/{{id}}.jpg", icon: '{{icon}}'}
      {t: 'header', title: '{{label}}', subtitle: '{{subtitle}}'}
      {t: 'time', start_date: '{{birthDate}}', end_date: '{{deathDate}}', range: [0, 408], ref: {label: 'Ricci', id: 'clavius_nes|person-103', start_date: 1552, end_date: 1610}}
      {t: 'text', text: '{{description}}', collapsible: true}
      {t: 'related', title: 'Made', query: "MATCH (:Info {id: {current}})-[{type: 'made'}]-(n:Info) RETURN DISTINCT(n) ORDER BY n.label ASC"}
      {t: 'related', title: 'Knew', query: "MATCH (:Info {id: {current}})-[{type: 'knew'}]-(n:Info) RETURN DISTINCT(n) ORDER BY n.label ASC"}
      {t: 'source', sources: '{{sources}}'}
    ]
    project: [
      {t: 'image', href: "#{MAIN_URI}/images/depictions/{{id}}.jpg"}
      {t: 'header', title: '{{label}}', subtitle: '*Project*'}
      {t: 'text', text: '{{description}}'}
      {t: 'text', title: 'Partners', text: '{{partners}}'}
      {t: 'text', title: 'Contacts', text: '{{contacts}}'}

    ]
    map: [
      {t: 'image', href: "#{MAIN_URI}/images/depictions/{{id}}.jpg"}
      {t: 'header', title: '{{label}}', subtitle: '*Map*'}
      {t: 'list', items: [
        {label: '**Authors**', value: '{{authors}}'}
        {label: '**Printer**', value: '{{printer}}'}
        {label: '**Language**', value: '{{language}}'}
        {label: '**Publication Date**', value: '{{publicationDate}}'}
        {label: '**Publication Place**', value: '{{publicationPlace}}'}
        {label: '**Scale**', value: '{{scale}}'}
      ]}
      {t: 'text', title: 'Description', text: '{{description}}'}
      {t: 'text', title: 'Physical Description', text: '{{physicalDescription}}![](data/img/map_size.png =370x179)'}      
      {t: 'text', title: 'Existing copies', text: '{{existingCopies}}'}
      {t: 'text', title: 'Map versions', text: '{{versions}}'}
      {t: 'source', sources: '{{sources}}'}
    ]
    event: [
      {t: 'header', title: '{{label}}', subtitle: '*Event*'}
      {t: 'text', title: 'Description', text: '{{description}}'}
    ]
    work: [
      {t: 'header', title: '{{label}}', subtitle: '*Map*'}
      {t: 'text', title: 'Description', text: '{{description}}'}
      {t: 'source', sources: '{{sources}}'}
    ]
    place: [
      {t: 'image'}
      {t: 'header', title: '{{label}}', subtitle: '*Place*'}
      {t: 'text', text: '{{description}}'}
    ]
    writing: [
      {t: 'image', href: "#{MAIN_URI}/images/depictions/{{id}}.jpg"}
      {t: 'header', id: '{{id}}', title: '{{label}}', subtitle: '*Writing*'}
      #{t: 'action', actions: [
        #{id: '{{id}}', icon: 'zoom_in', label: 'Explore'}
        #{id: '{{id}}', icon: 'share', label: 'Share'}
      #]}
      {t: 'text', title: 'Description', text: '{{description}}'}

    ]
    title: [
      {t: 'image', href: "#{MAIN_URI}/images/depictions/{{id}}.jpg"}
      {t: 'header', title: '{{description}}', subtitle: '*Title*'}
      {t: 'bilingualtext', text: '{{text}}', notes: '{{notes}}'}
    ]
    drawing: [
      {t: 'header', title: '{{label}}', subtitle: '*Drawing*'}
      {t: 'text', title: 'Description', text: '{{description}}'}
    ]
    character: [
      {t: 'header', title: '{{label}}', subtitle: '*Character*'}
      {t: 'text', title: 'Description', text: '{{description}}'}
      {t: 'text', title: 'In the artwork', text: '{{in_the_artwork}}'}
    ]
    detail: [
      {t: 'header', title: '{{label}}', subtitle: '*Detail*'}
      {t: 'text', title: 'Description', text: '{{description}}'}
    ]
    label: [
      {t: 'header', title: '{{label}}', subtitle: '*Label*'}
      {t: 'bilingualtext', text: '{{text}}'}

    ]
    toponym: [
      {t: 'header', title: '{{label}}', subtitle: '*Toponym*'}
      {t: 'bilingualtext', text: '{{text}}'}

    ]
    grapheme: [
      {t: 'image', label: '{{label}}'}
      {t: 'header', title: '{{translation_en}}', subtitle: '*Term*'}
      {t: 'bilingualtext', text: '{{text}}'}
      {t: 'list', items: [
        {label: '**IT**', value: '{{translation_it}}'}
        {label: '**EN**', value: '{{translation_en}}'}
        {label: '**FR**', value: '{{translation_fr}}'}
      ]}

    ]
    term: [
      {t: 'image', label: '{{label}}'}
      {t: 'header', title: '{{translation_en}}', subtitle: '*Term*'}
      {t: 'bilingualtext', text: '{{text}}'}
      {t: 'list', items: [
        {label: '**IT**', value: '{{translation_it}}'}
        {label: '**EN**', value: '{{translation_en}}'}
        {label: '**FR**', value: '{{translation_fr}}'}
      ]}

    ]
    radical: [
      {t: 'image', label: '{{label}}', font: 'chinese'}
      {t: 'header', title: '{{translation_en}}', subtitle: '*Radical*'}
      {t: 'chinesetext'}
      {t: 'list', items: [
        {label: '**IT**', value: '{{translation_it}}'}
        {label: '**EN**', value: '{{translation_en}}'}
        {label: '**FR**', value: '{{translation_fr}}'}
      ]}

    ]
    concept: [
      {t: 'image'}
      {t: 'header', title: '{{label}}', subtitle: '*Concept*'}
    ]
  }
}
