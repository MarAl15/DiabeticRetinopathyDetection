%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                           %
%               - 5-FOLD CROSS-VALIDACIÓN -                 %
%              Mª del Mar Alguacil Camarero                 %
%                                                           %
%-----------------------------------------------------------%
%                                                           %
%  Validación mediante la técnica de validación cruzada de  %
% 5 iteraciones.                                            %
%                                                           %
% ENTRADA:                                                  %
%   filenameIN -> fichero con los vectores de caraterísticas%
%                y etiquetas asocidas.                      %
%  filenameOUT -> fichero donde se quieren almacenar los    %
%                 resultados devueltos.                     %
%            n -> número de características que se quieren  %
%                 tomar del vector de características, dicho%
%                 valor debe ser un entero contenido en el  %
%                 intervalo [1,7], sino se le asignará 7.   %
%                 (Valor por defecto: 7)                    %
%      classif -> clasificador que se quiere utilizar:      %
%                   - 'l' -> SVM con núcleo lineal.         %  
%                   - 'g' -> SVM con núcleo gaussiano.      % 
%                   - 'p' -> SVM con núcleo polinómico de   %
%                            orden 4.                       %    
%                   - En otro caso -> Árbol de decisión.    % 
%                 (Valor por defecto: 'p')                  %
%          num -> número de pruebas que se desea realizar.  %  
%                 (Valor por defecto: 5)                    %
%                                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function validation(filenameIN,  filenameOUT, n, classif, num)
    % Parámetros por defecto
    switch nargin
        case 5
        case 4
            num = 5;
        case 3
            num = 5;
            classif = 'p';
        case 2
            n=7;
            classif = 'p';
            num=5;
        otherwise
            disp('Numero de argumentos incorrecto')
    end
    
    if or(n>7, n<1)
        n=7;
    end
    
    % Extraemos las características de los distintos ficheros
    [X, y] = read(filenameIN);
    X = X(:,1:n);
    
    % Abrimos el fichero en modo de escritura
    fileID = fopen(strcat(filenameOUT),'w');
    
    % Matriz con las distintas particiones
    s = 0.2*length(y);
    p = zeros(5, s);
    
    fprintf(fileID,'Sensibilidad \t Especificidad \t Exactitud\n\n');
    
    k = 1:5;
    for i=1:num
        % Desordenamos
        r = randperm(length(y));

        % Particiones
        p(1,:) = r(1:s);
        p(2,:) = r(s+1:2*s);
        p(3,:) = r(2*s+1:3*s);
        p(4,:) = r(3*s+1:4*s);
        p(5,:) = r(4*s+1:5*s);
        
        % Resultados
        SN = zeros(1,5);
        SP = zeros(1,5);
        A = zeros(1,5);
        for j=1:5
            set = p(k(k~=j), :);
            model = train(X, y, set(:), classif);
            [SN(j), SP(j), A(j)] = test(X, y, model, p(j,:));
            fprintf(fileID,'%f \t\t %f \t\t %f\n', SN(j), SP(j), A(j));
        end
        
        fprintf(fileID,'------------------------------------------------------\n');
        fprintf(fileID,'%f \t\t %f \t\t %f\n', mean(SN), mean(SP), mean(A));
        fprintf(fileID,'\n');
    end
    
    %Cerramos el fichero
    fclose(fileID);
