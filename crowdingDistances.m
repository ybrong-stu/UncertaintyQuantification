function [sortCrowd,sortRank,sortFit,sortPop] = crowdingDistances(rank,fitness,pop)

    % Initialize
    sortPop = [];
    sortFit = [];
    sortRank = [];
    sortCrowd = [];
    
    Npf = length(unique(rank));
    for pf = 1:1:Npf
        index = find(rank==pf);
        temp_fit = fitness(index,:);
        temp_rank = rank(index,:);
        temp_pop = pop(index,:);
        
        % Sort by first dimension
        [temp_fit,sort_idx] = sortrows(temp_fit,1);
        temp_rank = temp_rank(sort_idx);
        sortFit = [sortFit; temp_fit];
        sortRank = [sortRank; temp_rank];
        sortPop = [sortPop; temp_pop(sort_idx,:)];
        
        % Crowded distances
        temp_crowd = zeros(size(temp_rank));
        for m = 1:1:size(fitness,2)
            temp_max = max(temp_fit(:,m));
            temp_min = min(temp_fit(:,m));
            for l = 2:1:length(temp_crowd)-1
                temp_crowd(l) = temp_crowd(l) + (abs(temp_fit(l-1,m)-temp_fit(l+1,m)))./(temp_max-temp_min);
            end
        end
        temp_crowd(1) = Inf;
        temp_crowd(length(temp_crowd)) = Inf;
        sortCrowd = [sortCrowd; temp_crowd];
    end
end