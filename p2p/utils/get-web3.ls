require! {
    \web3 : Web3
}

module.exports = (node)->
    web3 = new Web3("http://#{node.ip}:#{node.port}")
    
    account = web3.eth.accounts.privateKeyToAccount(node.account)
    
    web3.eth.accounts.wallet.add(account)
    
    web3