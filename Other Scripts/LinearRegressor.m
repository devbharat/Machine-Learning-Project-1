function [m,ev,a,b,g,UnreducedParameters]=LinearRegressor(X,T,basis,M)
%X is Nx(# of features)
%T is Nx1

%global TrainingData ValidationData TestData
%global unreduced

%DimTraining=size(TrainingData);
%DimValidation=size(ValidationData);
%DimTest=size(TestData);

N=length(X);

a=1e-6;
b=1e-6;
g=1e-6;

unreducedPhi=DesignMatrix(X,basis,M);
Moriginal=size(unreducedPhi);
%PhiT=Phi';%MeffxN matrix
%PhiTPhi=(Phi')*Phi; %MeffxM matrix
%L=eig(PhiTPhi);%Meffx1 vector

%ReducePhi(DesignMatrix([X;Xvalid;Xtest],basis,M));
%Phi=Phi(:,unreduced);

[Phi,reducedV]=ReducePhi(unreducedPhi);

PhiT=Phi';
PhiTPhi=(Phi')*Phi;
L=eig(PhiTPhi);

Mreduced=size(Phi);

eps=1;while eps>10^-5

    Si=a*eye(Mreduced(2))+b*PhiTPhi;

    m=Si\(b*PhiT*T);%Mx1 vector

    gold=g;
    g=sum(b*L./(b*L+a));
 
    a=g/(m'*m);
    b=(N-g)/sum((T-Phi*m).^2);
    
    eps=abs(g-gold)/gold;
    end
       

ev=Evidence(a,b,m,Si,Phi,T);
UnreducedParameters=Mreduced(2);

m=reducedV*m;
end

function ev = Evidence(a,b,m,Si,Phi,T)

M=length(m);
N=length(T);
ev=(M/2)*log(a)+(N/2)*log(b)-E(a,b,m,Phi,T)-(1/2)*log(det(Si))-(N/2)*log(2*pi);

end

function e = E(a,b,m,Phi,T)

e=(b/2)*norm(T-Phi*m)^2+(a/2)*(m')*m;

end