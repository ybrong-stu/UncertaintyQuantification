function d = dominates(x,y)
    d = (all(x<=y,2) & any(x<y,2));
end