require! {
    \web3 : Web3
    \prelude-ls : { map }
}

web3 = new Web3!

create-private-key = ->
    web3.eth.accounts.create!.private-key

# modify to change network length    
network-length = 4
    
module.exports = [1 to network-length] |> map create-private-key