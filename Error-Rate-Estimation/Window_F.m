function [ result ] = Window_F( h, center, position, W_Flag )
%WINDOW_F 此处显示有关此函数的摘要
%   此处显示详细说明
%   输入
%       h: 窗宽
%       center: 窗的中心点
%       position: 待求点的位置
%       W_Flag: 窗函数选择
%   输出
%       result: 待求点窗函数的值
if(max(abs(position-center)) > h/2.0)
    result = 0.0;
else
    %方窗函数
    if(W_Flag == 1)
        result = 1.0/h/h;
    end
    
    %正态窗函数
    if(W_Flag == 2)
        sigma = diag([h/10.0, h/10.0]); %5sigma原则
        result = mvnpdf(position, center, sigma);
    end
end

end

