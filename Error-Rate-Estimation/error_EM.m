%随机模拟20次以统计误差的期望和方差
mu_exact = [-1 0;
             1 0];

sig_exact(:,:,1) = diag([1 1]);
sig_exact(:,:,2) = diag([2 1]);
p = [0.5,0.5];
gm = gmdistribution(mu_exact,sig_exact,p);
gm1 = gmdistribution(mu_exact(1,:),sig_exact(:,:,1));
gm2 = gmdistribution(mu_exact(2,:),sig_exact(:,:,2));
num = 2000;

err = zeros(20,1);
Berr = zeros(20,1);

for s = 1:20
    emdata = [random(gm1,num/2);random(gm2,num/2)];
    test_data(1:50,:) = random(gm1,50);
    test_data(51:100,:) = random(gm2,50);
    
    [mu_result, sig_result, p_result] = EM(2,emdata);
    [X1,X2] = meshgrid((-6:0.1:6)', (-6:0.1:6)');
    Integral_Point = [X1(:) X2(:)];
    Integral_Num = size(Integral_Point,1);
    p_exact_Point = p(1)*mvnpdf(Integral_Point,mu_exact(1,:),sig_exact(:,:,1))...
        + p(2)*mvnpdf(Integral_Point,mu_exact(2,:),sig_exact(:,:,2));
    p_Point = p_result(1)*mvnpdf(Integral_Point,mu_result(1,:),sig_result(:,:,1))...
        + p_result(2)*mvnpdf(Integral_Point,mu_result(2,:),sig_result(:,:,2));
    p_error = p_Point - p_exact_Point;
    err(s) = sqrt(p_error'*p_error*0.01);
    
    p_test_1 = mvnpdf(test_data,mu_exact(1,:),sig_exact(:,:,1))*p_result(1);
    p_test_2 = mvnpdf(test_data,mu_exact(2,:),sig_exact(:,:,2))*p_result(2);
    Pe1 = 0;
    Pe2 = 0;
    for i = 1:50
        if(p_test_1(i) <= p_test_2(i))
            Pe1 = Pe1 + 1;
        end
    end
    Pe1 = Pe1/50;
    for i = 51:100
        if(p_test_1(i) >= p_test_2(i))
            Pe2 = Pe2 + 1;
        end
    end
    Pe2 = Pe2/50;
    Berr(s) = p_result(1)*Pe1 + p_result(2)*Pe2;
    
end

E_err = sum(err)/20;
E_Berr = sum(Berr)/20;
Var_err = (err-E_err)'*(err-E_err)/20;
Var_Berr = (Berr-E_Berr)'*(Berr-E_Berr)/20;
disp(['(',num2str(n),',',')','下的误差期望为  ',num2str(E_err)]);
disp(['(',num2str(n),',',')','下的误差方差为  ',num2str(Var_err)]);
disp(['(',num2str(n),',',')','下的B误差期望为  ',num2str(E_Berr)]);
disp(['(',num2str(n),',',')','下的B误差方差为  ',num2str(Var_Berr)]);