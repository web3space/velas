require! {
    \./broadcast-tx.ls
}

new-tx = (state, new-request, cb)->
    
    db = state.blockchain.data
    me = state.options
    console.log me.port, \process-new-tx, 1
    
    
    return cb "new-request is required object" if typeof! new-request isnt \Object
    return cb "new-request.tx is expected string" if typeof! new-request.tx isnt \String 
    #return cb "new-request.block is expected string" if new-request.block isnt \String
    console.log me.port, \process-new-tx, 2
    
    err, has <- state.mempool.has-tx new-request.tx
    return cb err if err?
    console.log me.port, \process-new-tx, 3
    #console.log me.port, new-request.tx, has
    
    err <- state.mempool.add-tx new-request.tx, "any"
    console.log me.port, \process-new-tx, 4
    return cb err if err?
    console.log me.port, \process-new-tx, 5
    #console.log \exit, has
    return cb null if has
    console.log me.port, \process-new-tx, 6, broadcast-tx
    
    #err, first <- db.peers.get 0
    err, res <- broadcast-tx state.blockchain, new-request.tx
    console.log me.port, \process-new-tx, 7
    return cb err if err?
    
    cb null
    
module.exports = new-tx
    