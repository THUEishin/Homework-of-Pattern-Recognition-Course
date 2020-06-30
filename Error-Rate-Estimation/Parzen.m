function [ Berr, err ] = Parzen( Num, h, dis, W_Flag, P_flag, m, n, p )
%PARZEN �ú�������Parzen���㷨��ʵ��
%   ����3sigmaԭ��������ͼ�ͼ�����������[-6, 6]*[-6, 6]�ڽ��С�
%   ����
%       Num:������ĸ���������Ϊ2�ı�����
%       h: ����(����ά���ϴ�����ͬ)
%       dis: ���ֵ�ļ�࣬-6:dis:6
%       W_Flag:������ѡ���ǩ: 1-��������;2-��̬������;
%       P_Flag:��ͼ�ı�ǩ: 1-��ͼ; 0-����ͼ
%       m, n, p: ��ͼsubplot(m,n,p)�Ŀ��Ʋ���
%   ���
%       Berr: Bayes�������������
%       err: ���Ķ�����
numfig = 2*(W_Flag-1);
%�����ܶȷֲ�1
    mu1 = [-1, 0];
    sig1 = diag([1, 1]);
    P1 = 0.5;
    gm1 = gmdistribution(mu1, sig1);
%�����ܶȷֲ�2
    mu2 = [1, 0];
    sig2 = diag([2, 1]);
    P2 = 0.5;
    gm2 = gmdistribution(mu2, sig2);
    
%�������ɷ���0.2N(-1,1)+0.8N(1,1)���������
    if(mod(Num,2) ~= 0)
        error('������ĸ���������2�ı���');
    end
    if((n-1) ~= size(h,2))
        error('��ͼ�����봰�������������һ��');
    end
    %�����ܶȷֲ�1�Ĳ��������
    Num1 = Num/2;
    %�����ܶȷֲ�2�Ĳ��������
    Num2 = Num/2;
    %��ʼ���������
    Sample = zeros(Num, 2);
    test_Sample = zeros(100, 2);
    %�����ܶȷֲ�1�Ĳ�����
    Sample(1:Num1,:) = random(gm1,Num1);
    test_Sample(1:50,:) = random(gm1,50);
    %�����ܶȷֲ�1�Ĳ�����
    Sample((Num1+1):Num,:) = random(gm2,Num2);
    test_Sample(51:100,:) = random(gm2,50);
    
    %����������ֲ���ͼ
    if(P_flag == 1)
        figure(numfig+1);
        subplot(m,n,(p-1)*n+1);
        scatter(Sample(:,1),Sample(:,2));
        xlabel('X_1');
        ylabel('X_2');
        title('������ֲ�');
        axis([-6,6,-6,6])
        axis equal;
        figure(numfig+2);
        subplot(m,n,(p-1)*n+1);
        scatter(Sample(:,1),Sample(:,2));
        xlabel('X_1');
        ylabel('X_2');
        title('������ֲ�');
        axis([-6,6,-6,6])
        axis equal;
    end
    
%���ֵ�ĳ�ʼ��
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
%�Բ�����ѭ��������Ի��ֵ�Ĵ����������
    %���Ƹ����ܶȺ���1
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
    %���Ƹ����ܶȺ���2
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
    
%�Ի��ֵ�ѭ�������
    %ÿ�����ֵ��������
    vol = dis*dis;
    %��ϸ�˹�ֲ���������
    p_error = 0.5*p_Point_1 + 0.5*p_Point_2 - p_exact_Point;
    err(k) = sqrt(p_error'*p_error*vol);
    %Bayes�������
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
    %��ͼ
    if(P_flag == 1)
        %��Ͻ��ͼ
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
        %���ͼ
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

