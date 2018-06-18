function [codeblockN] = T1_Partitioner_codeblockN(N, image_subband, codeblockSize)
%CODEBLOCKN Returns the N-th code-block in image. Image should be quantized
%   and DWT-ed. 
    %
    
    width = ceil(size(image_subband,2) / codeblockSize(2));
    
    index(1) = floor( N / width);
    index(2) = mod(N, width);
    
    position(1) = index(1) * codeblockSize(1) + 1;
    position(2) = index(2) * codeblockSize(2) + 1;
    
    positionEnd(1) = (index(1) + 1) * codeblockSize(1); 
    positionEnd(2) = (index(2) + 1) * codeblockSize(2); 
    
    codeblockN = image_subband(position(1):positionEnd(1), position(2):positionEnd(2));
end

