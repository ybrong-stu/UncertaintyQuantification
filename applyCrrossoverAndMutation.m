function Q = applyCrrossoverAndMutation(P,pc,pm,numbits)

popsize = size(P,1);
nVar = size(P,2);
Q = zeros(popsize,nVar);
for j = 1:2:popsize
     [np1,np2] = crossPop(P(j,:),P(j+1,:),pc);
      np1 = mutatePop(np1, pm,numbits);
      np2 = mutatePop(np2, pm,numbits);
      Q(j,:) = np1;
      Q(j+1,:) = np2;
end


function [np1,np2] = crossPop(p1,p2,crossp)

if isequal(p1,p2)
    np1 = p1;
    np2 = p2;
else
     if rand <= crossp
        xp = find(p1~=p2);
        if xp(end) == numel(p1)
            xp(end) = [];
        end
        n = numel(xp);
        if n ~= 0
           s = randi([1,n]);
           np1 = [p1(1,1:xp(s)),p2(1,xp(s)+1:end)];
           np2 = [p2(1,1:xp(s)),p1(1,xp(s)+1:end)];    
        else
           np1 = p1;
           np2 = p2;
        end 
     else
         np1 = p1;
         np2 = p2;
     end
end

function np = mutatePop(p, mutatep,numbits)  % for initialization with randomly way


%% initialization with randomly way
n = numel(p);
for i = 1:numbits
    if rand <= mutatep
        s = randi([1,n]);
        if p(s) == 0
            p(s) = 1;
        elseif p(s) == 1
            p(s) = 0;
        end
    end
end
np = p;
