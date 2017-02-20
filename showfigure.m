function showfigure(adjMatrix, vertices, numOfDoors,input,img)
    fig = imshow(img);hold on;
    if(input<=numOfDoors && input >=0)
        for j=1:numOfDoors
            [cost,route] = dijkstra(adjMatrix,input,j);
            s = size(route,2);
            t = rand(1,3);
            for i=1:(s)
                if (i+1 <=s)
                    p1 = vertices(route(i),:);
                    p2 = vertices(route(i+1),:);
                    plot([p1(1),p2(1)],[p1(2),p2(2)],'Color',t,'LineWidth',1);
                end
            end
        end
    end
end