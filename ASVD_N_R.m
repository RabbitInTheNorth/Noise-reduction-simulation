function [JG,SVDN,num]=ASVD_N_R(XX)
%OUTPUT
% JG:   The signal after denoised by ASVD;
% SVDN: Singular values processed by differencing and normalization
% num:  THe effective sigular values mumbers

%INPUT: 
% XX    Signal vector




y=XX;
N=length(y);

%% Construct a Hankel matrix A
for i=1:N/2+1                 
t=i:i+N/2-1;
for j=1:N/2
A(j,i)=y(t(j));                 
end
end

%% Perform SVD to H and process the singular values by differencing and normalization.
[U,S,V] = svd(A);                         
qy=sum((S),1);                 
an=abs(diff(qy));               
Qmax=max(an);
GYan=an/Qmax;                   

ACC=0.1;                        %Set the hyperparameter ACC=0.1,
nu=1;   

for i=1:N/4-1
    QYM(1)=GYan(2*i);
    QYM(2)=GYan(2*(i+1));
     if QYM(1)>ACC & QYM(2)<ACC
      n(nu)=i*2; 
      nu=nu+1;
     
     end
end

%% Reconstruct the signal
X=zeros(size(A));
for i=1:n(nu-1); 
X=X+U(:,i)*S(i,i)*V(:,i)';
end
JG=zeros(1,N);
for i=1:N
a=0;m=0;
for j1=1:N/2
for j2=1:N/2+1
if i+1==j1+j2
a=a+X(j1,j2); 
m=m+1;
end
end
end
JG(i)=a/m;
end

SVDN=GYan;
num=n(nu-1);
%% drawing
plot(y)
hold on
plot(JG)
legend("Original signal","ASVD")
end