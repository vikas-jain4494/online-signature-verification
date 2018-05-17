function []=second()

global r;
global weight;
global wid;
global feature;
global data_base_no;

%SVC DATA BASE:
%1:x-coordinate 2:y-coordinate 3:pen up/down 4:pressure 5:azimuthal
%angle 6:altitute angle 7:time 8:Vx(abs(dxr)) 9:Vy(abs(dyr)) 10:abs(dPr)
%11:abs(dAZr) 12:abs(dALTr) 13:Slope(atan2(dyr/dxr)) 14:Turning angle
%15:ax(abs(d2xr)) 16:ay(abs(d2yr))

%SUSIG DATA BASE:
%1. x-coordinate 2. y-coordinate 3.stroke end points of pen up = 1 and pen down-0 just opposite
% to SVC2004 database 4. pressure 5. time 6:Vx(abs(dxr)) 7:Vy(abs(dyr)) 8:abs(dPr)
%9:Slope(atan2(dyr/dxr)) 10:Turning angle 11:ax(abs(d2xr)) 12:ay(abs(d2yr))

%MCYT DATA BASE:
% 1. x-coordinate 2. y-coordinate 3.pressure 4. azimuth angle 5. altitude
% 6:Vx(abs(dxr)) 7:Vy(abs(dyr)) 8:abs(dPr) 9:abs(dAZr) 10:abs(dALTr) 
%11:Slope(atan2(dyr/dxr)) 12:Turning angle 13:ax(abs(d2xr)) 14:ay(abs(d2yr))

data_base_no=1;
feature = [1:2,4,8:10,13];
no_train = 5;
codebook_size=32;
wid_total = [1 0.1 0.08 0.06 0.04];
weight= 0;
r_total=[1 5];
rounds=8;
users=1:40;


diary ('log.txt');
for t1 = wid_total
    for y = r_total
        r = y;
        wid =t1;
        fprintf('-------------------------------------Trail Starts----------------------------------------\n');
        fprintf('DATABASE NO: %d\n',data_base_no);
        if(wid==1)
            fprintf('TRADITIONAL DTW (WIDTH =1)\n');
        else
            fprintf('SEGMENTAL DTW (WIDTH= %g %% )\n',wid*100);
        end
        if(weight==0)
            fprintf('NO VQ\n');
        else
            fprintf('WITH VQ\n');
        end

        fprintf('Features selected: '); fprintf(num2str(feature));fprintf('\n');
        fprintf('No.of Training Signatures: %d\n',no_train);
        fprintf('No.of Trails: %d\n',rounds);
        fprintf('The value of r: %d\n',r);
        fprintf('codebooksize : %d \n\n', codebook_size);


        load GDatabase_task2;
        addpath(genpath('bosaris_toolkit'));
        SignDatabase=GDatabase(:,:,data_base_no);% 1 means SVC2004
        gen_cell=SignDatabase{1,1};% retrieving the genuine signature cell 
        forg_cell=SignDatabase{1,2};% retrieving the forgery signature cell 
        no_users=SignDatabase{1,3};% total users or signers in svc2004 database
        no_gen_sign=SignDatabase{1,4};% No. of genuine signatures per user
        no_forg_sign=SignDatabase{1,5};
        no_gen_test = no_gen_sign-no_train;

        gen_cell = cellfun(@func2,gen_cell,'UniformOutput',false);
        forg_cell = cellfun(@func2,forg_cell,'UniformOutput',false);

        gen =cellfun(@(A) bsxfun(@rdivide,bsxfun(@minus, A ,min(A)),max(A)-min(A)),gen_cell, 'UniformOutput',false);
        forg =cellfun(@(A) bsxfun(@rdivide,bsxfun(@minus, A ,min(A)),max(A)-min(A)),forg_cell,'UniformOutput',false);



        mat_a = zeros(rounds,no_train);
        if(data_base_no~=1)
            for i =1:rounds
                mat_a(i,:) = randperm(no_gen_sign,no_train);
            end
        else
            for i =1:rounds
                mat_a(i,:) = randperm(10,no_train);
            end
        end
        s = 0;
        for itr=1:rounds  
                a=mat_a(itr,:);
                b=1:no_gen_sign;
                b=setxor(b,a);
                eer_mat =zeros(1,no_users);
                for user =users
                    t=[gen{user,a(1)}',gen{user,a(2)}',gen{user,a(3)}',gen{user,a(4)}',gen{user,a(5)}'];
                    [code]=vqsplit(t,codebook_size);
                    mat1=zeros(no_train,no_gen_test);
                    mat2=zeros(no_train,no_forg_sign);
                    gen_ind_dst = cell(no_gen_sign,2);
                    forg_ind_dst = cell(no_forg_sign,2);
                    for i = 1:no_train
                        [gen_ind_dst{a(i),1},gen_ind_dst{a(i),2}] = VQIndex(gen{user,a(i)}',code);
                    end
                    for i = 1:no_gen_test
                        [gen_ind_dst{b(i),1},gen_ind_dst{b(i),2}] = VQIndex(gen{user,b(i)}',code);
                    end
                    for i = 1:no_forg_sign
                        [forg_ind_dst{i,1},forg_ind_dst{i,2}] = VQIndex(forg{user,i}',code);
                    end
                    for i=1:no_train
                        for j=1:no_gen_test
                            [bool]=VQCompare(gen_ind_dst{a(i),1},gen_ind_dst{b(j),1});
                            mat1(i,j)=dtw(gen{user,a(i)},gen{user,b(j)},bool);
                        end
                    end
                    for i=1:no_train
                        for j=1:no_forg_sign
                            [bool]=VQCompare(gen_ind_dst{a(i),1},forg_ind_dst{j,1});
                            mat2(i,j)=dtw(gen{user,a(i)},forg{user,j},bool);
                        end
                    end
                    [~,~,~,eer]=fastEval(-1*mean(mat1),-1*mean(mat2),0.1);
        %             if mod(count,8) == 0
        %                 fprintf('%d: %10.5g\n',user, eer);
        %             else
        %                 fprintf('%d: %10.5g \t',user, eer);
        %             end

        %             count = count+1;
                    eer_mat(1,user)=eer;
                end
                fprintf('\ntrain = ');fprintf(num2str(a));
                fprintf(' ->  MEER is ');disp(mean(eer_mat));
                s = s+ mean(eer_mat);
                fprintf('\n');
        end
        fprintf('\n The mean of %g rounds is %g \n',rounds,s/rounds);
        fprintf('-------------------------------------Trail Ends-----------------------------------\n\n');
    end
end
diary off


