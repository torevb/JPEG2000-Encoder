function [MQoutput, indexCX, mpsCX, A, BP, C, CT] = T1_MQ_decideEncode(MQoutput, indexCX, mpsCX, descision, A, BP, C, CT)
%DECIDEENCODE Summary of this function goes here
%   Detailed explanation goes here
    %
    
    if descision == mpsCX      % Both values are 1 bit length.
        [MQoutput, indexCX, A, BP, C, CT] = T1_MQ_codeMPS(MQoutput, indexCX, A, BP, C, CT);
    else
        [MQoutput, indexCX, A, BP, C, CT, mpsCX] = T1_MQ_codeLPS(MQoutput, indexCX, A, BP, C, CT, mpsCX);
    end
end
