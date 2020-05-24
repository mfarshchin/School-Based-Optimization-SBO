function [Designs,PObj,Obj]=Learning(LB,UB,Designs,Obj,PObj,FN)
%% This function applies learning method

for I=1:size(Designs,1)
    % Selection
    A=(randperm(size(Designs,1)))';
    First=A(1);
    Second=A(2);
    if PObj(First)>PObj(Second)
        First=A(2);
        Second=A(1);
    end
    BetterDesign=Designs(First,:);
    WorseDesign =Designs(Second,:);
    if rand<0.5
        NewDesigns(I,:)=WorseDesign +rand(1,size(Designs,2)).*(BetterDesign-WorseDesign);            % Move the worse towards the better
    else
        NewDesigns(I,:)=BetterDesign+rand(1,size(Designs,2)).*(BetterDesign-WorseDesign);            % Move the better farther from the worse
    end
end
%% Check feasibility of the designs
for i=1:size(Designs,1)
    for j=1:size(Designs,2)
        if NewDesigns(i,j)<LB(1,j)
            NewDesigns(i,j)=LB(1,j);
        elseif NewDesigns(i,j)>UB(1,j)
            NewDesigns(i,j)=UB(1,j);
        end
    end
end
          
%% Evaluate the designs generated in the previous iteration
[NPObj,NObj]=Analyser(NewDesigns,FN);
    
%% Check individuals for improvement
for I=1:size(Designs,1)
    if NPObj(I,1)<PObj(I,1)
        PObj(I,1)=NPObj(I,1);
        Obj(I,1)=NObj(I,1);
        Designs(I,:)=NewDesigns(I,:);
    end
end
