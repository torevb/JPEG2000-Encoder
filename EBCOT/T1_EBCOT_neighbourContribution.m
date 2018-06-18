function [sumH, sumV, sumD] = T1_EBCOT_neighbourContribution(slidingWindow)
%NEIGHBOURCONTRIBUTION Sums for Horizontal, Vertical and Diagonal
%neighbours. 

%%% Neighbour state contributions. 
%   ---------------- 
%   | D0 | V0 | D1 |          
%   ----------------          The Sliding Window is a 3x3 square 
%   | H0 | X  | H1 |          centered on the current coefficient bit X
%   ----------------          [Figure D.2 in ISO/IEC 15444-13:2008]. 
%   | D2 | V1 | D3 |          
%   ----------------
    
    sumH = slidingWindow(2,1) + slidingWindow(2,3);
    sumV = slidingWindow(1,2) + slidingWindow(3,2);
    sumD = slidingWindow(1,1) + slidingWindow(1,3) + slidingWindow(3,1) + slidingWindow(3,3);
end

