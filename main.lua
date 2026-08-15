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
    gs=require("lib/hump/gamestate")
    gs.registerEvents()

    pal=require("lib/pal")
    pal:new("BitSoda",li.newImageData("assets/palette.png"))
    pal:load("BitSoda")

    text=require("text")
    text.init(736,775,"abcdefghijklmnopqrstuvwxyz0123456789.!?:")

    timer=require("lib/hump/timer")

    shove.createLayer("game")

    sti=require("lib/sti")

    sheet=lg.newImage("assets/spritesheet.png")
    size=8
    spr=function(tile,x,y,...)
        lg.draw(sheet,quads[tile+1],x,y,...)
    end

    state={
        world=require("state.world")
    }
    gs.switch(state.world)
end

function love.update(dt)
    input:update()
    
end 

function love.draw()
    
end

function love.keypressed(k)
    if k=="f11" then
        love.window.setFullscreen(not love.window.getFullscreen())
    end
end
