function [adjMatrix, vertices, numOfDoors, doors] = working(img,s)
    adjMatrix = [];
    vertices = [];
    %s = xml2struct('C:/file_3.xml');
    %img=imread('C:/file_3.tiff');
    numOfNodes = 1;
    numOfObjects = 1;
    for i=1:str2double(s.gom_dot_OHL.ov.Attributes.size)
        temp = strcat(s.gom_dot_OHL.ov.o{i}.gom_dot_std_dot_OSymbol.Attributes.label,'extra');  % appending word 'extra' after name of all objects present in xml file
 
        if (strcmp(temp(1:4),'door') == 1)
            doors(numOfNodes)=struct(s.gom_dot_OHL.ov.o{i}.gom_dot_std_dot_OSymbol.Attributes);  % to get all the doors from xml file
            numOfNodes = numOfNodes + 1;
        else
            objects(numOfObjects)=struct(s.gom_dot_OHL.ov.o{i}.gom_dot_std_dot_OSymbol.Attributes); % to get all the object other then doors.
            numOfObjects = numOfObjects + 1;
        end
    end

% As there are two type of objects in xml file so same code for another one 

    for i=1:str2double(s.gom_dot_OHL.av.Attributes.size)
        temp = strcat(s.gom_dot_OHL.av.a{i}.gom_dot_std_dot_OSymbol.Attributes.label,'extra');
        if (strcmp(temp(1:4),'door') == 1)
            doors(numOfNodes)=struct(s.gom_dot_OHL.av.a{i}.gom_dot_std_dot_OSymbol.Attributes);
            numOfNodes = numOfNodes + 1;
        else
            objects(numOfObjects)=struct(s.gom_dot_OHL.av.a{i}.gom_dot_std_dot_OSymbol.Attributes);
            numOfObjects = numOfObjects + 1;
        end
    end
    numOfNodes = numOfNodes - 1;
    numOfObjects = numOfObjects - 1;
    numOfDoors = numOfNodes;
% to extract the middle point of doors according to their directions   

    for i=1:numOfNodes
        if (str2double(doors(i).direction) == 0)
            vertices=[vertices;(str2double(doors(i).x0)+str2double(doors(i).x1))/2, str2double(doors(i).y1)];
        elseif (str2double(doors(i).direction) == 90)
            vertices=[vertices;str2double(doors(i).x0), (str2double(doors(i).y0)+str2double(doors(i).y1))/2];
        elseif (str2double(doors(i).direction) == 180)
            vertices=[vertices;(str2double(doors(i).x0)+str2double(doors(i).x1))/2, str2double(doors(i).y0)];
        elseif (str2double(doors(i).direction) == 270)
            vertices=[vertices;str2double(doors(i).x1), (str2double(doors(i).y0)+str2double(doors(i).y1))/2];
        else
            vertices=[vertices;(str2double(doors(i).x0)+str2double(doors(i).x1))/2, (str2double(doors(i).y0)+str2double(doors(i).y1))/2];
        end
    end

% to get the coordinate of remaining objects

    for i=1:numOfObjects
        vertices=[vertices;str2double(objects(i).x0), str2double(objects(i).y0)];
        vertices=[vertices;str2double(objects(i).x0), str2double(objects(i).y1)];
        vertices=[vertices;str2double(objects(i).x1), str2double(objects(i).y0)];
        vertices=[vertices;str2double(objects(i).x1), str2double(objects(i).y1)];
    end
    im = img;

% to remove the door from temporary image

    for i=1:numOfDoors
        for j=round(str2double(doors(i).x0)):round(str2double(doors(i).x1))
            for k=round(str2double(doors(i).y0)):round(str2double(doors(i).y1))
                im(k,j) = 255;
            end
        end
    end

% to make remaining objects complete black(to reduce no of corners ) from temporary image
    I=im;
    for i=1:numOfObjects
        for j=round(str2double(objects(i).x0)):round(str2double(objects(i).x1))
            for k=round(str2double(objects(i).y0)):round(str2double(objects(i).y1))
                im(k,j) = 0;
            end
        end
    end
   


% to detect corners in image
    corners = detectHarrisFeatures(im);
% to select strongest 1000 corners among all the corners
    corners=corners.selectStrongest(1000);
% to get location of the corners and add them into array named 'vertices'
    corners = corners.Location;
    vertices=[vertices;corners];

    numOfNodes = numOfNodes + size(corners,1) + 4*numOfObjects;
    
    im = imdilate(im,strel('disk',2));

% till now we have all the doors,objects and corners as nodes in a graph and now we are going to add edge between them 
% isvisible func is to check whether is it possible to draw an edge between any two nodes or not
% if there is any wall or objects in that path then just make that edge weight =0(edge not possible) 
% if edge is possible then we are adding an edge with value = distance between those two points.
 
    for i=1:numOfNodes
        for j=1:numOfNodes
            if (i ==j)
                adjMatrix(i,j) = 0;
            elseif (isvisible(vertices(i,:),vertices(j,:),im))
                adjMatrix(i,j) = sqrt(((vertices(i,1)-vertices(j,1)).^2) +((vertices(i,2)-vertices(j,2)).^2));
            else
                adjMatrix(i,j) = 0;
            end
        end
    end
end

% Now this matrix will be used in Dijkstra's algorithm.

