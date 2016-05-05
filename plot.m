pl1fileID = fopen('pl1.txt','r');
pl2fileID = fopen('pl2.txt','r');
arraytimefileID = fopen('arraytime.txt','r');


formatSpec = '%f';
y1 = fscanf(pl1fileID,formatSpec);
y2 = fscanf(pl2fileID,formatSpec);
%x = fscanf(arraytimefileID,formatSpec);
x=zeros(500);

for n=1:1:500
    x(n) = x(n) + 0.283200;
end


%plot(x,y1);