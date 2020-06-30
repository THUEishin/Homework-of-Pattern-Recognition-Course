function [ mu, sig, alpha ] = EM( m, emdata )
%EM ʹ��EM�㷨���л�ϸ�˹ģ�͵����
%   ����
%       m: ����ϵ�GMM�ķֲ�����
%       emdata: ����ϵ�GMM�Ĳ�����
%       pin: ����ϵ�GMM���������
%   ���
%       mu: ��ϵõ���GMM�ľ�ֵ
%       sig: ��ϵõ���GMM�ķ���

    num = size(emdata,1);
    dim = size(emdata,2);
    
    alpha = ones(m,1)./m; %Ȩ��/�������
    mu = (1:1:m)'*[1 0]; %��ֵ
    sig = zeros(dim,dim,m); %Э�������
    p = ones(m,num)./m;%Bayes�������
    for i=1:m
        sig(:,:,i) = diag([m m]);
    end
    
    t = 0;%��������
while(1)
    %��¼һ����һ���Ľ��
    alpha_old = alpha;
    mu_old = mu;
    sig_old = sig;
    %���ȼ���Bayes�������,E-step
    for i = 1:num
        temp = 0; %��¼���
        for j = 1:m
            p(j,i) = alpha(j)*mvnpdf(emdata(i,:),mu(j,:),sig(:,:,j));
            temp = temp+p(j,i);
        end
        p(:,i) = p(:,i)./temp;
    end
    
    %M-step
    for j = 1:m
        alpha(j) = sum(p(j,:))/num;
        mu(j,:) = (p(j,:)*emdata)./(sum(p(j,:)));
        temp2 = emdata - ones(num,1)*mu(j,:);%x_i-mu
        sig(:,:,j) = (temp2'*diag(p(j,:))*temp2)./(sum(p(j,:)));
    end
    
    %����������˳����������
    t = t+1;
    err = 0;%��������С��1e-3ʱ�˳�ѭ��
    err = max(err,max(abs(alpha_old-alpha)));
    err = max(err,max(max(abs(mu_old-mu))));
    err = max(err,max(max(max(abs(sig_old-sig)))));
    if(err < 1e-3)
        break;
    end
end
end

