require! {
    \./generator.ls
    \prelude-ls : { map }
}

build-account = (private-key)->
    secret-key: private-key
    balance: 100 * (10^18)

module.exports =
    accounts:  
        generator |> map build-account
    locked: yes
    network_id: 1
    asyncRequestProcessing: yes
    govermance:
        stake:
            min-stake: 50 * (10^18)
            confirmation-rate: "2/3+1"
        