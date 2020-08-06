%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                           %
%                    - ENTRENAMIENTO -                      %
%              Mª del Mar Alguacil Camarero                 %
%                                                           %
%-----------------------------------------------------------%
%                                                           %
%  Se entrenan un subconjunto de muestras a partir de un    %
% clasificador determinado.                                 %
%                                                           %
% ENTRADA:                                                  %
%    features -> matriz que contiene todos los  vectores de % 
%                características.                           %
%      labels -> vector con las etiquetas asociadas.        %
%     indices -> subconjunto de los indices de las muestras %
%                que se desean utilizar para entrenar       %
%     classif -> clasificador que se quiere utilizar:       %
%                   - 'l' -> SVM con núcleo lineal.         %  
%                   - 'g' -> SVM con núcleo gaussiano.      % 
%                   - 'p' -> SVM con núcleo polinómico de   %
%                            orden 4.                       %    
%                   - En otro caso -> Árbol de decisión.    %  
%                                                           %
% SALIDA:                                                   %
%       model -> modelo entrenado devuelto.                 %
%                                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function model=train(features, labels, indices, classif)
%     tic
    
    X = features(indices,:);
    y = labels(indices);

    switch classif
        case 'p'
            model = fitcsvm(X,y, 'KernelFunction', 'polynomial', 'PolynomialOrder', 4);
        case 'l'
            model = fitcsvm(X,y);
        case 'g'
            model = fitcsvm(X,y, 'KernelFunction', 'gaussian'); 
        otherwise
            model = fitctree(X,y);
    end   
    
%     toc
