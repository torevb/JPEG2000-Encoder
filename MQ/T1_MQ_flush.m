function [MQoutput, BP, C, CT] = T1_MQ_flush(MQoutput, A, BP, C, CT)
%FLUSH Summary of this function goes here
%   Detailed explanation goes here
    %
    
    C = T1_MQ_setBits(A, C);
    
    C = bitsll(C, CT);
    [MQoutput, BP, C, CT] = T1_MQ_byteOut(MQoutput, BP, C);
    
    C = bitsll(C, CT);
    [MQoutput, BP, C, CT] = T1_MQ_byteOut(MQoutput, BP, C);
    
    if MQoutput(BP) == hex2dec('FF')
        % Discard B.
        % F.eks. C = bitand(C, hex2dec('7FFFF')); ??
        
        % OpenJPEG code: 
            % /* It is forbidden that a coding pass ends with 0xff */
            % if (*bp != 0xff) {
                % /* Advance pointer so that opj_mqc_numbytes() returns a valid value */
                % bp++;
            % }
    else
        % Output B to bitstream. 
        BP = BP + 1; 
    end
end

