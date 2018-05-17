function [mat] = func2(mat)
global r;
global feature;
global data_base_no

x1 = [ zeros(r,1) ;mat(:,1)];
dxr = abs(mat(:,1)-x1(1:end-r));

y1 = [zeros(r,1);mat(:,2)];
dyr = abs(mat(:,2)-y1(1:end-r));

if(data_base_no == 3)
    p1 = [zeros(r,1);mat(:,3)];
    dpr = abs(mat(:,3)- p1(1:end-r));
else
    p1 = [zeros(r,1);mat(:,4)];
    dpr = abs(mat(:,4)- p1(1:end-r));
end


if(data_base_no ==1)
    az1 = [zeros(r,1);mat(:,5)];
    dazr = abs(mat(:,5)-az1(1:end-r));

    alt1 = [zeros(r,1);mat(:,6)];
    daltr = abs(mat(:,6)-alt1(1:end-r));
end
if(data_base_no ==3)
    az1 = [zeros(r,1);mat(:,4)];
    dazr = abs(mat(:,4)-az1(1:end-r));

    alt1 = [zeros(r,1);mat(:,5)];
    daltr = abs(mat(:,5)-alt1(1:end-r));
end

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
if(data_base_no~=2)
    mat = [mat dxr dyr dpr dazr daltr horzang ang d2xr d2yr];
end
if(data_base_no==2)
    mat = [mat dxr dyr dpr horzang ang d2xr d2yr];
end
mat = mat(:,feature);
mat = mat(r+1:end,:);