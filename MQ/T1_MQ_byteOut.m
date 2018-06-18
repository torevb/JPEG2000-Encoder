function [MQoutput, BP, C, CT] = T1_MQ_byteOut(MQoutput, BP, C)
%BYTEOUT Summary of this function goes here
%   Detailed explanation goes here
    %

    if (MQoutput(BP) == hex2dec('FF'))
        BP = BP + 1;
        MQoutput(BP) = bitsrl(C, 20);
        C = bitand(C, hex2dec('FFFFF'));
        CT = 7;
        return;
    end
    
    if (C < hex2dec('8000000'))
        BP = BP + 1;
        MQoutput(BP) = bitsrl(C, 19);
        C = bitand(C, hex2dec('7FFFF'));
        CT = 8;
        return;
    end
    
    MQoutput(BP) = MQoutput(BP) + 1;      % Previous value changes. Use BP to point to the byte. 
    
    if (MQoutput(BP) == hex2dec('FF'))
        C = bitand(C, hex2dec('7FFFFFF'));
        BP = BP + 1;
        MQoutput(BP) = bitsrl(C, 20);
        C = bitand(C, hex2dec('FFFFF'));
        CT = 7;
        return;
    end
    
    BP = BP + 1;
    C = bitand(C, hex2dec('7FFFFFF')); % Enforce bits. Matlab otherwise rounds a higher value to max. E.g. uint8('0x1000') becomes '0xFF'. 
    MQoutput(BP) = bitsrl(C, 19);
    C = bitand(C, hex2dec('7FFFF'));
    CT = 8;
end

