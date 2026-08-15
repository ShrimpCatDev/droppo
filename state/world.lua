local world={}
--NOTE: ALL OF THESE COMMENTS WERE WRITTEN BY ME, NOT AI SO DONT YELL AT MEEEE

function world:enter()
    --load map ofc
    map=sti("assets/maps/overworld.lua")

    --initialize player
    pl={x=17,y=8,tile=72,move=true,dz=0,history={},dirs={up=73,down=72,left=74,right=75}}
    pl.dx=pl.x*size
    pl.dy=pl.y*size

    --this is the falling tile effect system hi lol
    fallTiles={}

    --initialize camera
    cam={x=0,y=0,dx=0,dy=0,w=conf.gW/size,h=conf.gH/size}
    cam.dx=pl.x*size-conf.gW/2+4
    cam.dy=pl.y*size-conf.gH/2+4
end

function world:update(dt)
    timer.update(dt)
    
    --there's probably a better way to do this
    local boo=input:pressed("up") or input:pressed("down") or input:pressed("left") or input:pressed("right")

    if boo and pl.move then --check if input was pressed and check if the player can move (as in it isnt moving)
        local px,py=pl.x,pl.y --store the player's previous position

        --i think you know what these do :P 
        --i could use elseif but i want to allow people to do cool diagnal stuff (HELP I CANT SPELL TODAY)
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

        local v=pl.x<0 or pl.x>=map.width or pl.y<0 or pl.y>=map.height --check if the player is out of bounds

        if v then --if the player IS out of bounds move it back really fast :3
            pl.x=px
            pl.y=py
        else
            local t=map:getTileProperties("terrain",pl.x+1,pl.y+1) --get tile properties, specifially used to check for col property
            local u=map.layers["terrain"].data[pl.y+1][pl.x+1]==nil --check if there is a blank tile, will probably change to something more reliable later
            
            if t.col or u then --check if there is a wall or void tile, if so, move the player back to the previous position.
                pl.x=px
                pl.y=py
            else
                table.insert(pl.history,{x=px,y=py,id=map.layers["terrain"].data[py+1][px+1].gid,frame=pl.tile}) --player undo feature
                if #pl.history>5 then table.remove(pl.history,1) end --there is an undo limit of 5

                local fallTile = {x=px*size,y=py*size,tile=map.layers["terrain"].data[py+1][px+1].gid,s=1,t=1,r=0} -- falling tile animation
                table.insert(fallTiles, fallTile)

                timer.tween(0.3, fallTile, {y=fallTile.y+6,s=0.2,t=0,r=math.random(0,180)},"in-quad",function()
                    for i, ft in ipairs(fallTiles) do --i feel like there should be an easier way of doing this qwp
                        if ft == fallTile then
                            table.remove(fallTiles, i)
                            break
                        end
                    end
                end)

                map:setLayerTile("terrain",px+1,py+1,0) --make tile at players position disappear
                pl.move=false --player moved so make it unmoveable until animation is done
                timer.tween(0.15,pl,{dx=pl.x*size,dy=pl.y*size},"out-cubic",function() --the move to next position animation
                    pl.move=true --okii player can move again :3
                end)
                timer.tween(0.15/2,pl,{dz=-3},"out-cubic",function() --hop up
                    timer.tween(0.15/2,pl,{dz=0},"in-cubic") --hop down
                end)
                timer.tween(0.25,cam,{dx=pl.x*size-conf.gW/2+4,dy=pl.y*size-conf.gH/2+4},"out-cubic") --move camera, will probably change to different system later
            end
            
        end
    end

    if pl.move and input:pressed("undo") and #pl.history>0 then --undo stuff
        local h=pl.history[#pl.history] --makes life a bit easier to make locals

        table.remove(pl.history,#pl.history)
        map:setLayerTile("terrain",h.x+1,h.y+1,h.id) --change tile to previous state

        pl.x,pl.y,pl.tile=h.x,h.y,h.frame --move player back
        pl.move=false --cant move

        timer.tween(0.15,pl,{dx=h.x*size,dy=h.y*size},"in-cubic",function() --reverse anim of moving to new space
            pl.move=true
        end)
        timer.tween(0.15/2,pl,{dz=-3},"in-cubic",function() --hop x1
            timer.tween(0.15/2,pl,{dz=0},"out-cubic") --hop x2
        end)
        timer.tween(0.25,cam,{dx=pl.x*size-conf.gW/2+4,dy=pl.y*size-conf.gH/2+4},"in-cubic") --move camera
    end
    
    cam.dx=clamp(cam.dx,0,map.width*map.tilewidth-conf.gW) --clamp camera to map bounds
    cam.dy=clamp(cam.dy,0,map.height*map.tileheight-conf.gH) --ditto but y
end

local function drawMap(tilemap)
    for _, layer in ipairs(tilemap.layers) do
        if layer.visible and layer.opacity > 0 then
            map:drawLayer(layer)
        end
    end
end

function world:draw()
    beginDraw() --apply pixelated screen
        lg.clear(39/256,69/256,254/256) --blue color, will probably change later to more cool void-y effect

        local cx,cy=math.floor(-cam.dx),math.floor(-cam.dy) --camera position with floor
        --local cx,cy=-cam.dx,-cam.dy --camera position

        lg.push()
        lg.translate(cx,cy) --apply camera

            lg.setColor(0.1,0.5,1)
                spr(pl.tile,pl.dx,pl.dy+pl.dz+16,0,1,-1) --reflection, will probably get rid of later
            lg.setColor(1,1,1,1)

            for k,v in ipairs(fallTiles) do --drawing the falling tile effect
                lg.setColor(1,1,1,v.t)
                spr(v.tile-1,v.x+4,v.y+4,math.rad(v.r),v.s,v.s,4,4)
            end

            lg.setColor(0.7,0.7,0.8,1)
                drawMap(map) --draw map with offset to give it more of a 3d effect because yes
            lg.setColor(1,1,1,1)

            drawMap(map) --draw map normally

            lg.setColor(0,0,0,0.4)
                lg.rectangle("fill",pl.dx,pl.dy,8,8) --draw player shadow
            lg.setColor(1,1,1)

            spr(pl.tile,pl.dx,pl.dy+pl.dz) --draw player
            
        lg.pop()
        text.draw("RhelloNworldE i amNan WidiotE",0,0,15,0)
    endDraw()
end

return world