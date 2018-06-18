function [EBCOToutput, needFirstMR] ...
    = T1_EBCOT_magnitudePass(EBCOToutput, bitplane, significantStatesPadded, needMR, needFirstMR)
%%% MAGNITUDEREFINEMENTPASS 
    %
    
    bitplaneHeight = size(bitplane,1);
    bitplaneWidth = size(bitplane,2);
    
    
    
    %%% ================= Scan Pattern =================
    
    for baseRow = 1:4:(4*floor(bitplaneHeight/4))
        for col = 1:bitplaneWidth
            for row = (baseRow+0):(baseRow+3)
                if needMR(row,col) == 1
                    [EBCOToutput, needFirstMR] = T1_EBCOT_magnitudeCoding(EBCOToutput, bitplane, significantStatesPadded, needFirstMR, row, col);
                end
            end
        end
    end
    if (row < bitplaneHeight)   % Potentially remaining. Occurs when height divided by four is not an integer. 
        finalRow = row + 1;
        for col = 1:bitplaneWidth
            for row = finalRow:bitplaneHeight
                if needMR(row,col) == 1
                    [EBCOToutput, needFirstMR] = T1_EBCOT_magnitudeCoding(EBCOToutput, bitplane, significantStatesPadded, needFirstMR, row, col);
                end
            end
        end
    end
end
