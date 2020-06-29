function [ result ] = Window_F( h, center, position, W_Flag )
%WINDOW_F ���ڼ��㴰����
%   ����
%       h: ����
%       center: �������ĵ�
%       position: ������λ��
%       W_Flag: ������ѡ��
%   ���
%       result: ����㴰������ֵ

if(abs(position-center) > h/2.0)
    result = 0.0;
else
    %��������
    if(W_Flag == 1)
        result = 1.0/h;
    end

    %��̬������
    if(W_Flag == 2)
        sigma = h/10.0; %5sigmaԭ��
        result = (1.0/(sqrt(2*pi)*sigma))*exp(-(position-center)*(position-center)/2/sigma/sigma);
    end
    
    %���Ǵ�����
    if(W_Flag == 3)
        c1 = -4.0/h/h;
        c0 = 2.0/h;
        result = c0 + c1*abs(position-center);
    end
    
    %���δ�����
    if(W_Flag == 4)
        c0 = 1.5/h;
        c2 = -6.0/h/h/h;
        result = c0 + c2*(position-center)*(position-center);
    end
end
end

