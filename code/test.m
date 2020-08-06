%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                           %
%                    - COMPROBACIÓN -                       %
%              Mª del Mar Alguacil Camarero                 %
%                                                           %
%-----------------------------------------------------------%
%                                                           %
%  Porcentajes de acierto de un subconjunto de muestras.    %
%                                                           %
% ENTRADA:                                                  %
%    features -> matriz que contiene todos los  vectores de % 
%                características.                           %
%      labels -> vector con las etiquetas asociadas.        %
%     indices -> subconjunto de los indices de las muestras %
%                que se desean utilizar para verificar.     %
%       model -> modelo entrenado.                          %  
%                                                           %
% SALIDA:                                                   %
%         SP -> Sensibilidad.                               %
%         SN -> Especificidad.                              %
%          A -> Exactitud.                                  %
%                                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [SP, SN, A] = test(features, grade, model, indices)
    % Vector de características
    X = features(indices, :);
    
    % Predicción del valor de las etiquetas
    label = predict(model, X);
    
    % Recuento
    N = length(indices);
    TP = length(find(and(grade(indices)==label, label==1)));
    TN = length(find(and(grade(indices)==label, label==0)));
    FP = length(find(and(grade(indices)~=label, label==1)));
    FN = N-TP-TN-FP; 


    % Sensibilidad
    SP = TP/(TP+FN);
    % Especificidad
    SN = TN/(TN+FP);
    
    % Exactitud
    A = (TN+TP)/N;
