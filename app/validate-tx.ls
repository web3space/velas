require! {
    \ethereum-tx-decoder : { decode-tx }
}

module.exports = (rawtx, cb)->
    return cb "expected rawtx as string" if typeof! rawtx isnt \String
    try
        tx = decode-tx rawtx
        #return cb "required from" if typeof! tx.from isnt \String
        return cb "required nonce" if typeof! tx.nonce isnt \Number
        return cb "required to" if typeof! tx.to isnt \String
        cb null
    catch err
        cb err