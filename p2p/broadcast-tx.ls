require! {
    \prelude-ls : { sort-with }
    \random-sort
    \superagent : { post }
}

validate-tx = (tx, cb)->


inform-peer = (db, tx, index, cb)->
    err, peer <- db.peers.get index
    return cb err if err?
    err <- post "#{peer.network-address}/new-tx", { tx }
    return cb err if err?
    cb null
    

inform-peers = (db, tx, quorum, [index, ...indexes], cb)->
    return cb null if quorum is 0
    return cb "Cannot find enough peers for notification. Required peers #{quorum}" if not index? and quorum > 0
    err <- inform-peer db, tx, index
    return inform-peers db, tx, quorum, indexes, cb if err?
    next-quorum = quorum - 1
    inform-peers db, tx, next-quorum, indexes, cb

broadcast-tx = (db, tx, cb)->
    
    err, length <- db.peers.length
    return cb err if err?
    last = length - 1
    
    radom-indexes = random-sort [0 to last]
    
    err <- inform-peers tx, 2, radom-indexes
    return cb err if err?
    
    cb null, \done
    
module.exports = broadcast-tx