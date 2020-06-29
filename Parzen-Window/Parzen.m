function [ err ] = Parzen( Num, h, dis, W_Flag, P_flag, m, n, p )
%PARZEN �ú�������Parzen���㷨��ʵ��
%   p(x)����0.2N(-1,1)+0.8N(1,1)������3sigmaԭ��������ͼ�ͼ�����������
%   [-4, 4]�ڽ��С�
%   ����
%       Num:������ĸ���������Ϊ5�ı�����
%       h: ����
%       dis: ���ֵ�ļ�࣬-4:dis:4
%       W_Flag:������ѡ���ǩ: 1-���򴰺���;2-��̬������;3-���Ǵ�����;4-���δ�����
%       P_Flag:��ͼ�ı�ǩ: 1-��ͼ; 0-����ͼ
%       m, n, p: ��ͼsubplot(m,n,p)�Ŀ��Ʋ���
%   ���
%       error: ���Ķ�����

%�������ɷ���0.2N(-1,1)+0.8N(1,1)���������
    if(mod(Num,5) ~= 0)
        error('������ĸ���������5�ı���');
    end
    %N(-1,1)�Ĳ��������
    Num1=Num/5;
    %N(1,1)�Ĳ��������
    Num2=Num*4/5;
    %��ʼ���������
    Sample=zeros(Num,1);
    %N(-1,1)�Ĳ�����
    Sample(1:Num1,1) = -1 + randn([Num1,1]);
    %N(1,1)�Ĳ�����
    Sample((Num1+1):Num,1) = 1 + randn([Num2,1]);
    
%���ֵ�ĳ�ʼ��
    Integral_Point = (-4:dis:4)';
    Integral_Num = size(Integral_Point,1);
    %ÿ�����ֵ��ϵĸ���ֵp_Point��ʼ��
    p_Point = zeros(Integral_Num,1);
    p_exact_Point = 0.2*normpdf(Integral_Point,-1,1) + 0.8*normpdf(Integral_Point,1,1);
    
%�Բ�����ѭ��������Ի��ֵ�Ĵ����������
    for i = 1:Num
        s_position = Sample(i);
        for j = 1:Integral_Num
            p_Point(j) = p_Point(j) + Window_F(h,Integral_Point(j),s_position,W_Flag);
        end
    end
    p_Point = p_Point/Num;
    
%�Ի��ֵ�ѭ�������
    %ÿ�����ֵ����Ŀ��
    len = 8.0/Integral_Num;
    p_error = p_Point - p_exact_Point;
    err = (p_error'*p_error)*len;
    
%��ͼ
    if(P_flag == 1)
        subplot(m,n,p);
        plot(Integral_Point, p_exact_Point,'LineWidth',2);
        hold on;
        plot(Integral_Point, p_Point, 'r','LineWidth',2);
        xlabel('x');
        ylabel('p(x)');
        title(['n=',num2str(Num),', a=',num2str(h)])
        if(W_Flag == 1)
            legend('��ȷ','����');
        end
        if(W_Flag == 2)
            legend('��ȷ','��̬��');
        end
        if(W_Flag == 3)
            legend('��ȷ','���Ǵ�');
        end
        if(W_Flag == 4)
            legend('��ȷ','���δ�');
        end
    end
end

