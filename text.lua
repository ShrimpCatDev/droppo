local txt={}

function txt.init(a,b,letters)
    txt.letters={}
    for i=1,b-a+1 do
        txt.letters[string.sub(letters,i,i)]=a+i --lol ai
        print(string.sub(letters,i,i))
    end
end

function txt.draw(textVal,x,y,fg,bg)
    local p=0
    for i=0,string.len(textVal)-1 do
        local n=txt.letters[string.sub(textVal,i+1,i+1)]
        if bg then
            lg.setColor(pal:color(bg))
            lg.rectangle("fill",p*8+x,y,8,8)
        end
        lg.setColor(pal:color(fg))
            if n then
                spr(n-1,(p*8)+x,y)
            end
        lg.setColor(1,1,1,1)
        p=p+1
    end
end

return txt