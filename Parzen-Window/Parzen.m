function [ err ] = Parzen( Num, h, dis, W_Flag, P_flag, m, n, p )
%PARZEN 该函数用于Parzen窗算法的实现
%   p(x)服从0.2N(-1,1)+0.8N(1,1)，基于3sigma原则，我们作图和计算误差都在区间
%   [-4, 4]内进行。
%   输入
%       Num:采样点的个数（必须为5的倍数）
%       h: 窗宽
%       dis: 积分点的间距，-4:dis:4
%       W_Flag:窗函数选择标签: 1-方框窗函数;2-正态窗函数;3-三角窗函数;4-二次窗函数
%       P_Flag:作图的标签: 1-作图; 0-不作图
%       m, n, p: 作图subplot(m,n,p)的控制参数
%   输出
%       error: 误差的二范数

%首先生成服从0.2N(-1,1)+0.8N(1,1)的随机数列
    if(mod(Num,5) ~= 0)
        error('采样点的个数必须是5的倍数');
    end
    %N(-1,1)的采样点个数
    Num1=Num/5;
    %N(1,1)的采样点个数
    Num2=Num*4/5;
    %初始化随机数列
    Sample=zeros(Num,1);
    %N(-1,1)的采样点
    Sample(1:Num1,1) = -1 + randn([Num1,1]);
    %N(1,1)的采样点
    Sample((Num1+1):Num,1) = 1 + randn([Num2,1]);
    
%积分点的初始化
    Integral_Point = (-4:dis:4)';
    Integral_Num = size(Integral_Point,1);
    %每个积分点上的概率值p_Point初始化
    p_Point = zeros(Integral_Num,1);
    p_exact_Point = 0.2*normpdf(Integral_Point,-1,1) + 0.8*normpdf(Integral_Point,1,1);
    
%对采样点循环，计算对积分点的窗函数并求和
    for i = 1:Num
        s_position = Sample(i);
        for j = 1:Integral_Num
            p_Point(j) = p_Point(j) + Window_F(h,Integral_Point(j),s_position,W_Flag);
        end
    end
    p_Point = p_Point/Num;
    
%对积分点循环求误差
    %每个积分点代表的宽度
    len = 8.0/Integral_Num;
    p_error = p_Point - p_exact_Point;
    err = (p_error'*p_error)*len;
    
%作图
    if(P_flag == 1)
        subplot(m,n,p);
        plot(Integral_Point, p_exact_Point,'LineWidth',2);
        hold on;
        plot(Integral_Point, p_Point, 'r','LineWidth',2);
        xlabel('x');
        ylabel('p(x)');
        title(['n=',num2str(Num),', a=',num2str(h)])
        if(W_Flag == 1)
            legend('精确','方窗');
        end
        if(W_Flag == 2)
            legend('精确','正态窗');
        end
        if(W_Flag == 3)
            legend('精确','三角窗');
        end
        if(W_Flag == 4)
            legend('精确','二次窗');
        end
    end
end

