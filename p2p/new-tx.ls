require! {
    \./broadcast-tx.ls
    \../mempool/mempool.ls : { add-tx, has-tx }
}

new-tx = (db, me, new-request, cb)->
    
    
    
    return cb "new-request is required object" if typeof! new-request isnt \Object
    return cb "new-request.tx is expected string" if typeof! new-request.tx isnt \String 
    #return cb "new-request.block is expected string" if new-request.block isnt \String
    
    console.log { new-request }
    
    err, has <- has-tx new-request.tx
    return cb err if err?
    
    
    err <- add-tx new-request.tx, "any"
    
    return cb err if err?
    
    
    return cb null if has
    
    
    
    err, res <- broadcast-tx db, tx
    return cb err if err?
    
    cb null
    
module.exports = new-tx
    