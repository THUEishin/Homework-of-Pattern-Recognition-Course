function [ mu, sig, alpha ] = EM( m, emdata )
%EM 使用EM算法进行混合高斯模型的拟合
%   输入
%       m: 代拟合的GMM的分布个数
%       emdata: 代拟合的GMM的采样点
%       pin: 代拟合的GMM的先验概率
%   输出
%       mu: 拟合得到的GMM的均值
%       sig: 拟合得到的GMM的方差

    num = size(emdata,1);
    dim = size(emdata,2);
    
    alpha = ones(m,1)./m; %权重/先验概率
    mu = (1:1:m)'*[1 0]; %均值
    sig = zeros(dim,dim,m); %协方差矩阵
    p = ones(m,num)./m;%Bayes后验概率
    for i=1:m
        sig(:,:,i) = diag([m m]);
    end
    
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
    
    %如果收敛则退出，否则继续
    t = t+1;
    err = 0;%无穷范数误差小于1e-3时退出循环
    err = max(err,max(abs(alpha_old-alpha)));
    err = max(err,max(max(abs(mu_old-mu))));
    err = max(err,max(max(max(abs(sig_old-sig)))));
    if(err < 1e-3)
        break;
    end
end
end

