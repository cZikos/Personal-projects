%  ������� ��� ������ �������������
%  ����� ������� 5393
%  ������� ������� ��������� ��� TLE set �� ����� matlab

clear all;
close all;
clc;

%������� �������.

filename =input('enter file name','s');
fid = fopen(filename, 'rb');
L1c = fscanf(fid,'%24c%',1); 
L2c = fscanf(fid,'%71c%',1);
L3c = fscanf(fid,'%71c%',1);

%�������� TLE

fprintf(L1c);
fprintf(L2c);
fprintf([L3c,'\n']);
fclose(fid);

%������� ������������ ��������� ��� ������

fid = fopen(filename, 'rb');
L1 = fscanf(fid,'%24c%*s',1);      
L2 = fscanf(fid,'%d%6d%*c%5d%*3c%*2f%f%f%5d%*c%*d%5d%*c%*d%d%5d',[1,9]);
L3 = fscanf(fid,'%d%6d%f%f%f%f%f%f%f',[1,8]);
fclose(fid);


           %������� �������� �������� �� ����������
           
           
epoch = L2(1,4)*24*3600;        % Epoch : ������� ������ ��������� ���������
inc   = L3(1,3);                % inclination : ����� ��� ������ ����� ��� �������� �� ��� ��������� ����� ����� x
RAAN  = L3(1,4);                % Right Ascension of the Ascending Node.� ����� ��� ������������ ��� ��� ������ ��� ������ �� ������ ��� ��� �� �� ������ ������� ��� ��������� ���� ��� ����� ���� ���������� �����
                                %                                                                ��� ��� ������ ��� ������ �� ������ ��� ��� �� �� ������ ��� ��������                                                         
ecc   = L3(1,5)/1e7;            % ������������
w     = L3(1,6);                % Argument of periapsis : ����� ��� ������ ����� ��� �������� �� ��� ��������� ����� ����� z
M     = L3(1,7);                % Mean anomaly
n     = L3(1,8);                % Mean motion [Revs per day]

% ����������� �������� ��������� ���� ��� ��� �������

GC = 398600;                             %��������� ������������� �������           

a = 149600000;

E =  M + ecc*sind(M);                    %����������� Eccentric anomaly (�) ���� mean anomaly

c=a*ecc;                                 % �������� ��� �� ������ ����������� �������

b=((a^2)-(c^2))^(1/2);                  %������ ������ ��������
 
T=acos((cos(E)-ecc)/(1-ecc*cos(E)));    %����������� true anomaly
 
r=(a*(1-ecc)*(1+ecc))/(1+ecc*cos(T));   %����������� ��������� ���-���������
 
R = ((r^2)+(c^2)-(2*r*c*cos(180-T)))^(1/2);   % ����������� ��������� ��������� �� �� ������ ��� ��������(���� ������)
 
   
OE = [a ecc inc RAAN w E];
fprintf('\n a [km]        e        inc [deg]     RAAN [deg]  w[deg]       E [deg] \n ')
fprintf('%4.2f  %4.4f   %4.4f       %4.4f     %4.4f    %4.4f', OE);                       %�������� ��� 6 ������� ��������� ���������� �������


 
 
 %����������� ������������� ���������
 [satx,saty]=pol2cart(M,R);
 
 
 %��������� ���������� �������
 
 t=linspace(0,360,5760);
 x=a*cos(t);
 y=b*sin(t);                             
 figure
 plot(satx,saty,'d',0,b,'>',x,y,'r',c,0,'.','markersize',10);
 el=-inc;
 az=90+RAAN;
 view(az,el);
 axis off;

 

 
 
 
 






