function [EBCOToutput, emptyBitplanes] = T1_EBCOT(codeblock, subbandType, bitsPerPixel)
%%% The EBCOT coder performs coefficient bit modelling through 
%   coding passes on one codeblock, over each bitplane. It returns a list 
%   of context labels and decisions intended for an MQ coder. 
    %
    
    EBCOToutput = [];  % Data to be sent for MQ Coder. 
    %%% EBCOToutput elements {contextLabel, decision, source, row, column}: 
    %   'contextLabel' has values in range [0, 18].
    %       [0 to 8] from significance propagation or cleanup coding. 
    %       [9 to 13] from sign coding. 
    %       [14 to 16] from magnitude coding. 
    %       [17] from run-length coding. 
    %       [18] from uniform coding. 
    %       Context label can have any chosen values. Change if convenient. 
    %   'decision' has values in range [0, 1]. 
    %       [0 to 1] from the coefficient bit. 
    %       Or from the run-length sequence:
    %           [0] from four zeroes. 
    %           [1] from not four zeroes. Next two from uniform.
    %   The remaining are present to help debug. 
    %   'source' has values [1, 6]. 
    %       {1} from Significance Coding. 
    %       {2} from Magnitude Coding. 
    %       {3} from Cleanup Coding. 
    %       {4} from Sign Coding. 
    %       {5} from Run-length Coding. 
    %       {6} from Uniform Coding. 
    %   'row' describes the position this data was found at. 
    %   'column' describes the position this data was found at.
    %%%
    
    

    %%% ================= Codeblock Preparation =================

    % Simulate sign magnitude representation. 
    codeblockSigns  = sign(codeblock);
    codeblockAbs    = abs(codeblock);
    
    codeblockHeight = size(codeblock, 1);
    codeblockWidth  = size(codeblock, 2);

    % Split into bitplanes. 
    for i = 1:codeblockHeight
        for j = 1:codeblockWidth
            for k = bitsPerPixel:-1:1    % MSB to LSB.
                codeblockBitplanes(i,j,k) = bitget(codeblockAbs(i,j), k); 
            end
        end
    end

  


    %%% ================= Coding Pass Preparation =================

    % Used in Cleanup Pass and Magnitude Refinement Pass. Boolean values only. 
    needCleanup(1:codeblockHeight, 1:codeblockWidth) = 1; 
    needFirstRefinement(1:codeblockHeight, 1:codeblockWidth) = 1; 
    
    % Used in Sign Coding. % +1 or -1 values only. 
    codeblockSignsPadded(1:(codeblockHeight+2), 1:(codeblockWidth+2)) = 1; % Padded with +1 around the edges.
    codeblockSignsPadded(2:(codeblockHeight+1), 2:(codeblockWidth+1)) = codeblockSigns(1:codeblockHeight, 1:codeblockWidth); 
    
    % Used everywhere. Boolean values only. Initialized to 0. 
    significantStatesPadded(1:(codeblockHeight+2), 1:(codeblockWidth+2)) = 0; % Padded with 0 around the edges. 
    %%% Because of padding: To get the current coefficient bit's state, 
    %   add one to the indexes. Example: 
    %   coefficientBit = bitplane(row,col); 
    %   coefficientState = significantStatesPadded(row+1, col+1);
    %%%
    
    
    
    
    
    %%% =================                     =================
    %%% ================= Begin Coding Passes =================
    %%% =================                     =================





    %%% ================= Skip Empty Bitplanes =================

    for bitNumber = bitsPerPixel:-1:1       % MSB to LSB.
        bitplane = codeblockBitplanes(:,:,bitNumber);
        if any(any(any(any(bitplane))))  % Is there at least one 1?
            break; % This and subsequent bitplanes are not skipped. 
        end
    end
    emptyBitplanes = bitsPerPixel - bitNumber; % Output for File Packetizer.
    
    
    
    %%% ================= Perform First Cleanup Pass =================
    
    % Can skip other passes than cleanup, because: 
    % SP Pass initially has no 'neighbours with significance state == 1'. 
    % MR Pass initially has no 'significance state == 1'.
    
    [EBCOToutput, significantStatesPadded] ...
        = T1_EBCOT_cleanupPass(EBCOToutput, bitplane, significantStatesPadded, subbandType, codeblockSignsPadded, needCleanup);
    
    
    
    %%% ================= Perform Normal Coding Pass =================
    
    for i = (bitNumber-1):-1:1      % MSB to LSB.
        bitplane = codeblockBitplanes(:,:,i);
        
        % Update needRefinement before changes to significance states. 
        needRefinement(1:codeblockHeight,1:codeblockWidth) ...
            = significantStatesPadded(2:(codeblockHeight+1), 2:(codeblockWidth+1));
        
        % Run coding passes in normal order. 
        [EBCOToutput, significantStatesPadded, needCleanup] ...
            = T1_EBCOT_significancePass(EBCOToutput, bitplane, significantStatesPadded, subbandType, codeblockSignsPadded);
        [EBCOToutput, needFirstRefinement] ...
            = T1_EBCOT_magnitudePass(EBCOToutput, bitplane, significantStatesPadded, needRefinement, needFirstRefinement);
        [EBCOToutput, significantStatesPadded] ...
            = T1_EBCOT_cleanupPass(EBCOToutput, bitplane, significantStatesPadded, subbandType, codeblockSignsPadded, needCleanup);
    end
end 
