periods_div1_st = load('div1_periods.mat');
periods_div2_st = load('div2_periods.mat');
periods_div4_st = load('div4_periods.mat');

periods_div1 = periods_div1_st.periods;
periods_div2 = periods_div2_st.periods;
periods_div4 = periods_div4_st.periods;

tie_div1_st = load('div1_tie.mat');
tie_div2_st = load('div2_tie.mat');
tie_div4_st = load('div4_tie.mat');

tie_div1 = tie_div1_st.tie_save;
tie_div2 = tie_div2_st.tie_save;
tie_div4 = tie_div4_st.tie_save;

figure
hold on;
h = histfit(periods_div1(2,:)*1e9,67);
h(1).FaceColor = [1 0 0];
h = histfit(periods_div2(2,:)*1e9,67);
h(1).FaceColor = [0 1 0];
h = histfit(periods_div4(2,:)*1e9,67);
h(1).FaceColor = [0 0 1];
title('')
xlabel('Period (ns)','fontsize',16);
ylabel('Occurance Rate','fontsize',16);
yticklabels([])
ax = gca;
ax.FontSize = 16;
alpha(.33)
legend("div1","div2","div4")

figure
hold on;
plot(tie_div1(2,:))
x = 1:2:(10000-2);
plot(x,tie_div2(2,:)-200E-9)
plot(1:4:10000,tie_div4(2,:))