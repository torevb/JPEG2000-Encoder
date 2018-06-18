function EBCOToutput = T1_EBCOT_appendData(EBCOToutput, newData)
%%% Appends data to the end of list. 
    %
    
    EBCOToutput((size(EBCOToutput, 1) + 1), :) = newData;
end
