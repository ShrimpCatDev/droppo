require("init")

function initSprite(img,size)
    local quads={}
    for y=0,(img:getHeight()/size)-1 do
        for x=0,(img:getWidth()/size)-1 do
            table.insert(quads,lg.newQuad(x*8,y*8,size,size,img:getWidth(),img:getHeight()))
        end
    end
    return quads
end

function love.load()
    font = require("assets/font/skull")
    lg.setFont(font)
    shove.createLayer("game")

    sti=require("lib/sti")
    map=sti("assets/maps/overworld.lua")
    sheet=lg.newImage("assets/spritesheet.png")
    quads=initSprite(sheet,8)
    spr=function(tile,x,y,...)
        lg.draw(sheet,quads[tile+1],x,y,...)
    end
end

function love.update(dt)
    input:update()
end 

function love.draw()
    beginDraw()
        map:draw()
        spr(40,0,0)
    endDraw()
end
