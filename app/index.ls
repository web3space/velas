require! {
    \ganache-core
    \./config/nodes.ls
    \./config/genesis.ls
    \./trace.ls
    \./tests/run-tests.ls
}

cb = trace

start-node-one-by-one = (genesis, [config, ...configs], cb)->
    return cb null if not config?
    server = ganache-core.server genesis
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

err <- run-tests genesis, nodes
return cb err if err?
cb null, \done

    
    