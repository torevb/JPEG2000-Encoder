clear



%%% ================= Inputs =================

% codeblock = [10; 1; 3; -7];
% bitsPerPixel = 8;
% emptyBitplanes = 4;

EBCOToutput = ...
    [17 1 5 1 1;18 0 6 1 1;18 0 6 1 1;9 0 4 1 1;5 0 3 2 1;0 0 3 3 1;0 0 3 4 1;5 0 1 2 1;14 0 2 1 1;0 0 3 3 1;0 1 3 4 1;9 1 4 4 1;5 0 1 2 1;5 1 1 3 1;10 1 4 3 1;16 1 2 1 1;15 1 2 4 1;8 1 1 2 1;10 0 4 2 1;16 0 2 1 1;15 1 2 3 1;16 1 2 4 1] ...
    ;

%%% EBCOToutput elements: 
%   {contextLabel, decision, source, row, column}
%   'contextLabel' has values [0, 18].
%       [0, 8] from Significance/Cleanup Coding.
%       [9, 13] from Sign Coding. 
%       [14, 16] from Magnitude Coding. 
%       {17} from Run-length Coding. 
%       {18} from Uniform Coding. 
%       Context labels can have any chosen values. Change if convenient. 
%   'decision' has values {0, 1}. This is usually the coefficient bit.




%%% ================= Outputs =================

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
BPST = 2;   	     % Initialized to 2 to allow 1-indexed arrays in MatLab. 
MQoutput(1) = 0; % Not used properly. 
%%%


A = uint32(hex2dec('8000'));
C = uint32(0);
BP = BPST - 1;  % BP always increments over time after this. 
CT = 12;

if MQoutput(BP) == hex2dec('FF') % Can be skipped (see BPST not used properly).
    CT = 13;
end



for i = 1:size(EBCOToutput,1)
    %%% ================= Read CX, D =================
	
    context = EBCOToutput(i,1);       % CX.
    decision = EBCOToutput(i,2);      % D.
    
    indexCX = indexLookup(context + offset);
    mpsCX = mpsLookup(context + offset);
    
    
    
    %%% ================= 'ENCODE' =================
    
    [MQoutput, indexCX, mpsCX, A, BP, C, CT] = T1_MQ_decideEncode(MQoutput, indexCX, mpsCX, decision, A, BP, C, CT);
    
    indexLookup(context + offset) = indexCX;
    mpsLookup(context + offset) = mpsCX;
end



%%% ================= 'FLUSH' =================

[MQoutput, BP, C, CT] = T1_MQ_flush(MQoutput, A, BP, C, CT);


%%% ================= Enforce 8-bits =================
% Because MatLab converts to double upon function call. 

limitedMQoutput = bitand(MQoutput(1:size(MQoutput,2)), hex2dec('FF'));



%%% ================= Verify Byte Sizes =================

for i = 1:size(limitedMQoutput)
    if limitedMQoutput(i) ~= MQoutput(i)
        disp('Warning [T1Encoder_MQ]: Mismatch with 8-bits alignment.');
    end
end
