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
    size=8
    spr=function(tile,x,y,...)
        lg.draw(sheet,quads[tile+1],x,y,...)
    end

    pl={x=0,y=0,tile=72}
end

function love.update(dt)
    input:update()
    local boo=input:pressed("up") or input:pressed("down") or input:pressed("left") or input:pressed("right")
    if boo then
        local px,py=pl.x,pl.y
        if input:pressed("up") then
            pl.y=pl.y-1
        end
        if input:pressed("down") then
            pl.y=pl.y+1
        end
        if input:pressed("left") then
            pl.x=pl.x-1
        end
        if input:pressed("right") then
            pl.x=pl.x+1
        end
        local v=pl.x<0 or pl.x>=map.width or pl.y<0 or pl.y>=map.height
        if v then 
            pl.x=px
            pl.y=py
        else
            local t=map:getTileProperties("terrain",pl.x+1,pl.y+1)
            local u=map.layers["terrain"].data[pl.y+1][pl.x+1]==nil
            
            if t.col or u then
                pl.x=px
                pl.y=py
            else
                map:setLayerTile("terrain",px+1,py+1,0)
            end
        end
    end
end 

function love.draw()
    beginDraw()
        map:draw()
        lg.setColor(0,0,0,0.4)
        lg.rectangle("fill",pl.x*size,pl.y*size,8,8)
        lg.setColor(1,1,1)
        spr(pl.tile,pl.x*size,pl.y*size-2)
    endDraw()
end
