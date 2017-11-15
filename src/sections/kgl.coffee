import showdown from 'showdown'
converter = new showdown.Converter

transform = (value, property) ->
  if not value?
    throw 'undef'
  else if property is 'url'
    return "<a target='blank' href='#{value}'>#{value}</a>"
  else if property in ['phone', 'tel', 'cel']
    return "<a href='tel:#{value}'>#{value}</a>"
  else if property is 'email'
    return "<a href='mailto:#{value}'>#{value}</a>"
  else if property is 'institute'
    return "<a href='#/target/#{value.id}'>#{value.label}</a>"
  else if property is 'group'
    return "<a href='#/target/#{value.id}'>#{value.label}</a>"
  else if property is 'room'
    return "<a href='#/target/#{value.id}'>#{value.label}</a>"
  else
    return value

export default {
  parse: (kgl, data, markdown_enabled) ->
    markdown_enabled = if markdown_enabled? then markdown_enabled else true
    
    try
      regex = /{{(.+?)}}/g
      result = regex.exec kgl

      # Handling objects and arrays
      if result isnt null and typeof data[result[1]] is 'object'
        # arrays
        if data[result[1]].length?
          kgl = data[result[1]].map (d) => transform d, result[1]

          if markdown_enabled
            kgl = kgl.map (d) -> converter.makeHtml(d)[3...-4]
        # object
        else
          kgl = transform data[result[1]], result[1]
      else
        # {{property}} syntax
        kgl = kgl.replace /{{(.+?)}}/g, (_, property) =>
          value = data[property]
          transform value, property

        # MarkDown syntax
        if markdown_enabled
          kgl = converter.makeHtml(kgl)

          if kgl[0...3] is '<p>' and kgl[kgl.length-4...kgl.length] is '</p>'
            kgl = kgl[3...-4] # WARNING this hack removes surrounding <p> tags

      return kgl
    catch error
      return undefined
}
