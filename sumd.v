module sumd(y,a,b);
output [3:0] y;
input a,b;
not(a_bar,a),(b_bar,b);
and(y[0],a_bar,b_bar),(y[1],a_bar,b),(y[2],a,b_bar),(y[3],a,b);
endmodule 