require! {
    \prelude-ls : { sort-with }
    \random-sort
    \./superagent : { post }
    \./utils/math.ls : { plus, minus }
    \./remove-bad-peers.ls
    \../app/validate-tx.ls
    \./utils/set-immediate.ls
}



estimate-peer = (blockchain, index, peer, err, res, cb)->
    db = blockchain.data
    operator =
        | err? or res.body.error? => minus
        | _ => plus
    peer.score = peer.score `operator` 1
    err <- db.peers._put index, peer
    return cb err if err?
    cb null, peer.score

inform-peer = (blockchain, tx, index, cb)->
    console.log \inform, 1
    db = blockchain.data
    console.log \inform, 2
    err, peer <- db.peers.get index
    return cb err if err?
    console.log \inform, 3
    method = \newTx
    params = { tx }
    console.log \inform, 4
    console.log \inform, 5
    err, res <- post(peer.network-address, { method, params }).timeout({ deadline: 1000 }).end
    console.log \inform, 6
    console.log err if err?
    err2, score <- estimate-peer blockchain, index, peer, err, res
    return cb err if err?
    return cb err2 if err2?
    cb null, score
    

inform-peers = (blockchain, tx, quorum, collect-score, [index, ...indexes], cb)->
    console.log \inform-peers, 1
    return cb null, collect-score if quorum is 0
    return cb "Cannot find enough peers for notification. Required peers #{quorum}" if not index? and quorum > 0
    console.log \inform-peers, 2
    err, score <- inform-peer blockchain, tx, index
    console.log \inform-peers, 3
    <- set-immediate
    next-collect-score = [[index, score]] ++ [] 
    return inform-peers blockchain, tx, quorum, next-collect-score, indexes, cb if err?
    console.log \inform-peers, 4
    next-quorum = quorum - 1
    inform-peers blockchain, tx, next-quorum, next-collect-score, indexes, cb

broadcast-tx = (blockchain, tx, cb)->
    console.log \broadcast-tx, 0
    db = blockchain.data
    console.log \broadcast-tx, 1
    err <- validate-tx tx
    console.log \broadcast-tx, 2
    return cb err if err?
    err, length <- db.peers.length
    console.log \broadcast-tx, 3
    return cb err if err?
    console.log \broadcast-tx, 4
    last = length - 1
    return cb "Cannot find any peers" if length is 0
    random-indexes = 
        | length is 1 => [0]
        | _ => [0 to last]
    #console.log \broadcast-tx, 7, tx, 2, [], random-indexes
    # TODO: replace with pure function
    #random-sort random-indexes
    console.log \broadcast-tx, 1
    err, score-result <- inform-peers blockchain, tx, 2, [], random-indexes
    console.log \broadcast-tx, 2
    return cb err if err?
    err <- remove-bad-peers db, score-result
    return cb err if err?
    
    cb null, \done
    
module.exports = broadcast-tx