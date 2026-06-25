function [newParent] = selectParentByRankAndDistance(Rcrowd,Rrank,R)
    
    % Initialization
    N = length(Rcrowd)/2;
    Npf = length(unique(Rrank));
    newParent = zeros(N,size(R,2));
    
    % Selecting the chromosomes
    pf = 1;
    numberOfSolutions = 0;
    while pf <= Npf
        % If there is enough space, select solutions based on rank
        if numberOfSolutions + sum(Rrank == pf) <= N
            newParent(numberOfSolutions+1:numberOfSolutions+sum(Rrank == pf),:) = R(Rrank == pf,:);
            numberOfSolutions = numberOfSolutions + sum(Rrank == pf);
        % If there isn't enugh space, sort by crowding distances
        else
            rest = N - numberOfSolutions;
            lastPF = R(Rrank == pf,:);
            lastPFdist = Rcrowd(Rrank == pf);
            [~,idx] = sort(lastPFdist,'descend');
            lastPF = lastPF(idx,:);
            newParent(numberOfSolutions+1:numberOfSolutions+rest,:) = lastPF(1:rest,:);
            numberOfSolutions = numberOfSolutions + rest;
        end
        pf = pf + 1;
    end
end
