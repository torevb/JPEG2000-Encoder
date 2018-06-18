function [EBCOToutput, needFirstMR] = T1_EBCOT_magnitudeCoding(EBCOToutput, bitplane, significantStatesPadded, needFirstMR, row, col)
%T1_EBCOT_MAGNITUDECODING Summary of this function goes here
%   Detailed explanation goes here
    %
    
    coefficientBit = bitplane(row,col);    % 0 or 1. 
    slidingWindow = significantStatesPadded((row):(row+2), (col):(col+2));  % 3x3 array. 
    firstMR = needFirstMR(row,col);     % 0 or 1. 
    
    contextLabel = T1_EBCOT_magnitudeContext(firstMR, slidingWindow); 
    decision = coefficientBit;
    EBCOToutput = T1_EBCOT_appendData(EBCOToutput, [contextLabel, decision, 2, row, col]);
    
    needFirstMR(row,col) = 0;
end

