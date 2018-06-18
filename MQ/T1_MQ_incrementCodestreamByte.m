function MQoutput = T1_MQ_incrementCodestreamByte(MQoutput, byteAddress)
%T1_EBCOT_APPENDMQPACKET Summary of this function goes here
%   Detailed explanation goes here
    %
    
    oldDataByte = MQoutput(byteAddress);
    newDataByte = oldDataByte + 1;
    
    %%% Ensure only 8 bits. 
    if newDataByte > 255
        disp('Warning [T1_MQ_incrementCodestreamByte]: Byte overflow.');
    end
    
    newDataByte = bitand(newDataByte, hex2dec('FF'));
    newDataByte = uint8(newDataByte);
    
    %%% Replace byte. 
    MQoutput(byteAddress) = newDataByte;
end
