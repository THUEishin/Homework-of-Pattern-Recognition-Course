%数据初始化
emdata = data2;
num = size(emdata,1); %样本的个数
m = 5; %m个高斯混合分布
dim = 2;%待拟合高斯分布的维数

alpha = ones(m,1)./m; %权重/先验概率
mu = (1:1:m)'*[1 1]; %均值
sig = diag([1 1]); %协方差矩阵
p = ones(m,num)./m;%Bayes后验概率

t = 0;%迭代步数
while(1)
    %记录一下上一步的结果
    alpha_old = alpha;
    mu_old = mu;
    sig_old = sig;
    %首先计算Bayes后验概率,E-step
    for i = 1:num
        temp = 0; %记录求和
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
    %如果收敛则退出，否则继续
    t = t+1;
    err = 0;%无穷范数误差小于1e-3时退出循环
    err = max(err,max(abs(alpha_old-alpha)));
    err = max(err,max(max(abs(mu_old-mu))));
    err = max(err,max(max(abs(sig_old-sig))));
    if(err < 1e-3)
        break;
    end
end

%作图

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