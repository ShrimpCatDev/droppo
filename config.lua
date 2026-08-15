local conf = {}

conf.gW = 144
conf.gH = 80

conf.wW = conf.gW*5
conf.wH = conf.gH*5

conf.textureFilter = "nearest"
conf.fit = "aspect"
conf.render="layer"
conf.vsync=true

conf.input={
    controls={
        up={"key:up"},
        down={"key:down"},
        left={"key:left"},
        right={"key:right"},
        undo={"key:z"},
        build={"key:x"}
    },
    pairs={

    },
    joystick = love.joystick.getJoysticks()[1],
}

return conf