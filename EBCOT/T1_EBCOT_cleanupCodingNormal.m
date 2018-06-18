function [EBCOToutput, significantStatesPadded] = T1_EBCOT_cleanupCodingNormal(EBCOToutput, bitplane, significantStatesPadded, subband, codeblockSignsPadded, row, col)
%%% Normal coding for Coding Pass. 
    %
    
    coefficientBit = bitplane(row,col);    % 0 or 1. 
    slidingWindow = significantStatesPadded((row):(row+2), (col):(col+2));  % 3x3 array. 
    
    contextLabel = T1_EBCOT_significanceContext(subband, slidingWindow);
    decision = coefficientBit;
    EBCOToutput = T1_EBCOT_appendData(EBCOToutput, [contextLabel, decision, 3, row, col]);
    
    if coefficientBit == 1
        significantStatesPadded(row+1,col+1) = 1;
        
        % Immediate next encoding is sign bit. 
        EBCOToutput = T1_EBCOT_signCoding(EBCOToutput, slidingWindow, codeblockSignsPadded, row, col);
    end
end
