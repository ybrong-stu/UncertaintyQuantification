function [R,Rfit] = main
%% Return
% R -- the solutions to indicate which transformed images are selected.
% Rfit -- the mae and 1-upcc values for each solution. 

%% data
load('FaceAgeVal');
% Res.pres-- a VxN martix, where V is the number of images, N is the
% number of predictions obtained by a trained model performed on the N
% transformed versions of each image. 
% Res.gts--a Vx1 vector, the ground truth for each image.

%% parameters

Np = 10;        % Population size
pc = 0.9;        % Probability of crossover
pm = 0.09;        % Probability of mutation
numbits = 5;       % for mutation
maxgen = 1000;    % Maximum number of generations
gts = Res.gts;
nVar = size(Res.pres,2);



%% Initialization
gen   = 1;
P = rand(Np,nVar);
P(P >= 0.9) = 1;
P(P < 0.9) = 0;
Pfit = zeros(Np,2);
for i = 1:Np
    ths = P(i,:) == 1;
    pres = Res.pres(:,ths);
    mpres = mean(pres,2); 
    vpres = std(pres,0,2);
    mmae = mean(abs(mpres-gts));
    upcc = Pcc(vpres,abs(mpres-gts));   
    Pfit(i,1) = mmae;
    Pfit(i,2) = 1-upcc;
end
Prank = FastNonDominatedSorting_Vectorized(Pfit);
[P,~,Pfit] = selectParentByRank(P,Prank,Pfit);
Q = applyCrrossoverAndMutation(P,pc,pm,numbits);

% Plotting and verbose

h_fig = figure(1);
h_par=scatter(Pfit(:,1),Pfit(:,2),20,'filled', 'markerFaceAlpha',0.3,'MarkerFaceColor',[128 193 219]./255); hold on;
h_rep = plot(Pfit(:,1),Pfit(:,2),'ok'); hold on;
grid on; xlabel('mae'); ylabel('1-upcc');
drawnow;
axis square;
display(['Generation #' num2str(gen) ' - First front size: ' num2str(sum(Prank==1))]);    

Qfit = zeros(Np,2);
for i = 1:Np
    pop = Q(i,:);
%     pop(pop>0.9) = 1;
%     pop(pop<=0.9) = 0;
    ths = pop == 1;
    pres = Res.pres(:,ths);
    mpres = mean(pres,2); 
    vpres = std(pres,0,2);
    mmae = mean(abs(mpres-gts));
    upcc = Pcc(vpres,abs(mpres-gts));   
    Qfit(i,1) = mmae;
    Qfit(i,2) = 1-upcc;
end
 
R = [P; Q];
Rfit = [Pfit;Qfit];

%% Main NSGA-II loop
stopCondition = false;
while ~stopCondition
     fprintf([ num2str(gen) '/' num2str(maxgen) '\n']);
      Rrank = FastNonDominatedSorting_Vectorized(Rfit);
      
       figure(h_fig); delete(h_rep);
       h_par=scatter(Rfit(:,1),Rfit(:,2),20,'filled', 'markerFaceAlpha',0.3,'MarkerFaceColor',[128 193 219]./255); hold on;
       h_rep = plot(Rfit(:,1),Rfit(:,2),'ok'); hold on;
       grid on; xlabel('mae'); ylabel('1-upcc');
       drawnow;
       axis square;
       display(['Generation #' num2str(gen) ' - First front size: ' num2str(sum(Rrank==1))]);
      
     [Rrank,idx] = sort(Rrank,'ascend');
      Rfit = Rfit(idx,:);
      R = R(idx,:);
      [Rcrowd,Rrank,~,R] = crowdingDistances(Rrank,Rfit,R);
      P = selectParentByRankAndDistance(Rcrowd,Rrank,R);
      Q = applyCrrossoverAndMutation(P,pc,pm,numbits);
      R = [P;Q];
      Rfit = zeros(2*Np,2);
      for i = 1:2*Np
           pop = R(i,:);
%            pop(pop>0.9) = 1;
%            pop(pop<=0.9) = 0;
           ths = pop == 1;
           pres = Res.pres(:,ths);
           mpres = mean(pres,2); 
           vpres = std(pres,0,2);
           mmae = mean(abs(mpres-gts));
           upcc = Pcc(vpres,abs(mpres-gts));  
           Rfit(i,1) = mmae;
           Rfit(i,2) = 1-upcc;
       end
       gen = gen + 1;
       if(gen>maxgen), stopCondition = true; end
end

    

