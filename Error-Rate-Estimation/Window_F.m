function [ result ] = Window_F( h, center, position, W_Flag )
%WINDOW_F �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%   ����
%       h: ����
%       center: �������ĵ�
%       position: ������λ��
%       W_Flag: ������ѡ��
%   ���
%       result: ����㴰������ֵ
if(max(abs(position-center)) > h/2.0)
    result = 0.0;
else
    %��������
    if(W_Flag == 1)
        result = 1.0/h/h;
    end
    
    %��̬������
    if(W_Flag == 2)
        sigma = diag([h/10.0, h/10.0]); %5sigmaԭ��
        result = mvnpdf(position, center, sigma);
    end
end

end

