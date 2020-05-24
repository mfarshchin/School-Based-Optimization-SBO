function [Designs,PObj,Obj]=Teaching(LB,UB,Designs,PObj,Obj,Teacher,WMeanPos,FN)
%% This function applies teaching method


for I=1:size(Designs,1)
    TF=randi([1,2],1,size(Teacher,2));
    Diff_Mean=rand(1,size(Teacher,2)).*TF.*(Teacher-WMeanPos);
    NewDesigns(I,:)=Designs(I,:)+sign(Teacher-Designs(I,:)).*abs(Diff_Mean);
end

%% Check feasibility of the designs
for i=1:size(Designs,1)
    for j=1:size(Teacher,2)
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

    
