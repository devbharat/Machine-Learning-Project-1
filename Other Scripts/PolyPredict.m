function [prediction,evidence,alpha,beta,gamma,UnReducedParameters] = PolyPredict(PolyOrder)

global TrainingData
global ValidationData
global TestData
%global unreduced

DimTraining=size(TrainingData);
DimValidation=size(ValidationData);
DimTest=size(TestData);

Xtrain=TrainingData(:,1:(DimTraining(2)-1));
%MXtrain=repmat(mean(Xtrain),DimTraining(1),1);
%StdXtrain=repmat(std(Xtrain),DimTraining(1),1); 
%Xtrain=exp((Xtrain-MXtrain)./StdXtrain.^1)./StdXtrain.^2;

T=TrainingData(:,DimTraining(2));
MT=repmat(mean(T),DimTraining(1),1);
StdT=repmat(std(T),DimTraining(1),1);
Ttrain=(T-MT)./StdT;

%MXvalid=repmat(mean(ValidationData),DimValidation(1),1);
%StdXvalid=repmat(std(ValidationData),DimValidation(1),1); 
%Xvalid=exp((ValidationData-MXvalid)./StdXvalid.^1)./StdXvalid.^2;

MX=mean([Xtrain;ValidationData;TestData]);
StdX=std([Xtrain;ValidationData;TestData]);
Xtrain=(Xtrain-repmat(MX,DimTraining(1),1))./repmat(StdX,DimTraining(1),1).^2;
Xvalid=(ValidationData-repmat(MX,DimValidation(1),1))./repmat(StdX,DimValidation(1),1).^2;

MTvalid=repmat(mean(T),DimValidation(1),1);
StdTvalid=repmat(std(T),DimValidation(1),1);
%{
MXtest=repmat(mean(TestData),DimTest(1),1);
StdXtest=repmat(std(TestData),DimTest(1),1); 
Xtest=(TestData-MXtest)./StdXtest.^2.1;

MTtest=repmat(mean(T),DimTest(1),1);
StdTtest=repmat(std(T),DimTest(1),1);
%}
%[V,~]=eig(Xtrain'*Xtrain);

%Vreduced=V(:,(DimValidation(2)-PCAselection+1):DimValidation(2));
%Xreduced=Xtrain*Vreduced;

[Model,evidence,alpha,beta,gamma,UnReducedParameters]=LinearRegressor(Xtrain,Ttrain,'poly',PolyOrder);

PhiValid=DesignMatrix(Xvalid,'poly',PolyOrder);

prediction=(PhiValid*Model).*StdTvalid + MTvalid;

save PolyPrediction.csv prediction -ASCII

end