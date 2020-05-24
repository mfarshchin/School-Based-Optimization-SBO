function [NewBest,Designs,PObj,Obj,WMeanPos]=Specifier(PObj,Obj,Designs,PreviousBest)

%% This function is to find the best individuals in the current population and compare them with the previous ones

%% Sort new results
[~,b]=sort(PObj);                                                          % Sort Penalized objective values
Designs=Designs(b,:);                                                      % Sorted designs
Obj=Obj(b,:);                                                              % Sorted objectives
PObj=PObj(b,:);                                                            % Sorted penalized objectives

%% Find the position of weighted mean XX(i)=sum(X(i)/Fit(i))/sum(1/Fit(i))
A=sum(1./PObj);
for I=1:size(Designs,1)
    B(I,:)=Designs(I,:)./PObj(I);
end
WMeanPos=sum(B)/A;                                                         % Weighted mean position

%% Find the bests
GBest.PObj=PObj(1);                                                        % Current best
GBest.Obj=Obj(1);                                                          % Current best
GBest.Design=Designs(1,:);                                                 % Current best

%% Compare the current bests with previous ones

if isempty(PreviousBest)==1
    NewBest.GBest=GBest;
elseif GBest.PObj<PreviousBest.GBest.PObj
    NewBest.GBest=GBest;
else
    NewBest.GBest=PreviousBest.GBest;
end

%% Keep the bests in the population
K=0;
for I=1:size(Designs,1)
    if sum(Designs(I,:)==NewBest.GBest.Design)==size(Designs,2)
        K=K+1;
    end
end

if K==0
    % Replace the one with the closest objective value
    % Find the one that has the closes objective value
    [a,b]=min(abs(PObj-NewBest.GBest.PObj));
    Designs(b(1),:)=NewBest.GBest.Design;
    PObj(b(1))=NewBest.GBest.PObj;
    Obj(b(1))=NewBest.GBest.Obj;
end






