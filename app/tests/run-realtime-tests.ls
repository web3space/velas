require! {
    \web3 : Web3
    \superagent : { post }
    \../../p2p/utils/get-web3.ls
    \../../p2p/become-peer.ls
    \../../p2p/utils/set-immediate.ls
}

test-each-node = (genesis, [node, ...nodes], cb)->
    return cb null if not node?
    
    #web3 = new Web3("http://localhost:#{node.port}")
    #account = web3.eth.accounts.privateKeyToAccount(node.account)
    #address = account.address
    
    web3 = get-web3 node.config
    
    address = web3.eth.accounts.wallet.0.address
    
    err, balance <- web3.eth.get-balance address
    return cb err if err? 
    return cb "expected balance 100000000000000000000, got #{balance}" if balance isnt \100000000000000000000
    
    err <- web3.eth.send-transaction { from: address, to: '0xd18D7B149850D0Ca719B20592Cd1E022c502DBC6', value: '100000000000000000', gas: '50000', gas-price: '500'  }
    return cb err if err?
    
    #console.log node.blockchain
    
    #me = { network-address: "", owner: "", add-me-signature: "" }
    #err, data <- post "http://localhost:#{node.config.port}", { method: "addPeer", params: me }
    #return cb err if err?
    #return cb data.body.error.message if data.body.error?
    
    <- set-immediate
    test-each-node genesis, nodes, cb

run-tests = (genesis, nodes, cb)->
    # delay to let nodes connect each other right after start
    <- set-timeout _, 3000
    err <- test-each-node genesis, nodes
    return cb err if err?
    cb null, \all-tests-done
     
     
module.exports = run-tests