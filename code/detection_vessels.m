%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%       - DETECCIÓN Y SEGMENTACIÓN DE VASOS SANGUÍNEOS -        %
%                   Mª del Mar Alguacil Camarero                %
%                                                               %
%---------------------------------------------------------------%
%                                                               %
%  Nos permite detectar los vasos sanguíneos en un imagen de la %
% retina dada.                                                  %
%                                                               %
% ENTRADA:                                                      %
%        I -> imagen a color de la retina ya leída.             %
%                                                               %
% SALIDA:                                                       %
%  vessels -> imagen binaria devuelta con los vasos sanguíneos  %
%            detectados.                                        %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function vessels=detection_vessels(I)    
    % Extracción del canal verde
    green = I(:,:,2);
    
    % CLAHE
    J = adapthisteq(green, 'NumTiles', [10,10], 'ClipLimit', 0.01, 'Distribution', 'uniform');
    
    % Normalizamos la intensidad de tal manera que se expanda el rango 
    % de intensidad.
    J = imadjust(J);
    
    % Aplicación del filtro de la mediana
    m=55; n=55;
    K = medfilt2(J, [m,n]);
    
    % Resta de imágenes
    K = K-J;
    
    % Umbralización mediante el método de Otsu
    T = graythresh(K);
    K = imbinarize(K, T);
    
    % Cierre con elemento estructurante con forma de línea
    len = 5;
    aux = K;
    for deg=0:60:180%0:30:180
      se = strel('line', len, deg);
      W = imclose(aux, se);
      K(W>0) = 1;
    end
    
    % Eliminamos los elementos conectados pequeños
    vessels = zeros(size(K));
    CC = bwconncomp(K);
    numPixels = cellfun(@numel,CC.PixelIdxList);
    for idx=1:CC.NumObjects
        if numPixels(idx)>=1000%1000
            vessels(CC.PixelIdxList{idx}) = 1;
        end
    end    
