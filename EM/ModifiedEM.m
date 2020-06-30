%���ݳ�ʼ��
emdata = data2;
num = size(emdata,1); %�����ĸ���
m = 5; %m����˹��Ϸֲ�
dim = 2;%����ϸ�˹�ֲ���ά��

alpha = ones(m,1)./m; %Ȩ��/�������
mu = (1:1:m)'*[1 1]; %��ֵ
sig = diag([1 1]); %Э�������
p = ones(m,num)./m;%Bayes�������

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
            p(j,i) = alpha(j)*mvnpdf(emdata(i,:),mu(j,:),sig(:,:));
            temp = temp+p(j,i);
        end
        p(:,i) = p(:,i)./temp;
    end
    
    %M-step
    temp3 = zeros(dim,dim,m);
    for j = 1:m
        alpha(j) = sum(p(j,:))/num;
        mu(j,:) = (p(j,:)*emdata)./(sum(p(j,:)));
        temp2 = emdata - ones(num,1)*mu(j,:);%x_i-mu
        temp3(:,:,j) = (temp2'*diag(p(j,:))*temp2);
    end
    sig = sum(temp3,3);
    sig = sig./(sum(sum(p)));
    %����������˳����������
    t = t+1;
    err = 0;%��������С��1e-3ʱ�˳�ѭ��
    err = max(err,max(abs(alpha_old-alpha)));
    err = max(err,max(max(abs(mu_old-mu))));
    err = max(err,max(max(abs(sig_old-sig))));
    if(err < 1e-3)
        break;
    end
end

%��ͼ

[X1,X2] = meshgrid((-10:0.1:10)', (-10:0.1:10)');
X = [X1(:) X2(:)];
pp = zeros(size(X,1),1);
for j = 1:m
    pp = pp + alpha(j)*mvnpdf(X,mu(j,:),sig(:,:));
end
surf(X1,X2,reshape(pp,201,201));
xlabel('x_1');
ylabel('x_2');
zlabel('p')
colorbar;
title('m=5')
shading interp;