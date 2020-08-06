%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                               %
%        - DETECCIÓN Y SEGMENTACIÓN DEL DISCO ÓPTICO -          %
%                   Mª del Mar Alguacil Camarero                %
%                                                               %
%---------------------------------------------------------------%
%                                                               %
%  Nos permite detectar el disco óptico en una imagen de la     %
% retina.                                                       %
%                                                               %
% ENTRADA:                                                      %
%       I -> imagen a color de la retina ya leída.              %
% vessels -> imagen binaria que contiene los vasos sanguíneos   %
%            de la imagen I.                                    %
%            (Valor por defecto: detección automática)          %
%       r -> radio estimado del disco óptico.                   %
%            (Valor por defecto: 80)                            %
%                                                               %
% SALIDA:                                                       %
%      od -> imagen binaria devuelta con el disco óptico        %
%            detectado.                                         %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function od=detection_opticdisc(I, vessels, r)
    % Parámetros por defecto
    switch nargin
        case 3
        case 2
            r = 80;
        case 1
            vessels = detection_vessels(I);
            r = 80;
        otherwise
            disp('Numero de argumentos incorrecto')
    end
    
    % Imagen a escala de grises
    gray = rgb2gray(I);
    
    
    % CLAHE
    J = adapthisteq(gray, 'NumTiles', [2,2], 'ClipLimit', 0.01, 'Distribution', 'uniform');
    
    % Ajuste de intensidad
    J = imadjust(J);
    
    % Umbralización 
    T = 0.99;
    J = imbinarize(J, T);
    
    % Erosión
    se = strel('disk',3);
    J = imerode(J, se);
    
    % Cierre
    se = strel('disk',1);
    J = imclose(J, se);
    
    % Relleno
    J = imfill(J, 'holes');
    
    % Cierre
    se = strel('disk',1);
    J = imclose(J, se);

    % Dilatación
    se = strel('disk',7);
    J = imdilate(J, se);
    
    % Buscamos el elemento que más puntos en común tenga con los 
    % vasos sanguíneos    
    CC = bwconncomp(J);
    if CC.NumObjects>0
        maximum = NaN;
        for idx=1:CC.NumObjects
            n = length(intersect(CC.PixelIdxList{idx}, find(vessels==1)));

            if or(isnan(maximum), maximum<n)
                maximum = n;
                index = idx;
            end
        end
        
        % Calculamos el centro
        [rows, cols] = ind2sub(size(J), CC.PixelIdxList{index});
        min_row = min(rows);
        y = round(min_row+(max(rows)-min_row)/2);
        min_col = min(cols);
        x = round(min_col+(max(cols)-min_col)/2);
        
        % Dibujamos el DO como un círculo
        [imageSizeY, imageSizeX] = size(J);
        [columnsInImage, rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
        od = (rowsInImage - y).^2 + (columnsInImage - x).^2 <= r.^2;
    end
