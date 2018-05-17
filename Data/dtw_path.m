function [wpath_indx] = dtw_path(acc_cost_mat)
%% Warping path between two signature
p=size(acc_cost_mat,1);q=size(acc_cost_mat,2);i=2;
wpath_indx(:,1)=[p;q];
while(p>1&&q>1)
    mat=[acc_cost_mat(p-1,q),acc_cost_mat(p-1,q-1),acc_cost_mat(p,q-1)];
    inx_mat=[p-1,p-1,p;q,q-1,q-1];
    [~, ind]=min(mat);
    indx=inx_mat(:,ind);
    wpath_indx(:,i)=indx;
    i=i+1;
    p=indx(1);
    q=indx(2);
end
if(p==1)
    inx2=q-1:-1:1;
    mat=[ones(1,q-1);inx2];
    wpath_indx=[wpath_indx mat];
else
    inx1=p-1:-1:1;
    mat=[inx1;ones(1,p-1)];
    wpath_indx=[wpath_indx mat];
end
end

