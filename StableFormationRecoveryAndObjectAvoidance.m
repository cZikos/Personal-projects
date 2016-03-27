clear all
close all
clc


%������� ������ ������ 
RbtNbr = input('Enter nuber of robots');
RbtCoos = random('unid',25,[2,RbtNbr]); % �� ������ ������������ �� ������� ������ ���� �� ��� ����� ����� �� ���������� 25x25
SetCoos = RbtCoos;                                  

%������� ����������� (��� ������)
SetForm = random('unid',10,[2,RbtNbr]);
for i=2:RbtNbr
    for j=1:RbtNbr
        if i~=j
            if SetForm(:,i)==SetForm(:,j)
              SetForm(:,i)=SetForm(:,i)-[1;1];
              return
            end
        end
    end
end                                     % ������� ��� �� ��� ������ ���� ������ ���� ����������

% �� u ����� � ������ ��� �� ������� ������ ��������
u = [0 ones(1,49) cos(0:pi/49:pi) -ones(1,100); 0 zeros(1,49) sin(0:pi/49:pi) zeros(1,100)]; % �� ����� ���� ����� �� ����� ���� ������������ ���� ������� ������ 0 
                                                                                                                          % ������ ��� ������ ����������. ���� � ������ ����� :
                                                                                                                          %                                                   - 50 ������ �����
                                                                                                                          %                                                   - ������ 180 ������ �� 50 ������
                                                                                                                          %                                                   - 100 ������ ���� 

%������������ �������� �����
Tmax=200;                                                                    % ������ ������������ 
CoS=[sum(SetForm(1,:))/RbtNbr sum(SetForm(2,:))/RbtNbr];% �� ������ ��� �������. 
Form = zeros(2,RbtNbr);                                                 % � ���������� ������������� ��� ����������� �� ���� ������� ������ t
XRlvnt = zeros(1,RbtNbr);     
YRlvnt = zeros(1,RbtNbr);
AnglRlvnt = zeros(1,RbtNbr);
Theta = zeros(1,RbtNbr);
DistRlvnt = zeros(1,RbtNbr);
PlaneAngle = 0;
Temp=zeros(1,160);
col=0;
SF = zeros(2,RbtNbr);                                                    % ���������� ��������
Vform = zeros(2,RbtNbr);                                               % �� �������� ��� ������� ��� ���������� �� ������ ���� ���� ��� ���� ����������
Vobs = zeros(2,RbtNbr);                                                 % �� �������� ��� ��������� ������� ��� ������� ��������
Vcol = zeros(2,RbtNbr);                                                  % �� �������� ��� ��������� ������� ��� ������� �����������

% �������
 Obs=[random('unid',30,[1,50]) ;random('unid',30,[1,50])+20*ones(1,50)]; 

for r=1:RbtNbr                                                      
    % �� �������� ������������� ��� ���� ������ (�� ����������) �� ���� �� ������ ��� �������  
        XRlvnt(r) = SetForm(1,r) - CoS(1);
        YRlvnt(r) = SetForm(2,r) - CoS(2);
        DistRlvnt(r) = sqrt(XRlvnt(r)^2 + YRlvnt(r)^2);
        AnglRlvnt(r) = atan(abs(YRlvnt(r))/abs(XRlvnt(r)));
        if XRlvnt(r) < 0
            AnglRlvnt(r) = pi-AnglRlvnt(r);
        end
        if YRlvnt(r) < 0
           AnglRlvnt(r) = 2*pi-AnglRlvnt(r);
        end    
end         

 for t=1:Tmax
    CoS = [CoS(1)+u(1,t) CoS(2)+u(2,t)];     %������ ��� ������� ��� �������( u )
    if t~=1
       PlaneAngle = atan(abs(u(2,t)/u(1,t)));
       if u(1,t)<0
            PlaneAngle = pi-PlaneAngle;
       end
       if u(2,t)<0
           PlaneAngle = 2*pi-PlaneAngle;
       end   
    end
    
     for r=1:RbtNbr
       
       %����������� ������� ���������� ���� ����������  
       Form(1,r) = CoS(1) + DistRlvnt(r)*cos(AnglRlvnt(r)+PlaneAngle);          % ������ ��� ���������� ������� ��� �����������
       Form(2,r) = CoS(2) +DistRlvnt(r)*sin(AnglRlvnt(r)+PlaneAngle);   
       Theta(r) = atan(abs((Form(2,r)-RbtCoos(2,r))/(Form(1,r)-RbtCoos(1,r))));   % ����������� ������ ��������� ������-���������� ����� 
       if Form(1,r) < RbtCoos(1,r)
           Theta(r) = pi-Theta(r);
       end
       if Form(2,r) < RbtCoos(2,r)
           Theta(r) = 2*pi-Theta(r);
       end
       
       TrvlDist = sqrt(((Form(2,r)-RbtCoos(2,r))^2 + (Form(1,r)-RbtCoos(1,r))^2)); % ����������� ��������� ������-���������� �����
        if TrvlDist<1.2                                                                                     
           Vform(1,r) =  TrvlDist*cos(Theta(r));
           Vform(2,r) =  TrvlDist*sin(Theta(r));
        else
           Vform(1,r) =  1.2*cos(Theta(r));
           Vform(2,r) =  1.2*sin(Theta(r));
        end

      % ����������� ��������� ������� �������� �����������
     for i=1:RbtNbr                          
        if i~=r
             ColDist = sqrt(((RbtCoos(2,i)-RbtCoos(2,r))^2 + (RbtCoos(1,i)-RbtCoos(1,r))^2));
             ColAngle = atan(abs((RbtCoos(2,i)-RbtCoos(2,r))/(RbtCoos(1,i)-RbtCoos(1,r))));    
             if RbtCoos(1,i) < RbtCoos(1,r)
                 ColAngle = pi-ColAngle;
             end
             if RbtCoos(2,i) < RbtCoos(2,r)
                 ColAngle = 2*pi-ColAngle;
             end 
             if ColDist<0.4
                 Vcol(1,r) =Vcol(1,r) - 0.4*cos(ColAngle);
                 Vcol(2,r) = Vcol(2,r) - 0.4*sin(ColAngle);
             end      
       end
     end
     
     % ����������� ��������� ������� �������� ��������   
     for j=1:50
          ObsDist = sqrt(((RbtCoos(2,r)-Obs(2,j))^2 + (RbtCoos(1,r)-Obs(1,j))^2));
          ObsAngle = atan(abs((Obs(2,j)-RbtCoos(2,r))/(Obs(1,j)-RbtCoos(1,r))));
          if Obs(1,j) < RbtCoos(1,r)
             ObsAngle = pi-ObsAngle;       
          end
          if Obs(2,j) < RbtCoos(2,r)
             ObsAngle = 2*pi-ObsAngle;
          end
          if abs(Theta(r)-ObsAngle)<pi/4
             if ObsDist<5
                    if ObsAngle>PlaneAngle
                        Vobs(1,r)=Vobs(1,r)+cos(ObsAngle+pi);
                        Vobs(2,r)=Vobs(2,r)+sin(ObsAngle+pi);
                        break
                    else
                        Vobs(1,r)=Vobs(1,r)+cos(ObsAngle+PlaneAngle-abs(Theta(r)-ObsAngle));
                        Vobs(2,r)=Vobs(2,r)+sin(ObsAngle+PlaneAngle-abs(Theta(r)-ObsAngle));
                        break
                    end
             end
          end 
     end   
     end
    
      SF=Vform+Vcol+Vobs;
      RbtCoos=RbtCoos+SF;
      
      % ������������� �������
      for R=1:RbtNbr                  
         axis ([-60 90 0 60])
         hold on
         plot(Obs(1,:),Obs(2,:),'.r')
         scatter(RbtCoos(1,R),RbtCoos(2,R),6,R*70,'filled')
         scatter(Form(1,R),Form(2,R),6,R*70)
      end
        pause(0.001)
    
    Vcol = zeros(2,RbtNbr);
    Vobs = zeros(2,RbtNbr); 
 end


