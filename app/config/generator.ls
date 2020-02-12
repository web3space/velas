require! {
    \web3 : Web3
    \prelude-ls : { map }
    \./config.ls : { network-length }
}

web3 = new Web3!

create-private-key = ->
    web3.eth.accounts.create!.private-key
    
module.exports = [1 to network-length] |> map create-private-key