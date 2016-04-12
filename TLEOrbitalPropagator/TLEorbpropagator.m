%  Εργασια στο μαθημα τηλεπισκοπιση
%  Ζηκος Χρηστος 5393
%  Εξαγωγη τροχιας δορυφορου απο TLE set με χρηση matlab

clear all;
close all;
clc;

%Ανοιγμα αρχειου.

filename =input('enter file name','s');
fid = fopen(filename, 'rb');
L1c = fscanf(fid,'%24c%',1); 
L2c = fscanf(fid,'%71c%',1);
L3c = fscanf(fid,'%71c%',1);

%εμφανιση TLE

fprintf(L1c);
fprintf(L2c);
fprintf([L3c,'\n']);
fclose(fid);

%ορισμος αναμενωμενων στοιχειων ανα γραμμη

fid = fopen(filename, 'rb');
L1 = fscanf(fid,'%24c%*s',1);      
L2 = fscanf(fid,'%d%6d%*c%5d%*3c%*2f%f%f%5d%*c%*d%5d%*c%*d%d%5d',[1,9]);
L3 = fscanf(fid,'%d%6d%f%f%f%f%f%f%f',[1,8]);
fclose(fid);


           %ορισμος χρησιμων στοιειων ως μεταβλητες
           
           
epoch = L2(1,4)*24*3600;        % Epoch : χρονικη στιγμη αποστολης δεδομενων
inc   = L3(1,3);                % inclination : γωνια του κυριου αξονα της ελλειψης με τον ισημερινο δισκο αξονα x
RAAN  = L3(1,4);                % Right Ascension of the Ascending Node.Η γωνια που σχηματιζεται απο την ευθεια που ενωνει το κεντρο της γης με το σημειο εισοδου του δορυφορου κατα την ανοδο στον ιισημερινο δισκο
                                %                                                                και την ευθεια που ενωνει το κεντρο της γης με το κεντρο της ελλειψης                                                         
ecc   = L3(1,5)/1e7;            % εκκεντροτητα
w     = L3(1,6);                % Argument of periapsis : γωνια του κυριου αξονα της ελλειψης με τον ισημερινο δισκο αξονα z
M     = L3(1,7);                % Mean anomaly
n     = L3(1,8);                % Mean motion [Revs per day]

% Υπολογισμος χρησιμων στοιχειων μεσω των ηδη γνωστων

GC = 398600;                             %παγκόσμια βαρυτημετρική σταθερά           

a = 149600000;

E =  M + ecc*sind(M);                    %υπολογισμος Eccentric anomaly (Ε) μεσω mean anomaly

c=a*ecc;                                 % αποσταση γης με κεντρο ελλειπτικης τροχιας

b=((a^2)-(c^2))^(1/2);                  %μικρος αξονας ελλειψης
 
T=acos((cos(E)-ecc)/(1-ecc*cos(E)));    %Υπολογισμος true anomaly
 
r=(a*(1-ecc)*(1+ecc))/(1+ecc*cos(T));   %Υπολογισμος αποστασης γης-δορυφορου
 
R = ((r^2)+(c^2)-(2*r*c*cos(180-T)))^(1/2);   % Υπολογισμος αποστασης δορυφορου με το κεντρο της ελλειψης(αρχη αξονων)
 
   
OE = [a ecc inc RAAN w E];
fprintf('\n a [km]        e        inc [deg]     RAAN [deg]  w[deg]       E [deg] \n ')
fprintf('%4.2f  %4.4f   %4.4f       %4.4f     %4.4f    %4.4f', OE);                       %Εμφανιση των 6 βασικων στοιχειων καθορισμου τροχιας


 
 
 %Καρτεσιανες συντεταγμενες δορυφορου
 [satx,saty]=pol2cart(M,R);
 
 
 %Υλοποιηση γραφιματος τροχιας
 
 t=linspace(0,360,5760);
 x=a*cos(t);
 y=b*sin(t);                             
 figure
 plot(satx,saty,'d',0,b,'>',x,y,'r',c,0,'.','markersize',10);
 el=-inc;
 az=90+RAAN;
 view(az,el);
 axis off;

 

 
 
 
 






