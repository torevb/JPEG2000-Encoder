function [EBCOToutput, significantStatesPadded] = T1_EBCOT_cleanupCodingRunLength(EBCOToutput, bitplane, significantStatesPadded, subband, codeblockSignsPadded, baseRow, col)
%%% Run-length coding for Cleanup Pass. 
    %
    
    for columnIndex = 0:3
		row = baseRow + columnIndex;
        coefficientBit = bitplane(row, col);
        if (coefficientBit == 1)
            break;
        end
    end
	
    
    if (coefficientBit == 0)
        contextLabel = 17;
        decision = 0;
        EBCOToutput = T1_EBCOT_appendData(EBCOToutput, [contextLabel, decision, 5, columnIndex+1, col]);
    else    % (coefficientBit == 1)
        contextLabel = 17;
        decision = 1;
        EBCOToutput = T1_EBCOT_appendData(EBCOToutput, [contextLabel, decision, 5, columnIndex+1, col]);
        
        
        contextLabel = 18;
        decisionBase = columnIndex - 1;    % {0, 1, 2, 3}
        
        decision = bitget(decisionBase, 2, 'int8');
        EBCOToutput = T1_EBCOT_appendData(EBCOToutput, [contextLabel, decision, 6, columnIndex+1, col]);
        
        decision = bitget(decisionBase, 1, 'int8');
        EBCOToutput = T1_EBCOT_appendData(EBCOToutput, [contextLabel, decision, 6, columnIndex+1, col]);
        
        slidingWindow = significantStatesPadded((row):(row+2), (col):(col+2));  % 3x3 array. 
        EBCOToutput = T1_EBCOT_signCoding(EBCOToutput, slidingWindow, codeblockSignsPadded, columnIndex+1, col);
        
        
        significantStatesPadded(row+1, col+1) = 1; 
        
        
        for i = (row+1):(baseRow+3)     % Normal Mode if any remain. 
            [EBCOToutput, significantStatesPadded] = T1_EBCOT_cleanupCodingNormal(EBCOToutput, ...
                bitplane, significantStatesPadded, subband, codeblockSignsPadded, i, col);
        end
    end
end

