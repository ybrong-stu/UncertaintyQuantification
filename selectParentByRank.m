function [P1,P1rank,Pfit]   = selectParentByRank(P, Prank,Pfit)
    % Take the couples
    N = length(Prank);    
    left_idx  = randi(N,N,1);
    right_idx = randi(N,N,1);
    while sum(left_idx==right_idx)>0
        right_idx(left_idx==right_idx) = randi(N,sum(left_idx==right_idx),1);
    end
    
    % Make the tournament
    winners = zeros(N,1);
    winners(Prank(left_idx)<=Prank(right_idx)) = left_idx(Prank(left_idx)<=Prank(right_idx));
    winners(Prank(right_idx)<Prank(left_idx)) = right_idx(Prank(right_idx)<Prank(left_idx));
    
    % Select both populations
    P1 = P(winners,:);
    P1rank = Prank(winners,:);
    Pfit = Pfit(winners,:);
end
