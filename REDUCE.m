function g_k = REDUCE(g_k_minus_1, w)
    r = size(g_k_minus_1, 1);
    c = size(g_k_minus_1, 2);

    g_k = zeros(round(r/2), round(c/2));
    for i=1:size(g_k,1)
        for j=1:size(g_k,2)
            for m=-2:2
                for n=-2:2
                    % check if we're within image bounds (input image)
                    if or((2*i + m) > size(g_k_minus_1, 1), (2*i + m) < 1)
                        continue;
                    elseif  or((2*j + n) > size(g_k_minus_1, 2), (2*j + n) < 1)
                        continue
                    else
                        g_k(i,j) = g_k(i,j) + w(m+3,n+3)*double(g_k_minus_1(2*i + m, 2*j + n));
                    end
                end
            end
        end
    end
end