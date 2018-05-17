function [mat] = func(mat)
p = [0 ;mat(:,1)];
p = mat(:,1)-p(1:end-1);

q = [0;mat(:,2)];
q = mat(:,2)-q(1:end-1);
r = atan(q./p);
r(isnan(r))=0;

p1 = [0;p];
p1 = p-p1(1:end-1);
p1(1)=0;p1(2)=0;
q1 = [0;q];
q1 = q-q1(1:end-1);

mat = [mat p q r p1 q1];
mat=mat(:,[1:2 ,4,8:10 ]);