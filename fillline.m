% take starting, ending point & number of points in between
% make line to connect between 2 coordinates
function [xx,yy]=fillline(startp,endp,pts)
        m=(endp(2)-startp(2))/(endp(1)-startp(1)); %gradient 

        if (endp(1)==startp(1)) %vertical line
            xx(1:pts)=startp(1);
            yy=linspace(startp(2),endp(2),pts);
        elseif (endp(2)==startp(2)) %horizontal line
            xx=linspace(startp(1),endp(1),pts);
            yy(1:pts)=startp(2);
        else %if (endp(1)-startp(1))~=0
            xx=linspace(startp(1),endp(1),pts);
            yy=m*(xx-startp(1))+startp(2);
        end
end
