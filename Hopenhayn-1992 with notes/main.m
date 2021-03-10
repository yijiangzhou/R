%      Hopenhayn (1992) Firm Dynamics Market Model - VFI                  %
%          Program written by: Alessandro Ruggieri - UAB and BGSE         %
%                          Version 11/02/2016                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
close all
fprintf('\nSolve Firm Dynamics Model as in Hopenhayn (1992)\n');

 
%% Parameters
compute_parameters;

%% State Space
compute_statespace;

%% Iterate over price of goods
d=1;
% Boundaries for price
pmin=0.01; 
pmax=100;

while d>toler

    % Guess prices    
    price=(pmin+pmax)/2;

    % Solve firm value function iteration
    % YJ: ������price, ʹ��VFI���v^*(price)
    [vinitial,dr,exit] = solve_vfi(price,z,Z,n,N,theta,beta,cf,p);

    %Compute the decision rule for labor
    decrule=zeros(1,Z);
    for i=1:Z
        decrule(i)=n(dr(i));
    end
    % YJ: decrule(i) is optimal employment when z = z_i

    %Define expected value of entrant
    value=inidis*vinitial';

    % Update price till EV=ce
    if value<ce
     pmin=price;
    else
     pmax=price;
    end

    % Check convergence
    d=abs(value-ce)/ce;
end


%Given the value function and policy function, iterate on the industry structure
%until it converges
d=1; 
muinitial=inidis;
while d>toler
    muexit=muinitial.*exit;                 %exit decision
    % YJ: exit decision is associated with equilibrium price calculated above
    mustay=muexit*p;                        %update for the incumbents stay
    muentry=mustay+inidis;                   %entry YJ: �˴���entry mass M = 1
    murevised=muentry./sum(muentry); % YJ: ����һ�������muentry����ҵ�ġ���������
    % YJ: ���ԡ��������ܺ͵õ����ʣ�������������ġ��ֲ����Ƿ���mu^*����
    d=norm(murevised-muinitial)/norm(murevised);
    muinitial=murevised;
end

% % YJ code begins
% while d>toler
%     muexit=muinitial.*exit;                 %exit decision
%     mustay=muexit*p;                        %update for the incumbents stay
%     muentry=mustay+inidis;                   %entry YJ: �˴���entry mass M = 1
%     murevised=muentry;
%     d=norm(murevised-muinitial)/norm(murevised);
%     muinitial=murevised;
% end
% % YJ code ends

% YJ code begins
Psi = zeros(Z,Z);
ptr = p';
for i = 1:Z
    Psi(:,i) = ptr(:,i) .* exit(i);
end
muedmond = (inv(eye(Z) - Psi) * inidis')';
muedmond_sc = muedmond ./ sum(muedmond);
% YJ code ends

%% Calculating the entry mass M 
% Using equilibrium condition in goods market
y=D-price;  
Xstar=z(Z-sum(exit));
% YJ: Xstar��exit threshold (cutoff productivity)
% YJ: ע��z�е�productivity�Ǵ�С�������еģ������������ܴ�������z(Z-sum(exit))����ʾ
% ����continue����Сproductivity
Pstar=price;
Size = (decrule)*murevised'; 
Y=(decrule.^theta.*z)*murevised';
Mstar=y/[Y+(decrule.^theta.*z)*inidis'];
Exrate=sum(murevised(1:Z-sum(exit)))*100;

% YJ code begins
Size_yj = (decrule)*muedmond_sc'; 
Y_yj=(decrule.^theta.*z)*muedmond';
Mstar_yj=y/(Y_yj+(decrule.^theta.*z)*inidis');
Exrate_yj=sum(muedmond_sc(1:Z-sum(exit)))*100;
% YJ code ends

disp('Results ');
disp('');
disp('    Price     Firms    Avg.size       ');
disp([ Pstar  Mstar    Size   ]);
% YJ code begins
disp('    Price     Firms_yj    Avg.size_yj       ');
disp([ Pstar  Mstar_yj    Size_yj   ]);
% YJ code ends

% save baseline.mat
 