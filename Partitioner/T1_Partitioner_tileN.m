function [tileN] = T1_Partitioner_tileN(N, image, tileSize)
%TILEN Returns the N-th tile in image. 
    %
    
    width = ceil(size(image,2) / tileSize(2));
    
    index(1) = floor(N / width);
    index(2) = mod(N, width);
    
    position(1) = index(1) * tileSize(1) + 1;
    position(2) = index(2) * tileSize(2) + 1;
    
    positionEnd(1) = (index(1) + 1) * tileSize(1); 
    positionEnd(2) = (index(2) + 1) * tileSize(2); 
    
    tileN = image(position(1):positionEnd(1), position(2):positionEnd(2));
end

