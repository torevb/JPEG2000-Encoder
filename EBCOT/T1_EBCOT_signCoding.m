function EBCOToutput = T1_EBCOT_signCoding(EBCOToutput, slidingWindow, codeblockSignsPadded, row, col)
%SIGNCODING Summary of this function goes here
%   Detailed explanation goes here
    %
    
    % Significance State (0/1). 
    H0(1) = slidingWindow(2,1);
    H1(1) = slidingWindow(2,3);
    V0(1) = slidingWindow(1,2);
    V1(1) = slidingWindow(3,2);
    
    % Signs (+1/-1). Same positions as sliding window. 
    H0(2) = codeblockSignsPadded(row+1, col);
    H1(2) = codeblockSignsPadded(row+1, col+2);
    V0(2) = codeblockSignsPadded(row, col+1);
    V1(2) = codeblockSignsPadded(row+2, col+1);
    
	
	
    %%% ================= Determine Contribution =================
        
    if H0(1) == H1(1)
        if H0(2) == H1(2)
            contributionH = H0(1) * H0(2);
        else
            contributionH = 0;
        end
    else
        if H0(1) == 1
            contributionH = H0(2);
        else
            contributionH = H1(2);
        end
    end
    
    if V0(1) == V1(1)
        if V0(2) == V1(2)
            contributionV = V0(1) * V0(2);
        else
            contributionV = 0;
        end
    else
        if V0(1) == 1
            contributionV = V0(2);
        else
            contributionV = V1(2);
        end
    end
    
    % Alternative solutions: Produces correct results, but must be rounded towards 0 if values are +2 or -2. +2=+1 and -2=-1. 
    % Will not work properly if signs are other than +1/-1 (sign is 0 in signed magnitude representation). Because the significant state == 0 should not result in a positive contribution, but none. 
%     alternative_contributionH = min(+1,max(-1, H0(1) * H0(2) + H1(1) * H1(2))); 
%     alternative_contributionV = min(+1,max(-1, V0(1) * V0(2) + V1(1) * V1(2)));
    
    %%% ================= Determine Context =================
    
    if contributionH == 1
        if contributionV == 1
            contextLabel = 13;
            xorBit = 0;
        elseif contributionV == 0
            contextLabel = 12;
            xorBit = 0;
        elseif contributionV == -1
            contextLabel = 11;
            xorBit = 0;
        end
    elseif contributionH == 0
        if contributionV == 1
            contextLabel = 10;
            xorBit = 0;
        elseif contributionV == 0
            contextLabel = 9;
            xorBit = 0;
        elseif contributionV == -1
            contextLabel = 10;
            xorBit = 1;
        end
    elseif contributionH == -1
        if contributionV == 1
            contextLabel = 11;
            xorBit = 1;
        elseif contributionV == 0
            contextLabel = 12;
            xorBit = 1;
        elseif contributionV == -1
            contextLabel = 13;
            xorBit = 1;
        end
    end
    
    
    
    %%% ================= Determine Decision =================
    
    %%% Sign magnitude representation: 1 is negative, 0 is positive. 
    coefficientSign = codeblockSignsPadded(row+1, col+1); % Returns +1 or -1. 
%     signbit = bitget(coefficientSign, bitsPerPixel, 'int8'); % Should use the sign bit (MSB bit) in VHDL. (Assumed 8 bits here.)
    signbit = (coefficientSign < 0) + 0;
    
    decision = bitxor(signbit, xorBit);
    
    
    
    %%% ================= Output =================
    
    EBCOToutput = T1_EBCOT_appendData(EBCOToutput, [contextLabel, decision, 4, row, col]);
end

