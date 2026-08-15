local txt={}

function txt.init(a,b,letters)
    txt.letters={}
    for i=1,b-a+1 do
        txt.letters[string.sub(letters,i,i)]=a+i --lol ai
    end
end

function txt.draw(textVal,x,y,fg,bg)
    local p=0
    local line=0
    local active_effect="" --gotta start differentiating locals from globals
    local color=fg

    for i=0,string.len(textVal)-1 do
        local ox,oy=0,0
        local letter=string.sub(textVal,i+1,i+1)
        
        if letter=="N" then 
            line=line+1
            p=0
        elseif letter=="W" then
            active_effect="wave"
        elseif letter=="R" then
            active_effect="rainbow"
        elseif letter=="E" then
            active_effect=""
            color=fg
        else
            if active_effect=="wave" then
                oy=math.cos((love.timer.getTime()*10)+(p*0.8))*2
            elseif active_effect=="rainbow" then
                color=math.floor(love.timer.getTime()*16+i)%15+1
            end

            local n=txt.letters[letter]
            if bg then
                lg.setColor(pal:color(bg))
                lg.rectangle("fill",p*8+x,y+(line*8)+oy,8,8)
            end
            lg.setColor(pal:color(color))
            if n then
                spr(n-1,(p*8)+x,y+(line*8)+oy)
            end
            lg.setColor(1,1,1,1)
            p=p+1 
        end
    end
end

return txt