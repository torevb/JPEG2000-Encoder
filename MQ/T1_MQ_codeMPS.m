function [MQoutput, indexCX, A, BP, C, CT] = T1_MQ_codeMPS(MQoutput, indexCX, A, BP, C, CT)
%CODELPS Summary of this function goes here
%   Detailed explanation goes here
    %
    
    [Qe, NMPS, NLPS, switchValue] = T1_MQ_probabilityEstimation(indexCX);
    
    A = A - Qe;
    
    if (bitand(A, hex2dec('8000')) == 0)  % not(bitget(A,16))
        if A < Qe
            A = Qe;
        else
            C = C + Qe;
        end
        
        indexCX = NMPS;
        [MQoutput, A, BP, C, CT] = T1_MQ_renorme(MQoutput, A, BP, C, CT);
    else
        C = C + Qe;
    end
end

