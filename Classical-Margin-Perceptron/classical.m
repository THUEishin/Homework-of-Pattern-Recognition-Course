%首先将所有label 2反号
y1 = [ones(100,1),label1];
y2 = -[ones(100,1),label2];
y = [y1;y2];

a = [1, 1, 1];
a = a/sqrt(a*a');

k=0;
count = 0;
countmax = 0;
iter = 0;
while(1)
    iter = iter + 1;
    k = mod(k, 200)+1;
    if(a*y(k,:)' <= 0)
        a = a + 0.1*y(k,:);
        a = a/sqrt(a*a');
        count = 0;
    else
        count = count +1;
    end
    countmax = max(count, countmax);
    if(count == 200)
        break;
    end
end

scatter(label1(:,1),label1(:,2))
hold on;
scatter(label2(:,1),label2(:,2),'rs')
x1 = -8:0.1:12;
x2 = -a(1)/a(3)-a(2)*x1/a(3);
plot(x1, x2,'g','LineWidth',2)
xlabel('X_1')
ylabel('X_2')
axis equal
axis([-8,12,-2,10])