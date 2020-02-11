require! {
    \prelude-ls : { keys, each }
}


mempool = {}



export add-tx = (tx, peer, cb)->
    mempool[tx] = mempool[tx] ? { informers: {} }
    mempool[tx].informers[peer] = (mempool[tx].informers[peer] ? 0) + 1
    cb null
clear-tx = (name)->
    delete mempool[name]

export clear-txs = (cb)->
    mempool |> keys |> each clear-tx
    cb null
export has-tx = (tx, cb)->
    has = mempool[tx]?
    cb null, has