function [EBCOToutput, significantStatesPadded, remainingCoefficients] ...
    = T1_EBCOT_significancePass(EBCOToutput, bitplane, significantStatesPadded, subband, codeblockSignsPadded)
%%% SIGNIFICANCEPROPAGATIONPASS Encodes coefficient bits in a bitplane if 
%   they are predicted to update their significance state. The prediction
%   simply checks if any neighbouring significance state is 1. The context
%   labels and decisions are appended to EBCOToutput. 
    %
    
    bitplaneHeight = size(bitplane,1);
    bitplaneWidth = size(bitplane,2);
    
    remainingCoefficients(1:bitplaneHeight, 1:bitplaneWidth) = 0;
    
    
    
    %%% ================= Scan Pattern =================
    
    for i = 0:(floor(bitplaneHeight/4)-1)
        for col = 1:bitplaneWidth
            for row = (4*i+1):(4*i+4)
                if significantStatesPadded(row+1, col+1) == 0
                    %%% Handled by either significance propagation pass or cleanup pass. 
                    [EBCOToutput, significantStatesPadded, remainingCoefficients] ...
                        = T1_EBCOT_significanceCoding(EBCOToutput, bitplane, significantStatesPadded, subband, codeblockSignsPadded, remainingCoefficients, row, col);
                end
            end
        end
    end
    
    if (row < bitplaneHeight)   % Potentially remaining. Occurs when height divided by four is not an integer. 
        finalRow = row + 1;
        for col = 1:bitplaneWidth
            for row = finalRow:bitplaneHeight
                if significantStatesPadded(row+1, col+1) == 0
                    %%% Handled by either significance propagation pass or cleanup pass. 
                    [EBCOToutput, significantStatesPadded, remainingCoefficients] ...
                        = T1_EBCOT_significanceCoding(EBCOToutput, bitplane, significantStatesPadded, subband, codeblockSignsPadded, remainingCoefficients, row, col);
                end
            end
        end
    end
end
