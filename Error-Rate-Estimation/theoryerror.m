%�����ܶȷֲ�1
mu1 = [-1, 0];
sig1 = diag([1, 1]);
P1 = 0.5;
%�����ܶȷֲ�2
mu2 = [1, 0];
sig2 = diag([2, 1]);
P2 = 0.5;

Pe1 = 0; %��һ�������
Pe2 = 0; %�ڶ��������

%��ֵ������ѭ3sigmaԭ�򣬻�������ȡΪ[-6,6]*[-6,6]
x = -6:0.1:6;
y = -6:0.1:6;
num = size(x,2);
for i = 1:num
    for j=1:num
        X = [x(i),y(j)];
        %����������ܶȺ���
        p1 = mvnpdf(X,mu1,sig1);
        p2 = mvnpdf(X,mu2,sig2);
        if(p1 > p2)
            %����Ϊomega1��
            Pe2 = Pe2 + p2*0.01;
        else
            Pe1 = Pe1 + p1*0.01;
        end
    end
end

errorrate = P1*Pe1 + P2*Pe2;



