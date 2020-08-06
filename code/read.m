%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                   %
%           - VECTORES DE CARACTERÍSTICAS Y ETIQUETAS -             %
%                   Mª del Mar Alguacil Camarero                    %
%                                                                   %
%-------------------------------------------------------------------%
%                                                                   %
%  Se leen los vectores de características y las etiquetas asociadas%
% de un fichero.                                                    %
%                                                                   %
% ENTRADA:                                                          %
%    filename -> archivo con los vectores de características y      % 
%                etiquetas asociadas.                               %
%                                                                   %
% SALIDA:                                                           %
%           X -> matriz que contiene todos vectores de              %
%                características.                                   %
%           y -> vector con las etiquetas asociadas.                %
%                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function [X, y]=read(filename)
    % Abrimos el fichero en modo de lectura
    fileID = fopen(filename,'rt');
    
    % Leemos los datos del fichero
    formato = '%f'; % formato de cada línea 
    data = cell2mat(textscan(fileID, formato));
    
    % Cerramos el fichero
    fclose(fileID);
    
    % Número de muestras almacenadas en el fichero
    n = data(1);
    % Tamaño de cada muestra
    m = 7;
    
    % Etiquetas de las distintas muestras
    y = data(2:n+1);
    
    % Matriz nxm
    X = zeros(n, m);
    index = n+1;
    for i=1:n
        X(i, :) = data(index+1:index+m);
        index = index+m;
    end
    
    % Normalizamos dicha matriz por columnas
    for j=1:size(X, 2)
        a = min(X(:,j));
        b = max(X(:,j));
        
        X(:,j) = (X(:,j)-a)/(b-a);       
    end
