function [MQoutput] = T1_MQ(EBCOToutput)
%%% T1_MQ Performs binary arithmethic coding based on context labels and
%   decisions from the EBCOT. It returns a list of bytes intended for the
%   Tier 2 Encoder (File packetization). 
    %

    MQoutput = 0;
    %%% MQoutput list elements: 
    %   {byte}. 
    %   'byte' is 8 bits containing the encoded image data, as per contexts 
    %   and decisions. 
    %%%


    
    

    %%% ================= Initializing Contexts =================

    % Lists in Matlab are 1-indexed, meaning we must add 1 offset to contextLabel. 
    % Otherwise trouble if accessesing indexLookup(CX) when CX == 0. 
    offset = 1; 
    contextZero      = 0;  % All zero neighbours (context label 0).
    contextRunLength = 17;
    contextUniform   = 18;
    numberOfContexts = 19; 


    % "When the contexts are initialized, or re-initialized, they are set to
    % the values in Table D.7 [ISO/IEC 15444-13:2008]. 
    indexLookup(1:numberOfContexts) = 0;
    mpsLookup(1:numberOfContexts) = 0;

    indexLookup(offset + contextUniform) = 46;
    indexLookup(offset + contextRunLength) = 3;
    indexLookup(offset + contextZero) = 4;


    
    

    %%% ================= MQ Encoder =================

    %%% Explanations for variables:
        % BPST: 'Byte Pointer Start'. Points to the base address where the 
            % output will be written to. This is intended for memory 
            % management. 'CT' should be +1 if the byte preceding the MQ output
            % is 0xFF. In this function it is not used well, as the data is not
            % written to a proper memory storage, but instead is returned as a
            % function output. The initialization case where (B == 0xFF) should 
            % be handled later, where the function is called from? 
        % BP: 'Byte Pointer'. Points to the address previously written to.
            % Increments before next byte is written. 
        % B: The byte previously written to, as pointed to by 'BP'. In most 
            % circumstances the byte is finished, but it may be changed +1 in 
            % 'T1_MQ_byteOut()' function. 'MQoutput(BP)' is equivalent to
            % 'B'. 
        % MQoutput(BP): Is equivalent to 'B'. 
        % MQoutput: A list of finished bytes of compressed image data from
            % the MQ Coder. The list begins at position 'BPST'. For this
            % MatLab function, this means element 1 is to be disregarded (BPST
            % = 2). 
        % limitedMQoutput: Same as 'MQoutput', but with enforced 8-bits
            % values. 'MQoutput' appears to overflow occasionally (value 
            % 0xFF + 1). 
        % A: Interval used to determine the codestream output. Is always in the
            % region 0x8000 <= A <= 0x1 0000. Whenever it falls below minimum, 
            % it is left-shifted (multiplied by 2) until within region. Is
            % stored in a 32-bits register.
        % C: Holds the value for the code register in a 32-bits register. This
            % is where data accumulates until it fills a byte. Bit 28 marks the 
            % carry bit. Bits 27 to 20 marks the byte to be output on the
            % codestream. Bits 19 to 17 marks the spacer bits which aid in
            % constraining carry-over. Bits 16 to 1 hold the temporary data
            % from the addition operations, which will not be ready until they
            % are bitshifted to the byte output location. 
        % CT: Counts the bitshifts in A and C registers. (CT == 0) indicates a
            % byte is ready for output, thus starting a 'byteOut()' function 
            % call. 
        %   MPS: Most Probable Symbol. 
        %   LPS: Least Probable Symbol.
    %%%

    %%% Connections between variables, when determining values (not control signals):
        % context: 
                % --> Qe. 
        % Qe: 
            % --> A.	% E.g. A = A - Qe;
            % --> C.
        % A: 
            % --> A.
        % B: 
            % --> B.
        % BP: 
            % --> BP.
        % BPST: 
            % --> BP.
        % C: 
            % --> C.
            % --> B.
        % CT: 
            % --> CT. 
            % --> A.
            % --> C.
    %%%



    
    
    %%% ================= 'INITENC' =================

    %%% BPST is here not used properly. It should point to a byte position in memory. 
    %   BPST is supposed to be used to validate that the byte before the MQ output is not 0xFF. 
    %   But is it also pointing to the previous codeblock output? Flush may not end in 0xFF?
    BPST = 2;   	    % Initialized to 2 to allow 1-indexed arrays in MatLab. 
    MQoutput(1) = 0;    % Not used properly. 
    %%%


    A = uint32(hex2dec('8000'));
    C = uint32(0);
    BP = BPST - 1;  % BP always increments over time after this. 
    CT = 12;

    if MQoutput(BP) == hex2dec('FF') % Never occurs (see BPST not used properly).
        CT = 13;
    end



    
    
    for i = 1:size(EBCOToutput,1)
        %%% ============= Read context label and decision =============

        contextLabel = EBCOToutput(i,1);
        decision = EBCOToutput(i,2); 

        indexCX = indexLookup(contextLabel + offset);
        mpsCX = mpsLookup(contextLabel + offset);


        
        

        %%% ================= 'ENCODE' =================

        [MQoutput, indexCX, mpsCX, A, BP, C, CT] = T1_MQ_decideEncode(MQoutput, indexCX, mpsCX, decision, A, BP, C, CT);

        indexLookup(contextLabel + offset) = indexCX;
        mpsLookup(contextLabel + offset) = mpsCX;
    end



    
    
    %%% ================= 'FLUSH' =================

    [MQoutput, BP, C, CT] = T1_MQ_flush(MQoutput, A, BP, C, CT);




    %%% ================= Remove initial unused byte =================

	% temp = MQoutput;
	% MQoutput = [];
	% MQoutput(1:(BP-1)) = temp(2:(BP));
    
	
    
    %%% ================= Enforce 8-bits =================
    % Because MatLab converts to double upon function calls. 

    limitedMQoutput = bitand(MQoutput(1:size(MQoutput,2)), hex2dec('FF'));

    
    


    %%% ================= Verify Byte Sizes =================

    for i = 1:size(limitedMQoutput)
        if limitedMQoutput(i) ~= MQoutput(i)
            disp('Warning [T1_MQ]: Mismatch with 8-bits alignment.');
        end
    end
end

