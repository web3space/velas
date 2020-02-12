require! {
    \prelude-ls : { keys, each }
}

module.exports = ->
    mempool = {}
    add-tx = (tx, peer, cb)->
        mempool[tx] = mempool[tx] ? { informers: {} }
        mempool[tx].informers[peer] = (mempool[tx].informers[peer] ? 0) + 1
        cb null
    clear-tx = (name)->
        delete mempool[name]
    clear-txs = (cb)->
        mempool |> keys |> each clear-tx
        cb null
    has-tx = (tx, cb)->
        has = mempool[tx]?
        cb null, has
    { add-tx, clear-tx, has-tx }