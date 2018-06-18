function [EBCOToutput, significantStatesPadded, remainingCoefficients] ...
    = T1_EBCOT_significanceCoding(EBCOToutput, bitplane, significantStatesPadded, subband, codeblockSignsPadded, remainingCoefficients, row, col)
%%% SIGNIFICANCEPROPAGATIONCODING 
    %
    
    %%% 'Predict' whether significance propagation pass should run or not. 
    %   Run if any neighbour has significance state == 1. This is equivalent to contextLabel ~= 0. 
    slidingWindow = significantStatesPadded((row):(row+2), (col):(col+2));
    contextLabel = T1_EBCOT_significanceContext(subband, slidingWindow);

    % alternativePrediction = any(any(slidingWindow)); % If any neighbours have significance state 1. Be careful if the slidingWindow contains 1 at the current coefficient bit position (X in center), which is verified as not the case here just before this function call. 

    if contextLabel ~= 0    % 'Prediction' by finding any neighbours with Significance State 1. 
        coefficientBit = bitplane(row,col);
        decision = coefficientBit;
        EBCOToutput = T1_EBCOT_appendData(EBCOToutput, [contextLabel, decision, 1, row, col]);

        if coefficientBit == 1
            significantStatesPadded(row+1,col+1) = 1;

            % Immediate next encoding is sign bit. 
            EBCOToutput = T1_EBCOT_signCoding(EBCOToutput, slidingWindow, codeblockSignsPadded, row, col);
        end
    else
        remainingCoefficients(row,col) = 1; % Will be encoded by the cleanup pass instead. 
    end
end
