require("init")

function initSprite(img,size) --i dont feel like commenting this right now
    local quads={}
    for y=0,(img:getHeight()/size)-1 do
        for x=0,(img:getWidth()/size)-1 do
            table.insert(quads,lg.newQuad(x*8,y*8,size,size,img:getWidth(),img:getHeight()))
        end
    end
    return quads
end

function love.load()
    --gamestate system because otherwise my code would be MUCH messier
    gs=require("lib/hump/gamestate")
    gs.registerEvents()


    --load my custom palette
    pal=require("lib/pal")
    pal:new("BitSoda",li.newImageData("assets/palette.png"))
    pal:load("BitSoda")

    --my custom font system
    text=require("text")
    text.init(736,775,"abcdefghijklmnopqrstuvwxyz0123456789.!?:")

    --timer function for all the effects :3
    timer=require("lib/hump/timer")
    
    --init screen scaling stuff
    shove.createLayer("game")
    
    --tilemap loading
    sti=require("lib/sti")
    
    --init spritesheet stuff because i dont feel like using multiple assets
    sheet=lg.newImage("assets/spritesheet.png")
    size=8
    quads=initSprite(sheet,8)
    spr=function(tile,x,y,...)
        lg.draw(sheet,quads[tile+1],x,y,...)
    end

    --all of the gamestates (so many i know~)
    state={
        world=require("state.world")
    }

    --switch gamestate
    gs.switch(state.world)
end

function love.update(dt)
    input:update()
end 

function love.draw()
    
end

function love.keypressed(k)
    --toggle fullscreen
    if k=="f11" then
        love.window.setFullscreen(not love.window.getFullscreen())
    end
end
