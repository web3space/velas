require! {
    \./superagent : { post }
    \./utils/wrong-string.ls
    \./utils/get-web3.ls
    \./add-peer.ls
    \./utils/set-immediate.ls
}


try-connect-peer = (me, peer, cb)->
    return cb "expected me object" if typeof! me isnt \Object
    return cb "peer is required correct string" if wrong-string peer, 50
    network-address = "http://#{me.ip}:#{me.port}"
    web3 = get-web3 me
    owner = web3.eth.accounts.wallet.0.address
    add-me-signature = web3.eth.accounts.sign("Velas peer request, My address is #{network-address}", me.account, no).signature
    method = \addPeer
    params = { network-address, owner, add-me-signature }
    err, res <- post(peer, { method, params }).timeout({ deadline: 1000 }).end
    return add-me-to-network me, res.body, cb if err? and err.body?error?message is 'There are not available slots, please get one of child peer' and typeof! res.body is \Array
    return cb err if err?
    return cb res.body.error.message if res.body?error?
    score = \0
    { owner, add-me-signature } = res.body.result
    cb null, { network-address: peer, owner, score, add-me-signature }


already-connected = (db, cb)->
    err, length <- db.peers.length
    return cb err if err?
    return cb "Already connected some peers" if length > 0
    cb null

add-me-to-network = (db, me, [peer, ...peers], cb)->
    return cb null if not peer?
    #return cb "Cannot find available peer for connection" if not peer?
    #err <- already-connected db
    #return cb err if err?
    err, remote-peer <- try-connect-peer me, peer
    <- set-immediate
    err, remote-peers <- add-me-to-network db, me, peers
    return cb err if err?
    all = [remote-peer] ++ remote-peers
    cb null, all

add-peers = (state, [remote-peer, ...remote-peers], cb)->
    return cb null if not remote-peer?
    err, data <- add-peer state, remote-peer
    return cb err if err?
    <- set-immediate
    add-peers state, remote-peers, cb

become-peer = (state, cb)->
    db = state.blockchain.data
    me = state.options
    err <- already-connected db
    return cb null if err is "Already connected some peers"
    return cb "Expected array of discovery-peers" if typeof! me.discovery-peers isnt \Array
    return cb "Cannot find available peers for connection" if me.discovery-peers.length is 0
    err, remote-peers <- add-me-to-network db, me, me.discovery-peers
    return cb err if err?
    
    #console.log remote-peers
    err, data <- add-peers state, remote-peers
    return cb err if err?
    cb null
    
    


module.exports = become-peer