%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                   %
%           - EXTRACCIÓN CARACTERÍSTICAS DE UNA IMAGEN -            %
%                   Mª del Mar Alguacil Camarero                    %
%                                                                   %
%-------------------------------------------------------------------%
%                                                                   %
%  Crea el vector de características asociado a una retinografía    %
% dada.                                                             %
%                                                                   %
% ENTRADA:                                                          %
%       image -> imagen a color de la retina (nombre).              %
%           r -> radio estimado del disco óptico.                   %
%                (Valor por defecto: 80)                            %
%                                                                   %
% SALIDA:                                                           %
%    features -> vector de características devuelto.                %
%                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function features=extraction(image, r) 
    % Parámetros por defecto
    switch nargin
        case 3
        case 2
            r = 80;
        otherwise
            disp('Numero de argumentos incorrecto')
    end
       
    % Leemos la imagen
    I=imread(image);
    
    % Extracción de áreas
    vessels = detection_vessels(I);
    edge = detection_edge(I);
    od = detection_opticdisc(I, vessels, r);
    he = detection_hardexudates(I, vessels, od, edge);
    ma = detection_microaneurysms(I, vessels, od, edge, he);
    
    % GLCM
    green = I(:,:,2);
    glcm = graycomatrix(green);
    %glcm = graycomatrix(green, 'NumLevels', 256, 'GrayLimits', []);
    stats = graycoprops(glcm);

    features = [length(find(vessels==1)), length(find(he==1)), length(find(ma==1)), stats.('Contrast'), stats.('Homogeneity'), stats.('Correlation'), stats.('Energy')];
