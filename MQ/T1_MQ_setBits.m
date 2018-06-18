function C = T1_MQ_setBits(A, C)
%SETBITS Summary of this function goes here
%   Detailed explanation goes here
    %
    
    tempC = C + A;
    C = bitor(C, hex2dec('FFFF'));
    
    if C >= tempC
        C = C - hex2dec('8000');
    end
end

