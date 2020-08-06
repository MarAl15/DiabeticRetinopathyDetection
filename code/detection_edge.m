%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                   %
%           - DETECCIÓN Y SEGMENTACIÓN DEL BORDE CIRCULAR -         %
%                     Mª del Mar Alguacil Camarero                  %
%                                                                   %
%-------------------------------------------------------------------%
%                                                                   %
%  Nos permite detectar el borde circular que rodea a la retina en  %
% un imagen dada.                                                   %
%                                                                   %
% ENTRADA:                                                          %
%       I -> imagen a color de la retina ya leída.                  %
%                                                                   %
% SALIDA:                                                           %
%    edge -> imagen binaria devuelta con el borde circular          %
%            detectado.                                             %
%                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
function edge=detection_edge(I)    
    % Extracción el canal rojo
    red = I(:,:,1);
    
    % Umbralización por el método de Otsu
    T = graythresh(I);
    edge = imbinarize(red, T);
    
    
    % Gradiente morfológico con un elemento en forma de disco
    se = strel('disk', 10);
    edge = imdilate(edge, se) - imerode(edge, se);
