module.exports = {
  parse: (kgl, data) ->
    try
      return kgl.replace /{{(.+?)}}/g, (_, property) ->
        value = data[property]
        if not value?
          throw 'undef'
        else
          return value
    catch error
      return undefined
}
