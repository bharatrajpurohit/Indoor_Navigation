function visible=isvisible(startp,endp,img)
    %num=round(sqrt((startp(1)-endp(1)).^2 + (startp(2)-endp(2)).^2));
    sz = size(img);
    num=round(sqrt((sz(1)).^2 + (sz(2)).^2));
    visible = true;
    if (startp(1) ~= endp(1) || startp(2) ~= endp(2))    
        [x,y]=fillline(startp,endp,num);
        x=round(x);
        y=round(y);
        for i=1:num
            if (img(y(i),x(i))==0)
                visible = false;
                break;
            end;
        end
    end
end