function [PObj,Obj]=Analyser(Designs,FN)

% This function analyses the deisngs and for each design returns the values of objective
% function and  penalized objective function
for I=1:size(Designs,1)
    A=Designs(I,:);
    [Obj(I,1),PObj(I,1),~]=eval([FN,'(A)']); % FN is the name of analyzer function
end
end
