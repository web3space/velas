require! {
    \../index.js : velas-blockchain
    \./config/nodes.ls
    \./config/genesis.ls
    \./trace.ls
    \./tests/run-realtime-tests.ls
    \./tests/run-basic-tests.ls
}

cb = trace


err <- run-basic-tests
return cb err if err?

start-node-one-by-one = (genesis, [config, ...configs], cb)->
    return cb null if not config?
    options = { ...genesis, ...config }
    server = velas-blockchain.server options
    provider = server.provider
    err <- server.listen config.port
    return cb err if err?
    err, infos <- start-node-one-by-one genesis, configs
    return cb err if err?
    all = ["node started on port #{config.port}"] ++ (infos or [])
    cb null, all


err, infos <- start-node-one-by-one genesis, nodes
return cb err if err?

trace null, infos.join('\n')

err <- run-realtime-tests genesis, nodes
return cb err if err?
cb null, \done

    
    