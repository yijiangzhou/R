%% Numerical solution of the problem
function [vrevised,dr,exit] = solve_vfi(price,z,Z,n,N,theta,beta,cf,p)

%Value function iteration
d=1;
toler=1e-08;


% Store policy function
dr  =zeros(1,Z);    %record for policy function
exit=zeros(1,Z);    %record for exit decision

% Guess value functions
vinitial=zeros(1,Z);
vrevised=zeros(1,Z);

% Fixed cost matrix
cost=cf*ones(N,1)';


while d>toler
    
    for i=1:Z
        fi = z(i)*n.^theta.*price - n - cost; % YJ: profit function when z = z_i
        % YJ: ����ÿһ��productivity z_i, ��251��employment nodes in vector n
        % YJ: ��ҵҪѡ���������value function��employment, �����policy function�ĺ���
        [vrevised(i),dr(i)]=max(fi+beta*max(p(i,:)*vinitial',0)*ones(N,1)');
        % YJ: dr(i)��optimal employment node��n�е�λ�� (index)
        % YJ: ���߶�trans probability�±�ı�ŷ�ʽ��Edmond slideһ��, p_ij��ʾ
        % z = z_i at t and z = z_j at t+1
        exit(i)=1-1*(p(i,:)*vinitial'<0); % YJ: 1*(...) ���������߼��ж�
        % YJ: exit(i) = 0 if firm exits at productivity z_i and = 1 if firm
        % continues to produce at z_i
    end
    d=norm(vrevised-vinitial)/norm(vrevised);
    vinitial=vrevised;
end



end