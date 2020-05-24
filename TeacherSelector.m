function Teacher=TeacherSelector(Best,Sc,TeachersPObj)
% This function specifies the teachers that are better than the current
% teacher for each class
CurrentPObj=Best{Sc}.GBest.PObj;
K=0;
for I=1:size(TeachersPObj,1)
    if TeachersPObj(I,1)<=CurrentPObj
        K=K+1;
        List(K,1)=I;
    end
end

% Use roulette wheel function to select one of the better teachers
FitSelTeachPObj=(TeachersPObj(List)).^-1;
CumulFit=cumsum(FitSelTeachPObj);

A=Roulette(CumulFit/max(CumulFit));
Teacher=List(A);
end
% Roulette wheel Function
function out=Roulette(Fitness)
out=0;
R=rand;
while R>Fitness(out+1)
    out=out+1;
end
out=out+1;
end