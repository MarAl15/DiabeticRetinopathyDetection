%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                   %
%        - DETECCIÓN Y SEGMENTACIÓN DE LOS MICROANEURISMAS -        %
%                   Mª del Mar Alguacil Camarero                    %
%                                                                   %
%-------------------------------------------------------------------%
%                                                                   %
%  Nos permite detectar los microaneurismas en una imagen de la     %
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
%      he -> imagen binaria que contiene los exudados duros de la   %
%            imagen I.                                              %
%            (Valor por defecto: detección automática)              %
%                                                                   %
%                                                                   %
% SALIDA:                                                           %
%      ma -> imagen binaria devuelta con los microaneurismas        %
%            detectados.                                            %
%                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ma=detection_microaneurysms(I, vessels, od, edge, he)
    % Parámetros por defecto
    switch nargin
        case 5
        case 4
            he = detection_hardexudates(I, vessels, od, edge);
        case 3
            edge = detection_edge(I);
            he = detection_hardexudates(I, vessels, od, edge);
        case 2
            edge = detection_edge(I);
            od = detection_opticdisc(I, vessels);
            he = detection_hardexudates(I, vessels, od, edge);
        case 1
            edge = detection_edge(I);
            od = detection_opticdisc(I);
            vessels = detection_vessels(I);
            he = detection_hardexudates(I, vessels, od, edge);
        otherwise
            disp('Numero de argumentos incorrecto')
    end
    
    % Canal de intensidad
    gray = 0.5*I(:,:,1)+0.5*I(:,:,2);

    % Aplicación del filtro de la mediana
    m=30; n=30;
    J = medfilt2(gray, [m, n]);

    %     % Diferencia de imágenes
    J = J - gray;

    % CLAHE
    J = adapthisteq(J);
    
    % Umbralización por el método de Otsu modificado
    T = graythresh(J)+0.08;
    J = imbinarize(J, T);
    

    % Eliminación del resto de componentes
    J(vessels>0) = 0;
    J(od>0) = 0;
    J(he>0) = 0;
    J(edge>0) = 0;
    
    % Elementos conectados con forma circular
    [centers, radii] = imfindcircles(J, [5 50], 'Sensitivity', 0.8);
    
    [imageSizeY, imageSizeX] = size(J);
    ma = zeros(imageSizeY, imageSizeX);
    [columnsInImage, rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
    
    for i=1:length(radii)
        circle = double((rowsInImage - centers(i,2)).^2 + (columnsInImage - centers(i,1)).^2 <= radii(i).^2);
        ma(circle>0) = 1;
    end
