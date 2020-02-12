providers = {}

export add-provider = (url, provider)->
    providers[url] = provider

export post = (url, payload)->
    $ = {}
    $.end = (cb)->
        provider = providers[url]
        return cb "provider not found for #{url}" if not provider?
        console.log \proxy, url, payload
        err, body <- provider.send payload
        console.log \after-proxy, url
        return cb err if err?
        cb null, { body }
    $.timeout = ->
        $
    $