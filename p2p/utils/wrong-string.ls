wrong-string = (str, max)->
    return yes if typeof! str isnt \String
    return yes if str.length > max
    no
    
module.exports = wrong-string