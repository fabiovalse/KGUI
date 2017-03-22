import showdown from 'showdown'
converter = new showdown.Converter

export default {
  parse: (kgl, data) ->
    try
      regex = /{{(.+?)}}/g
      result = regex.exec kgl
      
      if result isnt null and typeof data[result[1]] is 'object'
        return data[result[1]].map((d) -> "<div class='item'>#{d}</div>").join('')

      # {{property}} syntax
      kgl = kgl.replace /{{(.+?)}}/g, (_, property) ->
        value = data[property]
        if not value?
          throw 'undef'
        else if property is 'url'
          return "<a target='blank' href='#{value}'>#{value}</a>"
        else
          return value

      # MarkDown syntax
      kgl = converter.makeHtml(kgl)[3...-4] # WARNING this hack removes surrounding <p> tags

      return kgl
    catch error
      return undefined
}
