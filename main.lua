require("init")

function love.load()
    font = require("assets/font/skull")
    lg.setFont(font)
    shove.createLayer("game")
end

function love.update(dt)
    input:update()
end 

function love.draw()
    beginDraw()
        lg.print("hello world")
    endDraw()
end
