%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                   %
%        - EXTRACCIÓN CARACTERÍSTICAS DE VARIAS IMÁGENES -          %
%                   Mª del Mar Alguacil Camarero                    %
%                                                                   %
%-------------------------------------------------------------------%
%                                                                   %
%  Crea el vector de características asociado a una retinografía    %
% dada.                                                             %
%                                                                   %
% ENTRADA:                                                          %
%      folder -> carpeta donde se encuentran las imágenes y el      % 
%                fichero datos.txt. Este archivo debe contener los  %
%                nombres de imágenes de las cuales se quiere        %
%                calcular los vectores de características y las     %
%                etiquetas asociadas a cada una.                    %
%    filename -> fichero que se creará conteniendo los vectores     %
%                de características y sus etiquetas asociadas.      %
%           r -> radio estimado del disco óptico.                   %
%                (Valor por defecto: 80)                            %
%                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function extractions(folder, filename, r)
    % Parámetros por defecto
    switch nargin
        case 3
        case 2
            r = 80;
        otherwise
            disp('Numero de argumentos incorrecto')
    end
    
    tic % tiempo
    
    % Obtenemos las nombres de las imágenes y sus etiquetas
    % correspondientes
    [images, grades] = dataIL(folder);
    
    % Abrimos el fichero en modo de escritura
    fileID = fopen(strcat(folder, '/',filename),'w');
    
    % Número de muestras a almacenar
    len = size(images,1); 
    fprintf(fileID,'%u \n', len); 
    
    % Etiquetas de las distintas imágenes
    fprintf(fileID,'%u \n', grades);
    
    % Extraemos las características de las distintas imágenes
    for i=1:len  
        i
        X = extraction(images(i,:), r);
  
        fprintf(fileID,'%u \t %u \t %u \t %f \t %f \t %f \t %f \n', X(1), X(2), X(3), X(4), X(5), X(6), X(7));        
    end
    
    %Cerramos el fichero
    fclose(fileID);
    
    toc
