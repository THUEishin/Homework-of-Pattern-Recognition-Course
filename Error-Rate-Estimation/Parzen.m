function [ Berr, err ] = Parzen( Num, h, dis, W_Flag, P_flag, m, n, p )
%PARZEN 该函数用于Parzen窗算法的实现
%   基于3sigma原则，我们作图和计算误差都在区间[-6, 6]*[-6, 6]内进行。
%   输入
%       Num:采样点的个数（必须为2的倍数）
%       h: 窗宽(两个维度上窗宽相同)
%       dis: 积分点的间距，-6:dis:6
%       W_Flag:窗函数选择标签: 1-方窗函数;2-正态窗函数;
%       P_Flag:作图的标签: 1-作图; 0-不作图
%       m, n, p: 作图subplot(m,n,p)的控制参数
%   输出
%       Berr: Bayes分类器的总误差
%       err: 误差的二范数
numfig = 2*(W_Flag-1);
%概率密度分布1
    mu1 = [-1, 0];
    sig1 = diag([1, 1]);
    P1 = 0.5;
    gm1 = gmdistribution(mu1, sig1);
%概率密度分布2
    mu2 = [1, 0];
    sig2 = diag([2, 1]);
    P2 = 0.5;
    gm2 = gmdistribution(mu2, sig2);
    
%首先生成服从0.2N(-1,1)+0.8N(1,1)的随机数列
    if(mod(Num,2) ~= 0)
        error('采样点的个数必须是2的倍数');
    end
    if((n-1) ~= size(h,2))
        error('作图列数与窗宽数组的列数不一致');
    end
    %概率密度分布1的采样点个数
    Num1 = Num/2;
    %概率密度分布2的采样点个数
    Num2 = Num/2;
    %初始化随机数列
    Sample = zeros(Num, 2);
    test_Sample = zeros(100, 2);
    %概率密度分布1的采样点
    Sample(1:Num1,:) = random(gm1,Num1);
    test_Sample(1:50,:) = random(gm1,50);
    %概率密度分布1的采样点
    Sample((Num1+1):Num,:) = random(gm2,Num2);
    test_Sample(51:100,:) = random(gm2,50);
    
    %对上述随机分布作图
    if(P_flag == 1)
        figure(numfig+1);
        subplot(m,n,(p-1)*n+1);
        scatter(Sample(:,1),Sample(:,2));
        xlabel('X_1');
        ylabel('X_2');
        title('采样点分布');
        axis([-6,6,-6,6])
        axis equal;
        figure(numfig+2);
        subplot(m,n,(p-1)*n+1);
        scatter(Sample(:,1),Sample(:,2));
        xlabel('X_1');
        ylabel('X_2');
        title('采样点分布');
        axis([-6,6,-6,6])
        axis equal;
    end
    
%积分点的初始化
    [X1,X2] = meshgrid((-6:dis:6)', (-6:dis:6)');
    Integral_Point = [X1(:) X2(:)];
    Integral_Num = size(Integral_Point,1);
    p_exact_Point = 0.5*mvnpdf(Integral_Point,mu1,sig1) + 0.5*mvnpdf(Integral_Point,mu2,sig2);
    err = zeros(1,n-1);
    Berr = zeros(1,n-1);
for k = 1:(n-1)    
    p_Point_1 = zeros(Integral_Num,1);
    p_Point_2 = zeros(Integral_Num,1);
    p_Sample_1 = zeros(100,1);
    p_Sample_2 = zeros(100,1);
    hk = h(k);
%对采样点循环，计算对积分点的窗函数并求和
    %估计概率密度函数1
    for i = 1:Num1
        s_position = Sample(i,:);
        for j = 1:Integral_Num
            p_Point_1(j) = p_Point_1(j) + Window_F(hk,Integral_Point(j,:),s_position,W_Flag);
        end
        for j = 1:100
            p_Sample_1(j) = p_Sample_1(j) + Window_F(hk,test_Sample(j,:),s_position,W_Flag);
        end
    end
    p_Point_1 = p_Point_1/Num1;
    p_Sample_1 = p_Sample_1/Num1;
    %估计概率密度函数2
    for i = 1:Num2
        s_position = Sample(Num1+i,:);
        for j = 1:Integral_Num
            p_Point_2(j) = p_Point_2(j) + Window_F(hk,Integral_Point(j,:),s_position,W_Flag);
        end
        for j = 1:100
            p_Sample_2(j) = p_Sample_2(j) + Window_F(hk,test_Sample(j,:),s_position,W_Flag);
        end
    end
    p_Point_2 = p_Point_2/Num2;
    p_Sample_2 = p_Sample_2/Num2;
    
%对积分点循环求误差
    %每个积分点代表的体积
    vol = dis*dis;
    %混合高斯分布的拟合误差
    p_error = 0.5*p_Point_1 + 0.5*p_Point_2 - p_exact_Point;
    err(k) = sqrt(p_error'*p_error*vol);
    %Bayes估计误差
    Pe1 = 0;
    Pe2 = 0;
    for i = 1:50
        if(p_Sample_1(i) <= p_Sample_2(i))
            Pe1 = Pe1 + 1;
        end
    end
    Pe1 = Pe1/50;
    for i = 51:100
        if(p_Sample_1(i) >= p_Sample_2(i))
            Pe2 = Pe2 + 1;
        end
    end
    Pe2 = Pe2/50;
    Berr(k) = P1*Pe1 + P2*Pe2;
    %作图
    if(P_flag == 1)
        %拟合结果图
        figure(numfig+1);
        subplot(m,n,(p-1)*n+k+1)
        surf(X1,X2,reshape(0.5*p_Point_1 + 0.5*p_Point_2,size(X1,1),size(X1,1)));
        xlabel('X_1');
        ylabel('X_2');
        zlabel('p')
        axis([-6,6,-6,6,0,1])
        axis equal;
        caxis([0,0.1]);
        hc0 = colorbar ;
        set(hc0,'YTick',0:0.02:0.1)
        shading interp;
        view(0,90)
        %误差图
        figure(numfig+2);
        subplot(m,n,(p-1)*n+k+1)
        surf(X1,X2,reshape(p_error,size(X1,1),size(X1,1)));
        xlabel('X_1');
        ylabel('X_2');
        zlabel('error')
        axis([-6,6,-6,6,0,1])
        axis equal;
        caxis([-0.1,0.1]);
        hc1 = colorbar ;
        set(hc1,'YTick',-0.1:0.05:0.1)
        shading interp;
        view(0,90)
    end
end
end

