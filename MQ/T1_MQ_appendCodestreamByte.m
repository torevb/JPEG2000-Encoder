function MQoutput = T1_MQ_appendCodestreamByte(MQoutput, newByte)
%%% T1_EBCOT_APPENDMQPACKET Appends data to end of list. 
    %
    
    %%% Ensure only 8 bits. 
    newByte = bitand(newByte, hex2dec('FF'));
    newByte = uint8(newByte);
    
    %%% Append byte. 
    MQoutput((size(MQoutput, 1) + 1), :) = newByte;
end
