require! {
    \prelude-ls : { sort-with }
    \random-sort
    \superagent : { post }
    \./utils/math.ls : { plus, minus }
    \./remove-bad-peers.ls
    \../app/validate-tx.ls
    \./utils/set-immediate.ls
}



estimate-peer = (db, index, peer, err, res, cb)->
    operator =
        | err? or res.body.error? => minus
        | _ => plus
    peer.score = peer.score `operator` 1
    err <- db.peers._put index, peer
    return cb err if err?
    cb null, peer.score

inform-peer = (db, tx, index, cb)->
    err, peer <- db.peers.get index
    return cb err if err?
    method = \newTx
    params = { tx }
    err, res <- post peer.network-address, { method, params } #.timeout { deadline: 5000 }
    err2, score <- estimate-peer db, index, peer, err, res
    return cb err if err?
    return cb err2 if err2?
    cb null, score
    

inform-peers = (db, tx, quorum, collect-score, [index, ...indexes], cb)->
    return cb null, collect-score if quorum is 0
    return cb "Cannot find enough peers for notification. Required peers #{quorum}" if not index? and quorum > 0
    err, score <- inform-peer db, tx, index
    <- set-immediate
    next-collect-score = [[index, score]] ++ [] 
    return inform-peers db, tx, quorum, next-collect-score, indexes, cb if err?
    next-quorum = quorum - 1
    inform-peers db, tx, next-quorum, next-collect-score, indexes, cb

broadcast-tx = (db, tx, cb)->
    err <- validate-tx tx
    return cb err if err?
    err, length <- db.peers.length
    return cb err if err?
    last = length - 1
    return cb "Cannot find any peers" if length is 0
    random-indexes = 
        | length is 1 => [0]
        | _ => [0 to last]
    console.log \broadcast-tx, 7, tx, 2, [], random-indexes
    # TODO: replace with pure function
    random-sort random-indexes
    err, score-result <- inform-peers db, tx, 2, [], random-indexes
    return cb err if err?
    err <- remove-bad-peers db, score-result
    return cb err if err?
    
    cb null, \done
    
module.exports = broadcast-tx