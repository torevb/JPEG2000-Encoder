function [contextLabel] = T1_EBCOT_magnitudeContext(firstMR, slidingWindow)
%CONTEXTLABELFORMAGNITUDE Performs coefficient bit modelling during
% coding pass. 

%   Returns the context label in accordance with Table D.4 in ISO/IEC
%   15444-1:2016. The sum inputs are from the sliding window (3x3 square
%   centered on the current coefficient bit X (scan target)), respectively
%   from Horizontal, Vertical and Diagonal neighbours of X. The table
%   weights the first MR encoding for a coefficient differently. 
    %
    
    if firstMR == 1
        [sumH, sumV, sumD] = T1_EBCOT_neighbourContribution(slidingWindow);
        sumNeighbours = sumH + sumV + sumD;
        
        if sumNeighbours >= 1
            contextLabel = 15;
        else
            contextLabel = 14;
        end
    else
        contextLabel = 16;
    end
end

