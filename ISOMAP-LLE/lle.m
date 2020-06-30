%% 生成三维3流形
num=1000;
total_num=2*num;
r=-0.2*rand(1,total_num)+0.3;
theta=[3*pi/2.0*rand(1,num)-pi/2.0,3*pi/2.0*rand(1,num)-pi];
y=rand(1,total_num);
x=[0.5+r.*cos(theta)];
z=[0.7+r(1:num).*sin(theta(1:num)),0.3+r(num+1:2*num).*sin(theta(num+1:num*2))];
figure();
scatter3(x(1:num),y(1:num),z(1:num),5,'r');
hold on;
scatter3(x(num+1:num*2),y(num+1:num*2),z(num+1:num*2),5,'b');
axis equal;
axis([0,1,0,1,0,1])

%% LLE
K=20;
% 构建距离矩阵
dist=zeros(total_num,total_num);
for i=1:total_num
    for j=i:total_num
        dx=x(i)-x(j);
        dy=y(i)-y(j);
        dz=z(i)-z(j);
        d=sqrt(dx*dx+dy*dy+dz*dz);
        dist(i,j)=d;
        dist(j,i)=d;
    end
end
% 排序
[sorted,index]=sort(dist);
neighbor=index(2:(K+1),:);
% 计算权重W, X=X'*W
W=zeros(total_num, total_num);
for i=1:total_num
    X=[x(neighbor(:,i))-x(i);y(neighbor(:,i))-y(i);z(neighbor(:,i))-z(i)];
    local = X'*X;
    local = local + eye(K,K)*0.001*trace(local);
    W(neighbor(:,i),i)=local\ones(K,1);
    W(:,i) = W(:,i)/sum(W(:,i));
end
% 计算M矩阵
M = (eye(total_num)-W)*(eye(total_num)-W)';
% 降维
d=2;
[V, S]=eig(M);
Y=V(:,2:(d+1))*sqrt(total_num);
figure();
scatter(Y(1:num,1),Y(1:num,2),5,'r');
hold on;
scatter(Y(num+1:num*2,1),Y(num+1:num*2,2),5,'b');