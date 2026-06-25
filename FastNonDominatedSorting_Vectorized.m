function [RANK] = FastNonDominatedSorting_Vectorized(fitness)
    % Initialization
    Np = size(fitness,1);
    RANK = zeros(Np,1);
    current_vector = [1:1:Np]';
    current_pf = 1;
    all_perm = [repmat([1:1:Np]',Np',1), reshape(repmat([1:1:Np],Np,1),Np^2,1)];
    all_perm(all_perm(:,1)==all_perm(:,2),:) = [];
    
    % Computing each Pareto Front
    while ~isempty(current_vector)
        
        % Check if there is only a single particle
        if length(current_vector) == 1
            RANK(current_vector) = current_pf;
            break;
        end
        
        % Non-dominated particles
             
        d = dominates(fitness(all_perm(:,1),:),fitness(all_perm(:,2),:));
        dominated_particles = unique(all_perm(d==1,2));

        % Check if there is no room for more Pareto Fronts
        if sum(~ismember(current_vector,dominated_particles)) == 0
            break;
        end

        % Update ranks and current_vector
        non_dom_idx = ~ismember(current_vector,dominated_particles);
        RANK(current_vector(non_dom_idx)) = current_pf;
        all_perm(ismember(all_perm(:,1),current_vector(non_dom_idx)),:) = [];
        all_perm(ismember(all_perm(:,2),current_vector(non_dom_idx)),:) = [];
        current_vector(non_dom_idx) = [];
        current_pf = current_pf + 1;
    end
end