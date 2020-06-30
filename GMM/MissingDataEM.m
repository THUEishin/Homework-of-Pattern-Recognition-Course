%样本数据
x = [0.42 -0.087 0.58;...
    -0.2 -3.3 -3.4;...
    1.3 -0.32 1.7;...
    0.39 0.71 0.23;...
    -1.6 -5.3 -0.15;...
    -0.029 0.89 -4.7;...
    -0.23 1.9 2.2;...
    0.27 -0.3 -0.87;...
    -1.9 0.76 -2.1;...
    0.87 -1.0 -2.6];

%参数初值
mu = zeros(1,3);
sig = diag([1 1 1]);

%给出mu的前两个分量
mu(1) = sum(x(:,1))/10;
mu(2) = sum(x(:,2))/10;
t =0;
while(1)
    %记录一下上一步的参数值
    mu_old = mu;
    sig_old = sig;
    t = t+1;
    %更新mu(3)
    temp_mu = sum(x(1:2:9,3));
    %计算E[t]
    for i = 1:5
        Et = mu(3) + sig(3,1:2)*(sig(1:2,1:2)\((x(2*i,1:2)-mu(1:2))'));
        temp_mu = temp_mu + Et;
    end
    mu(3) = temp_mu/10;
    
    %更新sig
    temp_sig = zeros(3,3);
    %奇数项
    for i =1:5
        temp_sig = temp_sig + (x(2*i-1,:)-mu)'*(x(2*i-1,:)-mu);
    end
    %偶数项
    for i=1:5
        %分块sig = [sig11 sig12;sig21 sig22]
        temp_sig_11 = (x(2*i,1:2)-mu(1:2))'*(x(2*i,1:2)-mu(1:2));
        %EtR = Et - mu(3)
        EtR = sig(3,1:2)*(sig(1:2,1:2)\((x(2*i,1:2)-mu(1:2))'));
        temp_sig_21 = EtR * (x(2*i,1:2)-mu(1:2));
        temp_sig_22 = EtR*EtR + sig(3,3) - sig(3,1:2)*(sig(1:2,1:2)\sig(1:2,3));
        temp_sig(1:2,1:2) = temp_sig(1:2,1:2) + temp_sig_11;
        temp_sig(3,1:2) = temp_sig(3,1:2) + temp_sig_21;
        temp_sig(1:2,3) = temp_sig(1:2,3) + temp_sig_21';
        temp_sig(3,3) = temp_sig(3,3) + temp_sig_22;
    end
    sig = temp_sig/10;
    err = 0;
    err = max(err,max(abs(mu_old-mu)));
    err = max(err,max(max(abs(sig_old-sig))));
    if(err < 1e-3)
        break;
    end
end

mu_exact = sum(x,1)/10;
sig_exact = zeros(3,3);
for i =1:10
    sig_exact = sig_exact + (x(i,:)-mu_exact)'*(x(i,:)-mu_exact);
end
sig_exact = sig_exact/10;