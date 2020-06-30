%% 生成三维Z流形
num = 100;
num_total=num*3;
x=[];
y=[];
z=[];
% 上边生成1000个点
x=[x, rand(1,num)];
y=[y, rand(1,num)];
z=[z, 0.8+0.2*rand(1,num)];
% 斜边生成1000个点
x=[x, rand(1,num)];
y=[y, rand(1,num)];
z=[z, (x(num+1:2*num)*0.8+0.1)+(-0.2*rand(1,num)+0.1)];
%下边生成1000个点
x=[x, rand(1,num)];
y=[y, rand(1,num)];
z=[z,0.2*rand(1,num)];
figure();
scatter3(x(1:num),y(1:num),z(1:num),5,'r');
hold on;
scatter3(x(num+1:num*2),y(num+1:num*2),z(num+1:num*2),5,'g');
scatter3(x(num*2+1:num*3),y(num*2+1:num*3),z(num*2+1:num*3),5,'b');

%% 基于epsilon-radius的ISOMAP
epsilon=0.3;
% 构建距离矩阵
dist=inf*ones(num_total,num_total);
for i=1:num_total
    for j=i:num_total
        dx=x(i)-x(j);
        dy=y(i)-y(j);
        dz=z(i)-z(j);
        d=sqrt(dx*dx+dy*dy+dz*dz);
        if d < epsilon
            dist(i,j)=d;
            dist(j,i)=d;
        end
    end
end
% 求最短路径 Floyd
for k=1:num_total
    for i=1:num_total
        for j=i:num_total
            temp_d=dist(i,k)+dist(k,j);
            if temp_d < dist(i,j)
                dist(i,j)=temp_d;
                dist(j,i)=temp_d;
            end
        end
    end
end

A=zeros(num_total,num_total);
for i=1:num_total
    for j=1:num_total
        A(i,j)=-dist(i,j)*dist(i,j)/2.0;
    end
end

l=ones(num_total,1);
H=diag(ones(1,num_total))-l*l'/num_total;
B=H*A*H;

[U, S, V] = svd(B);
V=V(:,1:2);
S=sqrt(abs(S(1:2,1:2)));
X=V*S;
figure();
scatter(X(1:num,1),X(1:num,2),'r');
hold on;
scatter(X(num+1:2*num,1),X(num+1:2*num,2),'g')
scatter(X(2*num+1:3*num,1),X(2*num+1:3*num,2),'b')
