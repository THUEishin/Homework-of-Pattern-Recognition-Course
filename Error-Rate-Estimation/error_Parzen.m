%通过对同一组(n,a)随机模拟20次以统计误差的期望和方差

err = zeros(20,3);
Berr = zeros(20,3);
n = 2000;
a = [0.1, 5.6/sqrt(sqrt(n/20)) ,5];
W_Flag = 1;

for s = 1:20
    [Berr(s,:), err(s,:)] = Parzen(n, a,0.5,W_Flag,0,0,4,0);
end

E_err = sum(err,1)/20;
E_Berr = sum(Berr,1)/20;
Var_err(1) = (err(:,1)-E_err(1))'*(err(:,1)-E_err(1))/20;
Var_err(2) = (err(:,2)-E_err(2))'*(err(:,2)-E_err(2))/20;
Var_err(3) = (err(:,3)-E_err(3))'*(err(:,3)-E_err(3))/20;
Var_Berr(1) = (Berr(:,1)-E_Berr(1))'*(Berr(:,1)-E_Berr(1))/20;
Var_Berr(2) = (Berr(:,2)-E_Berr(2))'*(Berr(:,2)-E_Berr(2))/20;
Var_Berr(3) = (Berr(:,3)-E_Berr(3))'*(Berr(:,3)-E_Berr(3))/20;
disp(['(',num2str(n),',',num2str(a),')','下的误差期望为  ',num2str(E_err)]);
disp(['(',num2str(n),',',num2str(a),')','下的误差方差为  ',num2str(Var_err)]);
disp(['(',num2str(n),',',num2str(a),')','下的B误差期望为  ',num2str(E_Berr)]);
disp(['(',num2str(n),',',num2str(a),')','下的B误差方差为  ',num2str(Var_Berr)]);