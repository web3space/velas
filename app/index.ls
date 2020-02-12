require! {
    \../index.js : velas-blockchain
    \./config/nodes.ls
    \./config/genesis.ls
    \./trace.ls
    \./tests/run-realtime-tests.ls
    \./tests/run-basic-tests.ls
    \../p2p/superagent-internal.ls : { add-provider }
}

cb = trace


err <- run-basic-tests
return cb err if err?

start-node-one-by-one = (genesis, [config, ...configs], cb)->
    return cb null if not config?
    options = { ...genesis, ...config }
    server = velas-blockchain.server options
    provider = server.provider
    add-provider "http://#{config.ip}:#{config.port}", provider
    err, blockchain <- server.listen config.port
    ##console.log provider
    return cb err if err?
    err, infos <- start-node-one-by-one genesis, configs
    return cb err if err?
    console.log "node started on port #{config.port}"
    all = [{ blockchain, config }] ++ (infos or [])
    cb null, all


err, instances <- start-node-one-by-one genesis, nodes
return cb err if err?

err <- run-realtime-tests genesis, instances
return cb err if err?
cb null, \done

    
    