%通过对同一组(n,a)随机模拟20次以统计误差的期望和方差

err = zeros(20,1);
n = 10;
a = 5;
W_Flag = 4;

for s = 1:20
    err(s) = Parzen(n, a,0.01,W_Flag,0,0,0,0);
end

E_err = sum(err)/20;
Var_err = (err-E_err)'*(err-E_err)/20;
disp(['(',num2str(n),',',num2str(a),')','下的误差期望为  ',num2str(E_err)]);
disp(['(',num2str(n),',',num2str(a),')','下的误差方差为  ',num2str(Var_err)]);