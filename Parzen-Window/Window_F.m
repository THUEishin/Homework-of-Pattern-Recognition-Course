function [ result ] = Window_F( h, center, position, W_Flag )
%WINDOW_F 用于计算窗函数
%   输入
%       h: 窗宽
%       center: 窗的中心点
%       position: 待求点的位置
%       W_Flag: 窗函数选择
%   输出
%       result: 待求点窗函数的值

if(abs(position-center) > h/2.0)
    result = 0.0;
else
    %方窗函数
    if(W_Flag == 1)
        result = 1.0/h;
    end

    %正态窗函数
    if(W_Flag == 2)
        sigma = h/10.0; %5sigma原则
        result = (1.0/(sqrt(2*pi)*sigma))*exp(-(position-center)*(position-center)/2/sigma/sigma);
    end
    
    %三角窗函数
    if(W_Flag == 3)
        c1 = -4.0/h/h;
        c0 = 2.0/h;
        result = c0 + c1*abs(position-center);
    end
    
    %二次窗函数
    if(W_Flag == 4)
        c0 = 1.5/h;
        c2 = -6.0/h/h/h;
        result = c0 + c2*(position-center)*(position-center);
    end
end
end

