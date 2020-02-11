require! {
    \./get-web3.ls
}

module.exports = (me, message, signature, cb)->
    return cb "expected object" if typeof! me isnt \Object
    return cb "expected some message" if typeof! message isnt \String or message.length is 0
    return cb "expected some signature" if typeof! signature isnt \String or signature.length is 0
    web3 = get-web3 me
    try
        owner = web3.eth.accounts.recover(message, signature, no)
        cb null, owner
    catch err
        cb err
        