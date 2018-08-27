# Cria função last() para arrays
if (!Array.prototype.last)
    Array.prototype.last = ->
        return this[this.length - 1]
