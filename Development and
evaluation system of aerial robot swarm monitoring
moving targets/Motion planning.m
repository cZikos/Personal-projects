clear all
close all
clc


% Set number of agents,targets, time steps and accuracy level
   gridSize=60;         % space discretization
   nr=2;                 % Number of agents
   nt=3;                 % Number of targets
   Tmax=200;             % Running time of experiment

%Initial Positions for Robots            -0.934 -0.732 -0.330; -0.934 -0.732 -0.330
xr=[-0.934 -0.732 -0.330; 0.8 -0.8 -0.8];


%Setting default values  values
Sigma = eye(3,3);
x = -1:(2/gridSize):1; 
y = -1:(2/gridSize):1; 
z = -1:(2/gridSize):1;
[X,Y,Z] = meshgrid(x,y,z);
Fr = zeros(gridSize+1,gridSize+1,gridSize+1,nr);
Ft = zeros(gridSize+1,gridSize+1,gridSize+1,nt);
Cf = zeros(gridSize+1,gridSize+1,gridSize+1,nr);
v = zeros(gridSize+1,gridSize+1,gridSize+1,nr);
U = zeros(gridSize+1,gridSize+1,gridSize+1,nr);
TTable = zeros(nr+nt,3,Tmax);
figLIVE=figure;
history=5;
Ef1 = zeros(Tmax,nr+1);
Ef = zeros(Tmax);
u = zeros(gridSize+1,gridSize+1,gridSize+1,Tmax);
Eftemp=zeros(1,nt);
Efpr=zeros(nr,2,Tmax);
Efpt=zeros(nt,2,Tmax);
Ef2tmp=zeros(nr,nt);
Ef3tmp=zeros(nt,nr);
zTarget = linspace(0,1,Tmax);
zTarget=(2*zTarget- max(max(zTarget)))/(max(max(zTarget)));
xTarget = (cos(2*zTarget.^3)+cos(zTarget/30)+2*sin(4*zTarget))/4;
yTarget = (sin(9*zTarget)+sin(zTarget.^4))/2;
cloind = ones(1,nt);
clos   = ones(1,nt);


for time=1:Tmax
 D_r=zeros(gridSize+1,gridSize+1,gridSize+1);
 D_t=zeros(gridSize+1,gridSize+1,gridSize+1);
 time;
 
 %Movement of targets 
 xt(1,:) = [sin(pi*time/Tmax) -yTarget(time) -zTarget(time)];
 xt(2,:) = [sin(pi*time/Tmax) -yTarget(time) sin(2*pi*time/Tmax)];
 xt(3,:) = [xTarget(time) yTarget(time) -zTarget(time)];

 %Move robot's estimated positions to specified-by-grindsize positions
 for Rbt=1:nr
    
     tmpx = double(abs(x-xr(Rbt,1)));
     [Minx, indx] = min(tmpx);
     xr(Rbt,1)=x(indx);
     
     tmpy = double(abs(y-xr(Rbt,2)));
     [Miny, indy] = min(tmpy);
     xr(Rbt,2)=y(indy);
      
     tmpz = double(abs(z-xr(Rbt,3)));
     [Minz, indz] = min(tmpz);
     xr(Rbt,3)=z(indz);
    
 end  
  
 %Set target's estimated positions to specified-by-grindsize positions
 for Trgt=1:nt
    
     tmpx = double(abs(x-xt(Trgt,1)));
     [Minx, indx] = min(tmpx);
     xt(Trgt,1)= x(indx);
     
     tmpy = double(abs(y-xt(Trgt,2)));
     [Miny, indy] = min(tmpy);
     xt(Trgt,2)=y(indy);
     
     tmpz = double(abs(z-xt(Trgt,3)));
     [Minz, indz] = min(tmpz);
     xt(Trgt,3)= z(indz);
     
 end
 
 %Record position of robots and targets per time unit
 TTable(1:nr,:,time) = xr(1:nr,:);
 TTable(nr+1:nr+nt,:,time) = xt(1:nt,:);
 
 %Density of robots and targets
 for R=1:nr
 a(1:nt,R)=abs(xr(R,1)-xt(1:nt,1)).^2+abs(xr(R,2)-xt(1:nt,2)).^2+abs(xr(R,3)-xt(1:nt,3)); 
 Ftemp = mvnpdf([X(:) Y(:) Z(:)],xr(R,:),Sigma);
 Fr(:,:,:,R)=reshape(Ftemp,length(x),length(y),length(z));
 D_r = D_r+Fr(:,:,:,R);
end
   
 for t=1:nt
 [clos(t),cloind(t)]=min(a(t,:));
 Ftemp = mvnpdf([X(:) Y(:) Z(:)],xt(t,:),Sigma);
 Ft(:,:,:,t)=reshape(Ftemp,length(x),length(y),length(z));
 D_t = D_t+Ft(:,:,:,t);
 end   
 
 
 %Urgency of need of robots in space
 u(:,:,:,time)=D_t./D_r; 
 
 for R=1:nr
 
 %Cost of traveling to each point in space per robot(distance^2)
 dist=(abs(xr(R,1)-X).^2+abs(xr(R,2)-Y).^2+abs(xr(R,3)-Z).^2);
 dist(dist>80/gridSize)=400/gridSize;
 dist(dist<60/gridSize)=200/gridSize;
 Cf(:,:,:,R)=ones(gridSize+1,gridSize+1,gridSize+1)+dist.^2;%
 
 %The final Urgency 3d table per robot
 U(:,:,:,R)=u(:,:,:,time)./Cf(:,:,:,R);
 
 %Finding the maximum U and its indexes  
 [max1,xIndMat]=max(U(:,:,:,R));
 maxtemp=reshape(max1,gridSize+1,gridSize+1); 
 max2=max(max1);
 maxU=max(max2);
 [yInd,zInd] = find(maxtemp==maxU);
 xInd=xIndMat(1,yInd,zInd);
 
 %Movement
 v=[sign(X(xInd,yInd,zInd)-xr(R,1))*2/gridSize sign(Y(xInd,yInd,zInd)-xr(R,2))*2/gridSize sign(Z(xInd,yInd,zInd)-xr(R,3))*2/gridSize];
 xr(R,:)=xr(R,:)+[v(1,1) v(1,2) v(1,3)];
 end
 
% Virtualization

figure(1)
clf(figLIVE)
title('Target and Agent Positions');
hold on
axis ([-1 1 -1 1 -1 1]);
grid on;
xlabel('X');
ylabel('Y');
zlabel('Z');
view([112 37]);

     
    if time>history
           for rp=1:nr
                plot3(squeeze(TTable(rp,1,time-history:time)),squeeze(TTable(rp,2,time-history:time)),squeeze(TTable(rp,3,time-history:time)),'.b','Markersize',8)
                plot3(squeeze(TTable(rp,1,time)),squeeze(TTable(rp,2,time)),squeeze(TTable(rp,3,time)),'og','Markersize',5)
           end
           for rp=1:nt
                plot3(squeeze(TTable(nr+rp,1,time-history:time)),squeeze(TTable(nr+rp,2,time-history:time)),squeeze(TTable(nr+rp,3,time-history:time)),'.r','Markersize',8)
                plot3(squeeze(TTable(nr+rp,1,time)),squeeze(TTable(nr+rp,2,time)),squeeze(TTable(nr+rp,3,time)),'og','Markersize',5)
           end
    else
          for rp=1:nr
                plot3(squeeze(TTable(rp,1,1:time)),squeeze(TTable(rp,2,1:time)),squeeze(TTable(rp,3,1:time)),'.b','Markersize',8)
                plot3(squeeze(TTable(rp,1,time)),squeeze(TTable(rp,2,time)),squeeze(TTable(rp,3,time)),'og','Markersize',5)
          end
           for rp=1:nt
               plot3(squeeze(TTable(nr+rp,1,1:time)),squeeze(TTable(nr+rp,2,1:time)),squeeze(TTable(nr+rp,3,1:time)),'.r','Markersize',8) 
               plot3(squeeze(TTable(nr+rp,1,time)),squeeze(TTable(nr+rp,2,time)),squeeze(TTable(nr+rp,3,time)),'og','Markersize',5)
           end
    end
    
  

pause(0.01)

end



