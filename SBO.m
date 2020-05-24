function SBO

%% This function implements the basic School Based Optimization (SBO) algorithm for 10-bar truss optimization
% For more information about this method and other algorithms check the following papers: 
% References: 
% 1: School based optimization algorithm for design of steel frames (https://www.sciencedirect.com/science/article/pii/S0141029617308787)
% 2: Optimal design of truss structures for size and shape with frequency
% constraints using a collaborative optimization strategy (https://www.sciencedirect.com/science/article/pii/S0957417416304900)
% 3: Multi-class teaching-learning-based optimization for truss design with
% frequency constraints  (http://www.sciencedirect.com/science/article/pii/S0141029615006732)
% 4: Design of space trusses using modified teaching learning based
% optimization (http://www.sciencedirect.com/science/article/pii/S0141029614000236)
% Programmer: Mohammad Farshchin, Ph.D
% Email: Mohammad.Farshchin@gmail.com
% Last modified: Jan 2019
%%

global D
% Specity SBO parameters
Itmax=300;                                                                 % Maximum number of iterations
NClass=5;                                                                  % Number of classes in the school
PopSize=15;                                                                % Population size of each class
% Optimization problem parameters
D=Data10;                                                                  % For truss function evaluate the functio to get the initial parameters
LB=D.LB;                                                                   % Lowerbound
UB=D.UB;                                                                   % Upperbound
FN='ST10';                                                                 % Name of analyzer function

%% Randomely generate initial designs between LB and UB
Cycle=1;
for I=1:PopSize
    for NC=1:NClass
        Designs{NC}(I,:)=LB+rand(1,size(LB,2)).*(UB-LB);                   % Row vector
    end
end

% Analysis the designs
for NC=1:NClass
    [PObj{NC},Obj{NC}]=Analyser(Designs{NC},FN);
    Best{NC}=[];
end

%% SBO loop
for Cycle=2:Itmax
    for NC=1:NClass
        % Identify best designs and keep them
        [Best{NC},Designs{NC},PObj{NC},Obj{NC},WMeanPos{NC}]=Specifier(PObj{NC},Obj{NC},Designs{NC},Best{NC});
        TeachersPObj(NC,1)=Best{NC}.GBest.PObj;
        TeachersDes(NC,:)=Best{NC}.GBest.Design;
    end
    for NC=1:NClass
        % Select a teacher
        SelectedTeacher=TeacherSelector(Best,NC,TeachersPObj);
        % Apply Teaching
        [Designs{NC},PObj{NC},Obj{NC}]=Teaching(LB,UB,Designs{NC},PObj{NC},Obj{NC},TeachersDes(SelectedTeacher,:),WMeanPos{NC},FN);
        [Best{NC},Designs{NC},PObj{NC},Obj{NC},WMeanPos{NC}]=Specifier(PObj{NC},Obj{NC},Designs{NC},Best{NC});
        % Apply Learning
        [Designs{NC},PObj{NC},Obj{NC}]=Learning(LB,UB,Designs{NC},Obj{NC},PObj{NC},FN);
        [Best{NC},Designs{NC},PObj{NC},Obj{NC},WMeanPos{NC}]=Specifier(PObj{NC},Obj{NC},Designs{NC},Best{NC});
    end
    % Find best so far solution and Mean
    CumPObj=[];
    for NC=1:NClass
        ClassBestPObj(NC,1)=Best{NC}.GBest.PObj;
        ClassMean(NC,1)=mean(PObj{NC});
        CumPObj=[CumPObj;PObj{NC}];
    end
    [~,b]=min(ClassBestPObj);
    OveralBestPObj=Best{b}.GBest.PObj;
    OveralBestObj=Best{b}.GBest.Obj;
    OveralBestDes=Best{b}.GBest.Design;
    % Plot time history of the best solution vs. iteration and print the
    % results
    hold on;plot(Cycle,Best{b}.GBest.PObj,'b*');xlabel('Iteration');ylabel('Best solution value');pause(0.0001)
    fprintf('Cycle: %6d, Best (Penalized): %6.4f, Objective: %6.4f\n',Cycle,OveralBestPObj,OveralBestObj);    
end

Solution.PObj=OveralBestPObj;% Objective value for best non-penalized solution
Solution.Design=OveralBestDes;% Design for best non-penalized solution

%% Save the results
save('SBO_Results.mat','Solution')
