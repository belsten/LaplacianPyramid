function g_l_minus_1 = EXPAND(g_l,w)
    r_l = size(g_l,1);
    c_l = size(g_l,2);
    M = r_l - 1;
    N = c_l - 1;
    g_l_minus_1 = zeros(2*M+1, 2*N+1);
    for i=1:size(g_l_minus_1,1)
        for j=1:size(g_l_minus_1,2)
            for m=-2:2
                for n=-2:2
                    % check if we're within image bounds (input image)
                    if or(round((i-m)/2) > size(g_l, 1), round((i-m)/2) < 1)
                        continue;
                    elseif  or(round((j-n)/2) > size(g_l, 1), round((j-n)/2) < 1)
                        continue
                    else
                        g_l_minus_1(i,j) = g_l_minus_1(i,j) + w(m+3,n+3)*double(g_l(round((i-m)/2), round((j-n)/2)));
                    end
                end
            end
        end
    end
end