function f=remove_nan(v)
    v_nan_removed = [];
    for j = 1:length(v)
        if isnan(v(j)) == 0
            v_nan_removed = [v_nan_removed, v(j)];
        end
    end
f = v_nan_removed;
end