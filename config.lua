local conf = {}

conf.gW = 256
conf.gH = 144

conf.wW = conf.gW*5
conf.wH = conf.gH*5

conf.textureFilter = "nearest"
conf.fit = "aspect"
conf.render="layer"
conf.vsync=true

conf.input={
    controls={

    },
    pairs={

    },
    joystick = love.joystick.getJoysticks()[1],
}

return conf