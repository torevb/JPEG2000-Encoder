function [MQoutput, indexCX, A, BP, C, CT, mpsCX] = T1_MQ_codeLPS(MQoutput, indexCX, A, BP, C, CT, mpsCX)
%CODELPS Summary of this function goes here
%   Detailed explanation goes here
    %
    
    [Qe, NMPS, NLPS, switchValue] = T1_MQ_probabilityEstimation(indexCX);
    
    A = A - Qe;
    
    if A < Qe
        C = C + Qe;
    else
        A = Qe;
    end
    
    if switchValue == 1
        mpsCX = 1 - mpsCX;
    end
    
    indexCX = NLPS;
    [MQoutput, A, BP, C, CT] = T1_MQ_renorme(MQoutput, A, BP, C, CT);
end
