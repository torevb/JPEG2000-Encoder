clear 


%%% ================ T1 Partitioner ================
%%% In: Quantized discrete wavelet transformed tile component. 
%%% Out: Codeblocks for T1 EBCOT Coder. 
%%% Out: Details about layer, sub-bands, precincts, etc for T2 Data Orderer. 





%%% ================ T1 EBCOT Coder ================
%%% In: Codeblocks. 
%%% Out: Sequence of Context Labels and Decisions for MQ Coder. 
subband = 'HL';

codeblock = [10; 1; 3; -7];
% codeblock = [10 2 -4; 8 1 -7; -9 3 3; -7 1 -5];

% codeblockMax    = max(max(max(codeblock)));
% bitsPerPixel   = ceil(log2(codeblockMax)); 
bitsPerPixel   = 8;


[EBCOToutput, emptyBitplanes] = T1_EBCOT(codeblock, subband, bitsPerPixel);





%%% ================ T1 MQ Coder ================
%%% In: Sequence of Context Labels and Decisions. 
%%% Out: Bitstream for T2 Data Orderer. 

MQoutput = T1_MQ(EBCOToutput);



%%% ================ T2 Data Orderer ================
%%% In: Details about layer, sub-bands, precincts, etc. 
%%% In: Bitstream. 
%%% Out: Ordered bitstream for T2 Packetizer. 





%%% ================ T2 Packetizer ================
%%% In: Ordered bitstream. 
%%% Out: Jp2 file. I.e. ordered bitstream with markers, headers and boxes. 





