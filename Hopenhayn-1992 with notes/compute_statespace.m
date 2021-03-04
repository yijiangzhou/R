%% Grid for tech shock, z,
% by using Tauchen's method of finite state  Markov approximation
% YJ: �ο�Comp Econ����ʦ�Ŀμ�Dynamic Labor Supply
m=3;
w=2*m*sigma/(Z-1); % YJ: node֮��ľ���
lnz=(-m*sigma+a):w:(m*sigma+a); % YJ: -m*sigma+a���½�㣬m*sigma+a���Ͻ��
% YJ: ���⣬Ϊʲô��ʽ��a������mu_y (y's expectation)?
z=exp(lnz);

%Markov transition matrix
p=zeros(Z);

%See formula on notes
% YJ: �����Ǽ��㲢����transition matrix�ĸ���Ԫ��
% YJ: Ҳ�ο�����ʦ�Ŀμ�Dynamic Labor Supply��������ľ���ʽ����С���죩
p(:,1)=normcdf(((lnz(1)+w/2)*ones(Z,1)-ro*lnz')/stde,0,1);
p(:,Z)=ones(Z,1)-normcdf(((lnz(Z)-w/2)*ones(Z,1)-ro*lnz')/stde,0,1);
for j=2:(Z-1)
    p(:,j)=normcdf(((lnz(j)+w/2)*ones(Z,1)-ro*lnz')/stde,0,1)-...
        normcdf(((lnz(j)-w/2)*ones(Z,1)-ro*lnz')/stde,0,1);
end

% Initial distribution (assumed to be uniform)
% YJ: �����Edmond slide���g_i, the initial dist. of productivity
% YJ: ���⣬����uniform distribution���������ֶ���һ������...
inidis=ones(1,Z)./Z;


%% Grid points of n
% with the largest to be 5000
nmax=5000;
n=0:nmax/(N-1):nmax; % YJ: ����employment nodes