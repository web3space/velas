#remove bad peers

remove-bad-peers = (db, score-result, cb)->
    err, length <- db.peers.length
    return cb err if err?
    cb null
    
    
module.exports = remove-bad-peers