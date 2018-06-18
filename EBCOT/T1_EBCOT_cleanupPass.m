function [EBCOToutput, significantStatesPadded] = T1_EBCOT_cleanupPass(EBCOToutput, bitplane, significantStatesPadded, subband, codeblockSignsPadded, needCleanup)
%%% Executes cleanup pass for one bitplane.  
    %

    bitplaneHeight = size(bitplane,1);
    bitplaneWidth = size(bitplane,2);
    
    
    
    %%% ================= Scan Pattern =================
    
    for i = 0:(floor(bitplaneHeight/4)-1)
        for col = 1:bitplaneWidth
            baseRow = (4*i)+1;
            normalMode = false;
            
            %%% Determine whether Run-length or Normal Mode for this column. 
            %   The condition for Run-length is to have 'four contiguous
            %   coefficients in a column remaining to be encoded and each
            %   currently has the 0 context' [ISO/IEC 15444-13:2008, Table D.5].
            %   Use Normal Mode otherwise. 
            for row = baseRow:(baseRow+3)
                if (needCleanup(row,col) ~= 1)
                    normalMode = true;
                    break;
                end
                
                slidingWindow = significantStatesPadded((row):(row+2), (col):(col+2));
                contextLabel = T1_EBCOT_significanceContext(subband, slidingWindow);
                
                if (contextLabel ~= 0)
                    normalMode = true;
                    break
                end
            end
            
            
            %%% Use determined result. 
            if (normalMode == false)
                % Run-length Coding. 
                [EBCOToutput, significantStatesPadded] = T1_EBCOT_cleanupCodingRunLength(EBCOToutput, ...
                    bitplane, significantStatesPadded, subband, codeblockSignsPadded, baseRow, col);
            else
                % Normal Cleanup Coding. 
                for row = baseRow:(baseRow+3)
                    if (needCleanup(row,col) == 1)
                        [EBCOToutput, significantStatesPadded] = T1_EBCOT_cleanupCodingNormal(EBCOToutput, ...
                            bitplane, significantStatesPadded, subband, codeblockSignsPadded, row, col);
                    end
                end
            end
        end
    end
    
    if (row < bitplaneHeight)   % Potentially remaining. Occurs when height divided by four is not an integer. 
        finalRow = row + 1;
        for col = 1:bitplaneWidth
            for row = finalRow:bitplaneHeight
				if (needCleanup(row,col) == 1)
					%%% Normal Cleanup Coding. 
					%   Because there are not four continuous elements in a
					%   column here, required for run-length. This code is only 
					%   executed when (remaining height < 4). 
					[EBCOToutput, significantStatesPadded] = T1_EBCOT_cleanupCodingNormal(EBCOToutput, ...
						bitplane, significantStatesPadded, subband, codeblockSignsPadded, row, col);
				end
            end
        end
    end
end
