require! {
    \./generator.ls
    \prelude-ls : { foldl, filter, each, map }
    \./config.ls : { ip }
}


build-node = (collector, account)->
        item =
                port: 9000 + collector.length + 1
                ip: ip
                account: account
                stacker: yes
                discovery-peers: []
        collector ++ [item]
                

nodes =
        generator |> foldl build-node, []

connect-nodes = (nodes)--> (node)->
        other-nodes =
                nodes |> filter (-> it isnt node)
        node.discovery-peers =
                other-nodes |> map (-> "http://#{it.ip}:#{it.port}")
        

connected-nodes =
        nodes |> each connect-nodes nodes

module.exports = connected-nodes