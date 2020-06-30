mu_exact = [-1 0;
             1 0];

sig_exact(:,:,1) = diag([1 1]);
sig_exact(:,:,2) = diag([2 1]);
p = [0.5,0.5];
gm = gmdistribution(mu_exact,sig_exact,p);
n = [20, 200, 2000];
figure();
for i=1:3
    num = n(i);
    emdata = random(gm,num);
    subplot(3,3,(i-1)*3+1);
    scatter(emdata(:,1),emdata(:,2));
    xlabel('X_1');
    ylabel('X_2');
    title('采样点分布');
    axis([-6,6,-6,6])
    axis equal;
    
    [mu_result, sig_result, p_result] = EM(2,emdata);
    [X1,X2] = meshgrid((-6:0.1:6)', (-6:0.1:6)');
    Integral_Point = [X1(:) X2(:)];
    Integral_Num = size(Integral_Point,1);
    p_exact_Point = p(1)*mvnpdf(Integral_Point,mu_exact(1,:),sig_exact(:,:,1))...
        + p(2)*mvnpdf(Integral_Point,mu_exact(2,:),sig_exact(:,:,2));
    p_Point = p_result(1)*mvnpdf(Integral_Point,mu_result(1,:),sig_result(:,:,1))...
        + p_result(2)*mvnpdf(Integral_Point,mu_result(2,:),sig_result(:,:,2));
    p_error = p_Point - p_exact_Point;
    
    subplot(3,3,(i-1)*3+2)
    surf(X1,X2,reshape(p_Point,size(X1,1),size(X1,1)));
    xlabel('X_1');
    ylabel('X_2');
    zlabel('p')
    title('拟合的GMM概率密度函数')
    axis([-6,6,-6,6,0,1])
    axis equal;
    caxis([0,0.1]);
    hc0 = colorbar ;
    set(hc0,'YTick',0:0.02:0.1)
    shading interp;
    view(0,90)

    subplot(3,3,(i-1)*3+3)
    surf(X1,X2,reshape(p_error,size(X1,1),size(X1,1)));
    xlabel('X_1');
    ylabel('X_2');
    zlabel('p')
    title('拟合的GMM概率密度函数误差')
    axis([-6,6,-6,6,0,1])
    axis equal;
    caxis([-0.1,0.1]);
    hc0 = colorbar ;
    set(hc0,'YTick',-0.1:0.05:0.1)
    shading interp;
    view(0,90)
end