module.exports =
    *   port: 8001
        account: \0x8b013f8444439b2481f6f8f52bb3e01f37371d22cd3fda7fefe13fe3605a6f54
        stacker: yes
        discovery-peers:
            * \http://localhost:8002
            * \http://localhost:8003
    *   port: 8002
        account: \0x2a1ddf57e0c9cb3da672f59b4223caba5e751329595fbe9d03989c053319bf3f
        stacker: yes
        discovery-peers: 
            * \http://localhost:8001
            * \http://localhost:8003
    *   port: 8003
        account: \0xaa9037ff29d07dc5937d008b4a28dca371ffa146304213a57afdaf0d53fd6140
        stacker: yes
        discovery-peers:
            * \http://localhost:8002
            * \http://localhost:8003