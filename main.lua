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
    timer=require("lib/hump/timer")
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

    pl={x=17,y=8,tile=72,move=true,dz=0,history={},dirs={up=73,down=72,left=74,right=75}}
    pl.dx=pl.x*size
    pl.dy=pl.y*size

    fallTiles={}

    cam={x=0,y=0,dx=0,dy=0,w=conf.gW/size,h=conf.gH/size}

    cam.dx=pl.x*size-conf.gW/2+4
    cam.dy=pl.y*size-conf.gH/2+4
end

function love.update(dt)
    timer.update(dt)
    input:update()
    local boo=input:pressed("up") or input:pressed("down") or input:pressed("left") or input:pressed("right")
    if boo and pl.move then
        local px,py=pl.x,pl.y
        if input:pressed("up") then
            pl.y=pl.y-1
            pl.tile=pl.dirs.up
        end
        if input:pressed("down") then
            pl.y=pl.y+1
            pl.tile=pl.dirs.down
        end
        if input:pressed("left") then
            pl.x=pl.x-1
            pl.tile=pl.dirs.left
        end
        if input:pressed("right") then
            pl.x=pl.x+1
            pl.tile=pl.dirs.right
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
                
                table.insert(pl.history,{x=px,y=py,id=map.layers["terrain"].data[py+1][px+1].gid,frame=pl.tile})
                if #pl.history>5 then table.remove(pl.history,1) end

                local fallTile = {x=px*size,y=py*size,tile=map.layers["terrain"].data[py+1][px+1].gid,s=1,t=1,r=0}
                table.insert(fallTiles, fallTile)

                timer.tween(0.3, fallTile, {y=fallTile.y+6,s=0.2,t=0,r=math.random(0,180)},"in-quad",function()
                    for i, ft in ipairs(fallTiles) do
                        if ft == fallTile then
                            table.remove(fallTiles, i)
                            break
                        end
                    end
                end)

                map:setLayerTile("terrain",px+1,py+1,0)
                pl.move=false
                timer.tween(0.15,pl,{dx=pl.x*size,dy=pl.y*size},"out-cubic",function()
                    pl.move=true
                end)
                timer.tween(0.15/2,pl,{dz=-3},"out-cubic",function()
                    timer.tween(0.15/2,pl,{dz=0},"in-cubic")
                end)
                timer.tween(0.25,cam,{dx=pl.x*size-conf.gW/2+4,dy=pl.y*size-conf.gH/2+4},"out-cubic")
            end
            
        end
    end

    if pl.move and input:pressed("undo") and #pl.history>0 then
        local h=pl.history[#pl.history]
        table.remove(pl.history,#pl.history)
        map:setLayerTile("terrain",h.x+1,h.y+1,h.id)
        pl.x,pl.y,pl.tile=h.x,h.y,h.frame

        pl.move=false

        
        timer.tween(0.15,pl,{dx=h.x*size,dy=h.y*size},"in-cubic",function()
            pl.move=true
        end)
        timer.tween(0.15/2,pl,{dz=-3},"in-cubic",function()
            timer.tween(0.15/2,pl,{dz=0},"out-cubic")
        end)
        timer.tween(0.25,cam,{dx=pl.x*size-conf.gW/2+4,dy=pl.y*size-conf.gH/2+4},"in-cubic")
    end


    --local tx=pl.x*size-conf.gW/2+4
    --local ty=pl.y*size-conf.gH/2+4
    
    --cam.dx=lerpDt(cam.dx,tx,8,dt)
    --cam.dy=lerpDt(cam.dy,ty,8,dt)
    
    cam.dx=clamp(cam.dx,0,map.width*map.tilewidth-conf.gW)
    cam.dy=clamp(cam.dy,0,map.height*map.tileheight-conf.gH)
end 

function love.draw()
    beginDraw()
        local cx,cy=math.floor(-cam.dx),math.floor(-cam.dy)
        lg.push()
        lg.translate(cx,cy)
            for k,v in ipairs(fallTiles) do
                lg.setColor(1,1,1,v.t)
                spr(v.tile-1,v.x+4,v.y+4,math.rad(v.r),v.s,v.s,4,4)
            end
            lg.setColor(0.7,0.7,0.8,1)
            map:draw(cx,cy+1)
            lg.setColor(1,1,1,1)
            map:draw(cx,cy)
            lg.setColor(0,0,0,0.4)
            lg.rectangle("fill",pl.dx,pl.dy,8,8)
            lg.setColor(1,1,1)
            spr(pl.tile,pl.dx,pl.dy+pl.dz)
        lg.pop()
    endDraw()
end
