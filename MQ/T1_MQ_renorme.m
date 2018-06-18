function [MQoutput, A, BP, C, CT] = T1_MQ_renorme(MQoutput, A, BP, C, CT)
%RENORME Summary of this function goes here
%   Detailed explanation goes here
    %
    
    A = bitsll(A, 1);
    C = bitsll(C, 1);
    CT = CT - 1;

    if CT == 0
        [MQoutput, BP, C, CT] = T1_MQ_byteOut(MQoutput, BP,C);
    end
    
    while (bitand(A, hex2dec('8000')) == 0)     % Repeat the above. 
        A = bitsll(A, 1);
        C = bitsll(C, 1);
        CT = CT - 1;

        if CT == 0
            [MQoutput, BP, C, CT] = T1_MQ_byteOut(MQoutput, BP,C);
        end
    end
end

