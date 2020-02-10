require! {
    \./get-web3.ls 
    \./check-peer-balance.ls
    \./utils/wrong-string.ls
}

get-validated-peer = (me, peer, cb)->
    return cb "expected correct peer.network-address" if wrong-string peer.network-address, 50
    return cb "expected correct peer.owner" if wrong-string peer.owner, 50
    return cb "expected correct peer.add-me-signature" if wrong-string peer.add-me-signature, 500
    
    owner = my-web3(me).eth.accounts.recover("Velas peer request", peer.add-me-signature, no)
    return cb "expected owner #{peer.owner}, got #{owner}" if owner isnt peer.owner
    
    score = 0
    
    cb null, { peer.network-address, peer.owner, score }


get-all-peers = (db, length, cb)->
    return cb null, [] if length is 0
    index = length - 1
    err, peer <- db.peers.get index
    return cb err if err?
    err, peers <- get-all-peers db, index
    return cb err if err?
    all = [peer.network-address] ++ peers
    cb null, all

# In case where no available slots found the current peer returns the list of connected slots for further discovery
return-peers = (db, length, cb)->
    err, peers <- get-all-peers db, length
    return cb err if err?
    cb "There are not available slots, please get one of child peer", peers

add-peer = (db, me, peer, cb)->
    err, length <- db.peers.length
    return return-peers db, length, cb if length >= 50
    err, peer <- get-validated-peer me, peer
    return cb err if err?
    err <- db.peers.push peer
    return cb err if err?
    cb null
module.exports = add-peer