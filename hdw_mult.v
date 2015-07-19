/*
    Unsigned 8 bit multipler with testbench
*/

module testbench(
);
    reg clk; 

    always
    begin
        clk <= 1; # 5; clk <= 0; # 5;
    end 

    wire [15:0] nxtProduct;
    reg  [15:0]  Product;
    reg  [8:0]   op1; 
    reg  [8:0]   op2; 
    wire [15:0] nxtChkProduct;
    reg  [15:0] chkProduct; 
    reg fail; 

    initial begin
        op1 <= 0;
        op2 <= 0;
        Product <= 0;
        chkProduct <= 0;
        clk <= 0; 
        fail <=0;
    end 

    always @(posedge clk) begin 
        Product <= nxtProduct;
        op1 <= op1 +1; 
        if(op1 === 256) begin
            op2 <= op2+1; 
        end
        chkProduct <= nxtChkProduct; 
     end

    multipler mul(op1[7:0],op2[7:0],nxtProduct);
    assign nxtChkProduct = op1[7:0] * op2[7:0]; 

    always @(posedge clk) begin 
        if ( op2 === 256) begin
            if (~fail)
                $display("SUCESS\n"); 
            $finish; 
        end
        if ( ~(chkProduct === Product) ) begin 
            $display("%d*%d=%d ACTUAL %d",op1,op2,Product,chkProduct);
            $display("FAILURE\n");
            fail <= 1; 
            //$finish;
        end
        //$display("%d*%d=%d\n",op1-1,op2-1,Product);
    end
endmodule 

module multipler (
    input  [7:0]  op0,
    input  [7:0]  op1,
    output [15:0] res
);
    //p0[7:0] = a[0] × b[7:0] = {8{a[0]}} & b[7:0]
    //p1[7:0] = a[1] × b[7:0] = {8{a[1]}} & b[7:0]
    //p2[7:0] = a[2] × b[7:0] = {8{a[2]}} & b[7:0]
    //p3[7:0] = a[3] × b[7:0] = {8{a[3]}} & b[7:0]
    //p4[7:0] = a[4] × b[7:0] = {8{a[4]}} & b[7:0] 
    //p5[7:0] = a[5] × b[7:0] = {8{a[5]}} & b[7:0]
    //p6[7:0] = a[6] × b[7:0] = {8{a[6]}} & b[7:0]
    //p7[7:0] = a[7] × b[7:0] = {8{a[7]}} & b[7:0]
    wire [7:0] p0, p1, p2, p3, p4, p5, p6, p7;
    assign p0[7:0] = {8{op0[0]}} & op1[7:0];
    assign p1[7:0] = {8{op0[1]}} & op1[7:0];
    assign p2[7:0] = {8{op0[2]}} & op1[7:0];
    assign p3[7:0] = {8{op0[3]}} & op1[7:0];
    assign p4[7:0] = {8{op0[4]}} & op1[7:0];
    assign p5[7:0] = {8{op0[5]}} & op1[7:0];
    assign p6[7:0] = {8{op0[6]}} & op1[7:0];
    assign p7[7:0] = {8{op0[7]}} & op1[7:0];
    //                                                p0[7] p0[6] p0[5] p0[4] p0[3] p0[2] p0[1] p0[0]
    //                                        + p1[7] p1[6] p1[5] p1[4] p1[3] p1[2] p1[1] p1[0] 0
    //                                  + p2[7] p2[6] p2[5] p2[4] p2[3] p2[2] p2[1] p2[0] 0     0
    //                            + p3[7] p3[6] p3[5] p3[4] p3[3] p3[2] p3[1] p3[0] 0     0     0
    //                      + p4[7] p4[6] p4[5] p4[4] p4[3] p4[2] p4[1] p4[0] 0     0     0     0
    //                + p5[7] p5[6] p5[5] p5[4] p5[3] p5[2] p5[1] p5[0] 0     0     0     0     0
    //          + p6[7] p6[6] p6[5] p6[4] p6[3] p6[2] p6[1] p6[0] 0     0     0     0     0     0
    //    + p7[7] p7[6] p7[5] p7[4] p7[3] p7[2] p7[1] p7[0] 0     0     0     0     0     0     0
    //-------------------------------------------------------------------------------------------
    //P[15] P[14] P[13] P[12] P[11] P[10]  P[9]  P[8]  P[7]  P[6]  P[5]  P[4]  P[3]  P[2]  P[1]  P[0]
    wire [3:0] P[15:0]; 
    
    assign       P[0 ]    = p0[0]                                                                     ; 
    assign       P[1 ]    = p0[1] + p1[0]                                                             ;//+ P[0 ][1:1]; 
    assign       P[2 ]    = p0[2] + p1[1] + p2[0]                                         + P[1 ][1:1]; 
    assign       P[3 ]    = p0[3] + p1[2] + p2[1] + p3[0]                                 + P[2 ][2:1]; 
    assign       P[4 ]    = p0[4] + p1[3] + p2[2] + p3[1] + p4[0]                         + P[3 ][2:1]; 
    assign       P[5 ]    = p0[5] + p1[4] + p2[3] + p3[2] + p4[1] + p5[0]                 + P[4 ][3:1]; 
    assign       P[6 ]    = p0[6] + p1[5] + p2[4] + p3[3] + p4[2] + p5[1] + p6[0]         + P[5 ][3:1]; 
    assign       P[7 ]    = p0[7] + p1[6] + p2[5] + p3[4] + p4[3] + p5[2] + p6[1] + p7[0] + P[6 ][3:1]; 
    assign       P[8 ]    =         p1[7] + p2[6] + p3[5] + p4[4] + p5[3] + p6[2] + p7[1] + P[7 ][3:1]; 
    assign       P[9 ]    =                 p2[7] + p3[6] + p4[5] + p5[4] + p6[3] + p7[2] + P[8 ][3:1]; 
    assign       P[10]    =                         p3[7] + p4[6] + p5[5] + p6[4] + p7[3] + P[9 ][3:1]; 
    assign       P[11]    =                                 p4[7] + p5[6] + p6[5] + p7[4] + P[10][3:1]; 
    assign       P[12]    =                                         p5[7] + p6[6] + p7[5] + P[11][3:1]; 
    assign       P[13]    =                                                 p6[7] + p7[6] + P[12][2:1]; 
    assign       P[14]    =                                                         p7[7] + P[13][2:1]; 
    assign       P[15]    =                                                             0 + P[14][1:1];
    assign       res[15:0] = {P[15][0],P[14][0],P[13][0],P[12][0],P[11][0],P[10][0],P[9][0]
                        ,P[8][0],P[7][0],P[6][0],P[5][0],P[4][0],P[3][0],P[2][0],
                        P[1][0],P[0][0]};
endmodule
