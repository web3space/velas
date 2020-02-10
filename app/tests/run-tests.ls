require! {
    \web3 : Web3
}

test-each-node = (genesis, [node, ...nodes], cb)->
    return cb null if not node?
    
    web3 = new Web3("http://localhost:#{node.port}")
    
    account = web3.eth.accounts.privateKeyToAccount(node.account)
    
    web3.eth.accounts.wallet.add(account)
    
    err, balance <- web3.eth.get-balance account.address
    return cb err if err? 
    console.log balance
    
    test-each-node genesis, nodes, cb

run-tests = (genesis, nodes, cb)->
    err <- test-each-node genesis, nodes
    return cb err if err?
    cb null, \all-tests-done
     
     
module.exports = run-tests