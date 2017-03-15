import showdown from 'showdown'
converter = new showdown.Converter

export default {
  parse: (kgl, data) ->
    try
      # {{property}} syntax
      kgl = kgl.replace /{{(.+?)}}/g, (_, property) ->
        value = data[property]
        if not value?
          throw 'undef'
        else
          return value

      # MarkDown syntax
      kgl = converter.makeHtml(kgl)[3...-4] # WARNING this hack removes surrounding <p> tags

      return kgl
    catch error
      return undefined
}
