%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                           %
%               - MÉTODO DE MÁXIMA ENTROPÍA -               %
%                Mª del Mar Alguacil Camarero               %
%                                                           %
%-----------------------------------------------------------%
%                                                           %
%  Obtiene la imagen binaria a partir del umbral calculado  % 
% mediante el método de máxima entropía.                    %
%                                                           %
% ENTRADA:                                                  %
%        I -> imagen a color ya leída.                      %
%                                                           %
% SALIDA:                                                   %
%       I1 -> imagen binaria devuelta.                      %
%                                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function I1 = immaxentropy(I)
    % Tamaño de la imagen I
    [N,M]=size(I);
    
    % Histograma de I - frecuencia de ocurrencia
    f=imhist(I);
    
    % Normalizamos el histograma - probabilidad de ocurrencia
    p=f/(N*M);
    
    % Buscamos el umbral óptimo  
    t = 1;
    Hmax = NaN;
    for s=1:256
        ps = sum(p(1:s));
        pm = 1 - ps;
        
        w = p(1:s)/ps;
        index = find(w~=0);
        a = w(index) .* log(w(index)); 
        HA = - sum(a);
        
        w = p(s+1:end)/pm;
        index = find(w~=0);
        b = w(index) .* log(w(index)); 
        HB = - sum(b);
        H = HA+HB;
        if or(isnan(Hmax), Hmax<H)
            Hmax = H;
            t = s;
        end    
    end

    % Imagen binaria a partir del umbral t
    I1 = zeros(N,M);
    I1(I>t) = 1;
        
    
    
    
    

