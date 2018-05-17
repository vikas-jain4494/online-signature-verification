function [mat] = func3(mat)
r=5;
x1 = [ zeros(r,1) ;mat(:,1)];
dxr = abs(mat(:,1)-x1(1:end-r));

y1 = [zeros(r,1);mat(:,2)];
dyr = abs(mat(:,2)-y1(1:end-r));

p1 = [zeros(r,1);mat(:,3)];
dpr = abs(mat(:,3)- p1(1:end-r));

horzang = atan2(dyr,dxr);
horzang(isnan(horzang))=0;


dx1 = [0;dxr];
d2xr = abs(dxr-dx1(1:end-1));

dy1 = [0;dyr];
d2yr = abs(dyr-dy1(1:end-1));

n=size(mat,1);
ang=zeros(n,1);
for i=r+1:n-r
    x1=mat(i,1);y1=mat(i,2);x2=mat(i-r,1);y2=mat(i-r,2);x3=mat(i+r,1);y3=mat(i+r,2);
    ang(i,1)=atan2(abs((x2-x1)*(y3-y1)-(x3-x1)*(y2-y1)),((x2-x1)*(x3-x1)+(y2-y1)*(y3-y1)));
end

   
mat = [mat dxr dyr dpr horzang ang d2xr d2yr];
mat = mat(:,[1:2, 4,8:10,12]);
mat = mat(r+1:end-r,:);