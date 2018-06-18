function contextLabel = T1_EBCOT_significanceContext(subband, slidingWindow)
%%% SIGNIFICANCEPROPAGATIONCONTEXTLABEL Determines a context label for the
%   current coefficient bit, based on the neighbour contribution. Table D.1
%   in ISO/IEC 15444-1:2016 is used. 
    %
    
    [sumH, sumV, sumD] = T1_EBCOT_neighbourContribution(slidingWindow);
    
    if (strcmp(subband,'LH') || strcmp(subband,'LL'))
        if sumH == 2                 
            contextLabel = 8;
        elseif sumH == 1    
            if sumV >= 1             
                contextLabel = 7;
            elseif sumD >= 1        
                contextLabel = 6;
            else % H V D = 1 0 0. 
                contextLabel = 5; 
            end
        else % H V D = 0 ? ?. 
            if sumV == 2
                contextLabel = 4;
            elseif sumV == 1
                contextLabel = 3;
            else % H V D = 0 0 ?. 
                if sumD >= 2
                    contextLabel = 2;
                else % H V D = 0 0 1or0. 
                    contextLabel = sumD;    % 1 or 0. 
                end
            end
        end
    elseif strcmp(subband,'HL')
        if sumV == 2
            contextLabel = 8;
        elseif sumV == 1
            if sumH >= 1
                contextLabel = 7;
            elseif sumD >= 1
                contextLabel = 6;
            else % H V D = 0 1 0. 
                contextLabel = 5; 
            end
        else % H V D = ? 0 ?. 
            if sumH == 2
                contextLabel = 4;
            elseif sumH == 1
                contextLabel = 3;
            else % H V D = 0 0 ?. 
                if sumD >= 2
                    contextLabel = 2;
                else % H V D = 0 0 1or0. 
                    contextLabel = sumD;     % 1 or 0. 
                end
            end
        end
    elseif strcmp(subband,'HH')
        sumHV = sumH + sumV;
        if sumD >= 3
            contextLabel = 8;
        elseif sumD == 2
            if sumHV >= 1
                contextLabel = 7;
            else % HV D = 0 2. 
                contextLabel = 6;
            end
        elseif sumD == 1
            if sumHV >= 2
                contextLabel = 5;
            else % HV D = 1or0 1. 
                contextLabel = sumHV + 3;     % 4 or 3. 
            end
        else % HV D = ? 0. 
            if sumHV >= 2
                contextLabel = 2;
            else % HV D = 1or0 0. 
                contextLabel = sumHV;     % 1 or 0. 
            end
        end
    else
        disp('Error [T1_EBCOT_contextLabelForSignificance]: Invalid sub-band type.');
    end
end
