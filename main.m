% s = xml2struct('C:\file_1.xml');
% img=imread('C:\file_1.tiff');
% numOfNodes = 1;
% numOfObjects = 1;
% for i=1:str2double(s.gom_dot_OHL.ov.Attributes.size)
%     temp = strcat(s.gom_dot_OHL.ov.o{i}.gom_dot_std_dot_OSymbol.Attributes.label,'extra');
%     if (strcmp(temp(1:4),'door') == 1)
%         doors(numOfNodes)=struct(s.gom_dot_OHL.ov.o{i}.gom_dot_std_dot_OSymbol.Attributes);
%         numOfNodes = numOfNodes + 1;
%     else
%         objects(numOfObjects)=struct(s.gom_dot_OHL.ov.o{i}.gom_dot_std_dot_OSymbol.Attributes);
%         numOfObjects = numOfObjects + 1;
%     end
% end
% for i=1:str2double(s.gom_dot_OHL.av.Attributes.size)
%     temp = strcat(s.gom_dot_OHL.av.a{i}.gom_dot_std_dot_OSymbol.Attributes.label,'extra');
%     if (strcmp(temp(1:4),'door') == 1)
%         doors(numOfNodes)=struct(s.gom_dot_OHL.av.a{i}.gom_dot_std_dot_OSymbol.Attributes);
%         numOfNodes = numOfNodes + 1;
%     else
%         objects(numOfObjects)=struct(s.gom_dot_OHL.av.a{i}.gom_dot_std_dot_OSymbol.Attributes);
%         numOfObjects = numOfObjects + 1;
%     end
% end
% numOfNodes = numOfNodes - 1;
% numOfObjects = numOfObjects - 1;
% numOfDoors = numOfNodes;
% vertices = [];
% for i=1:numOfNodes
%     if (str2double(doors(i).direction) == 0)
%         vertices=[vertices;(str2double(doors(i).x0)+str2double(doors(i).x1))/2, str2double(doors(i).y1)];
%     end
%     if (str2double(doors(i).direction) == 90)
%         vertices=[vertices;str2double(doors(i).x0), (str2double(doors(i).y0)+str2double(doors(i).y1))/2];
%     end
%     if (str2double(doors(i).direction) == 180)
%         vertices=[vertices;(str2double(doors(i).x0)+str2double(doors(i).x1))/2, str2double(doors(i).y0)];
%     end
%     if (str2double(doors(i).direction) == 270)
%         vertices=[vertices;str2double(doors(i).x1), (str2double(doors(i).y0)+str2double(doors(i).y1))/2];
%     end
% end
% for i=1:numOfObjects
%     vertices=[vertices;str2double(objects(i).x0), str2double(objects(i).y0)];
%     vertices=[vertices;str2double(objects(i).x0), str2double(objects(i).y1)];
%     vertices=[vertices;str2double(objects(i).x1), str2double(objects(i).y0)];
%     vertices=[vertices;str2double(objects(i).x1), str2double(objects(i).y1)];
% end
% im = img;
% for i=1:numOfDoors
%     for j=round(str2double(doors(i).x0)):round(str2double(doors(i).x1))
%         for k=round(str2double(doors(i).y0)):round(str2double(doors(i).y1))
%             im(k,j) = 255;
%         end
%     end
% end
% I=im;
% for i=1:numOfObjects
%     for j=round(str2double(objects(i).x0)):round(str2double(objects(i).x1))
%         for k=round(str2double(objects(i).y0)):round(str2double(objects(i).y1))
%             im(k,j) = 0;
%         end
%     end
% end
% %im = imgaussfilt(im,[4 4]);
% %I = imdilate(img,strel('disk',10));
% %I = imerode(I,strel('square',17));
% corners = detectHarrisFeatures(im);
% corners=corners.selectStrongest(1000);
% corners = corners.Location;
% vertices=[vertices;corners];
% numOfNodes = numOfNodes + size(corners,1) + 4*numOfObjects;
% %I = imdilate(I,strel('disk',2));
% %im = imerode(im,strel('disk',1));
% im = imdilate(im,strel('disk',2));
% adjMatrix = [];
% for i=1:numOfNodes
%     for j=1:numOfNodes
%         if (i ==j)
%             adjMatrix(i,j) = 0;
%         elseif (isvisible(vertices(i,:),vertices(j,:),im))
%             adjMatrix(i,j) = sqrt((vertices(i,1)-vertices(j,1)).^2 +(vertices(i,2)-vertices(j,2)).^2);
%         else
%             adjMatrix(i,j) = 0;
%         end
%     end
% end
% fig = imshow(img);hold on;






% input source door number 

input =3;

% fetch useful information from xml file. 

img=imread('C:\file_2.tiff');
s = xml2struct('C:\file_2.xml');
[adjMatrix, vertices, numOfDoors, doors] = working(img,s);
fig = imshow(img);hold on;

% to draw door number and circle(on number). just to know the door number in figure 

for i=1:numOfDoors
    txt = num2str(i);
    viscircles([(str2double(doors(i).x0)+str2double(doors(i).x1))/2,(str2double(doors(i).y0)+str2double(doors(i).y1))/2],50);
    text((str2double(doors(i).x0)+str2double(doors(i).x1))/2,(str2double(doors(i).y0)+str2double(doors(i).y1))/2,txt,'Color','blue');
end

% To draw the sortest path(given by dijkstra) from source door to every other door with different colour lines 
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
