
load GDatabase_task2;

SignDatabase=GDatabase(:,:,1);% 1 means SVC2004
gen_cell=SignDatabase{1,1};% retrieving the genuine signature cell 
forg_cell=SignDatabase{1,2};% retrieving the forgery signature cell 
users=SignDatabase{1,3};% total users or signers in svc2004 database
no_gen_sign=SignDatabase{1,4};% No. of genuine signatures per user
no_forg_sign=SignDatabase{1,5};


addpath(genpath('D:\7th sem\btp\data\bosaris_toolkit'));
users=1:10;
codebook_size=2;
gen_cell = cellfun(@func,gen_cell,'UniformOutput',false);
forg_cell = cellfun(@func,forg_cell,'UniformOutput',false);
gen=gen_cell;
forg=forg_cell;
 gen  = cellfun(@(A) bsxfun(@rdivide,bsxfun(@minus, A ,min(A)),max(A)-min(A)),gen_cell, 'UniformOutput',false);
forg = cellfun(@(A) bsxfun(@rdivide,bsxfun(@minus, A ,min(A)),max(A)-min(A)),forg_cell,'UniformOutput',false);
s=size(gen);
% for i=1:s(1)
%     for j=1:s(2)
%         matrix=cell2mat(gen_cell(i,j));
%         mini=min(matrix);
%         maxi=max(matrix);
%         s1=size(matrix);
%         for p=1:s1(1)
%             for q=1:s1(2)
%                 matrix(p,q)=(matrix(p,q)-mini(q))/(maxi(q)-mini(q));
%             end
%         end
%         gen{i,j}=matrix;
%     end
% end
% for i=1:s(1)
%     for j=1:s(2)
%         matrix=cell2mat(forg_cell(i,j));
%         mini=min(matrix);
%         maxi=max(matrix);
%         s1=size(matrix);
%         for p=1:s1(1)
%             for q=1:s1(2)
%                 matrix(p,q)=(matrix(p,q)-mini(q))/(maxi(q)-mini(q));
%             end
%         end
%         forg{i,j}=matrix;
%     end
% end
% a=randperm(20,5)
a=[13,1,15,11,4];
b=1:20;
b=setxor(b,a);
eer_mat =zeros(1,1);
for user =users
    t=[gen{user,a(1)}',gen{user,a(2)}',gen{user,a(3)}',gen{user,a(4)}',gen{user,a(5)}'];
    [code]=vqsplit(t,codebook_size);
    mat1=zeros(5,15);
    mat2=zeros(5,20);
    gen_ind_dst = cell(20,2);
    forg_ind_dst = cell(20,2);
    for i = 1:5
        [gen_ind_dst{a(i),1},gen_ind_dst{a(i),2}] = VQIndex(gen{user,a(i)}',code);
    end
    for i = 1:15
        [gen_ind_dst{b(i),1},gen_ind_dst{b(i),2}] = VQIndex(gen{user,b(i)}',code);
    end
    for i = 1:20
        [forg_ind_dst{i,1},forg_ind_dst{i,2}] = VQIndex(forg{user,i}',code);
    end
    for i=1:5
        for j=1:15
            [bool]=VQCompare(gen_ind_dst{a(i),1},gen_ind_dst{b(j),1});
            mat1(i,j)=dtw(gen{user,a(i)},gen{user,b(j)},bool);
        end
    end
    for i=1:5
        for j=1:20
            [bool]=VQCompare(gen_ind_dst{a(i),1},forg_ind_dst{j,1});
            mat2(i,j)=dtw(gen{user,a(i)},forg{user,j},bool);
        end
    end
    %min(mat1)
    %min(mat2)
    [~,~,~,eer]=fastEval(-1*mean(mat1),-1*mean(mat2),0.1);
    eer
    eer_mat(1,user)=eer;
end

