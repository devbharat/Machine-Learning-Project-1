function [reducedPhi,reducedV] = ReducePhi(Phi)

%global unreduced
%Meff=size(Phi);

[~,S,V]=svd(Phi);
Svalues=diag(S)';

%Mreduced=sum((Svalues')>quantile(Svalues,0.1));

Mreduced=min(length(Svalues),round(1/(-(1/length(Svalues)*log(Svalues(1,end)/Svalues(1,1))))));

reducedV=V(:,1:Mreduced);

reducedPhi=Phi*reducedV;

%{
PhiSize=sqrt(sum(Phi.^2));
reducedPhiSize=sqrt(sum(reducedPhi.^2));

unreduced=1:Meff(2);

i=1;reduce=[];while i<=Meff(2)
        if reducedPhiSize(1,i) < 0.1*PhiSize(1,i)        
            reduce(1,end+1)=i;        
        end
        i=i+1;
end

unreduced(:,reduce)=[];
        
%reducedPhi=Phi(:,unreduced); 
%}

end