% loop filter cutoff
ki = 1;
ki_frac_bits = 8;
kp = 1;
kp_frac_bits = 4;
div_at_exit = 2;
target = 5E6;
loop_div = 4;

b0 = kp/(div_at_exit*2^kp_frac_bits);
b1 = ki/(div_at_exit*2^ki_frac_bits);

TS = 1/(target/loop_div);
N = 2*[(2*b0 + TS*b1)  (-2*b0 + TS*b1)];
D = [1 -1];

PI_tf = tf(N, D, TS);

bode(PI_tf);

%% error code to freq
pa_freq_sens = 1*b0*(258E6*(1/2^12));

inv_num = 383;
T_target = 1/target;

ro_freq_sens = 1*b0*(abs(1/(T_target - T_target/inv_num)-target) + abs(1/(T_target + T_target/inv_num)-target))/2;
