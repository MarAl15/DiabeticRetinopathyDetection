%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                   %
%        - DETECCIÓN Y SEGMENTACIÓN DE LOS EXUDADOS DUROS -         %
%                   Mª del Mar Alguacil Camarero                    %
%                                                                   %
%-------------------------------------------------------------------%
%                                                                   %
%  Nos permite detectar los exudados duros en una imagen de la      %
% retina, si existiesen.                                            %
%                                                                   %
% ENTRADA:                                                          %
%       I -> imagen a color de la retina ya leída.                  %
% vessels -> imagen binaria que contiene los vasos sanguíneos de la %
%            imagen I.                                              %
%            (Valor por defecto: detección automática)              %
%      od -> imagen binaria que contiene el disco óptico de la      %
%            imagen I.                                              %
%            (Valor por defecto: detección automática)              %
%    edge -> imagen binaria que contiene el borde circular que      %
%            rodea a la retina en I.                                %
%            (Valor por defecto: detección automática)              %
%                                                                   %
%                                                                   %
% SALIDA:                                                           %
%      he -> imagen binaria devuelta con los exudados duros         %
%            detectados.                                            %
%                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function he=detection_hardexudates(I, vessels, od, edge)
     % Parámetros por defecto
    switch nargin
        case 4
        case 3
            edge = detection_edge(I);
        case 2
            edge = detection_edge(I);
            od = detection_opticdisc(I, vessels);
        case 1
            edge = detection_edge(I);
            vessels = detection_vessels(I);
            od = detection_opticdisc(I, vessels);
        otherwise
            disp('Numero de argumentos incorrecto')
    end
    
    % Canal rojo
    red = I(:,:,1);
    
    % Transformada de Top-Hat
    se_topHat = strel('disk',43);
    he = imtophat(red, se_topHat);
    
    % Eliminación del borde circular
    he(edge>0) = 0;
    
    % Umbralización por el método de entropía máxima
    he = immaxentropy(he);
    
    % Eliminación de vasos sanguíneos y disco óptico 
    he(vessels>0) = 0;
    he(od>0) = 0;
