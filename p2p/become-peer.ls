require! {
    \superagent : { post }
    \./utils/wrong-string.ls
    \./get-web3.ls
}


try-connect-peer = (me, peer, cb)->
    return cb "peer is required correct string" if wrong-string peer, 50
    network-address = "http://#{me.ip}:#{me.port}"
    web3 = get-web3 me
    owner = web3.ether.account.address
    add-me-signature = web3.eth.accounts.sign("Velas peer request", me.account)
    err, res <- post "#{peer}/add-peer", { network-address, owner, add-me-signature }
    return add-me-to-network me, res.body, cb if err? and err.body is 'There are not available slots, please get one of child peer' and typeof! res.body is \Array
    return cb err if err?
    cb null


add-me-to-network = (me, [peer, ...peers], cb)->
    return cb "Cannot find available peer for connection" if not peer?
    err <- try-connect-peer me, peer
    <- set-immediate
    return add-me-to-network me, peers, cb if err?
    cb null

become-peer = (me)->

    return cb "expected array of discovery-peers" if typeof! me.discovery-peers isnt \Array
    
    err <- add-me-to-network me, me.discovery-peers
    return cb err if err? 
    cb null
    
    


module.exports = become-peer