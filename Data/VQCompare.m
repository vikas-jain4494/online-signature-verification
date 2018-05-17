function [boolmat] = VQCompare(Ind_dst1, Ind_dst2)
n1 = length(Ind_dst1);
n2 = length(Ind_dst2);
boolmat = zeros(n1,n2);
for i=1:n1
    for j= 1:n2
        if (Ind_dst1(i)~= Ind_dst2(j))
            boolmat(i,j) = 1;
        end
    end
end