
validate-peer = (peer, cb)->
    # TODO: Add peer validation
    cb null

add-peer = (db, peer, cb)->
    err, length <- db.peers.length
    return cb "Maximum peers are reached" if length >= 50
    err <- validate-peer peer
    return cb err if err?
    err <- db.peers.push peer
    return cb err if err?
module.exports = add-peer