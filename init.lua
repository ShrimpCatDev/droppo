conf=require 'config'

lg  = love.graphics
lk  = love.keyboard
lm  = love.mouse
la  = love.audio
lf  = love.filesystem
lt  = love.timer
lw  = love.window
lp  = love.physics
li  = love.image

gs=require "lib.hump.gamestate"
gs.registerEvents()

shove=require 'lib.shove'
baton=require 'lib.baton'
color=require 'lib.hex2color'
require 'lib.func'

input=baton.new(conf.input)

shove.setResolution(conf.gW,conf.gH,{fitMethod=conf.fit,scalingFilter=conf.textureFilter,renderMode=conf.render})
shove.setWindowMode(conf.wW,conf.wH,{resizable=true,vsync=conf.vsync})

lg.setLineStyle("rough")
