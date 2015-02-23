// File: ad9866.v
// Generated by MyHDL 0.8.1
// Date: Sat Feb 21 22:24:32 2015


`timescale 1ns/10ps

module ad9866 (
    reset,
    clk,
    sclk,
    sdio,
    sdo,
    sen_n,
    dataout,
    extrqst,
    extdata
);


input reset;
input clk;
output sclk;
reg sclk;
output sdio;
wire sdio;
input sdo;
output sen_n;
reg sen_n;
output [7:0] dataout;
wire [7:0] dataout;
input extrqst;
input [15:0] extdata;

reg [15:0] datain;
reg start;
reg [3:0] dut2_bitcount;
reg [0:0] dut2_state;
reg [15:0] dut2_data;
reg [3:0] dut1_pc;





always @(posedge clk, posedge reset) begin: AD9866_DUT1_FSM
    if (reset == 1) begin
        dut1_pc <= 0;
    end
    else begin
        if (((dut1_pc != 15) && sen_n)) begin
            dut1_pc <= (dut1_pc + 1);
        end
    end
end


always @(sen_n, dut1_pc, extrqst, extdata) begin: AD9866_DUT1_COMB
    if (((dut1_pc == 1) && sen_n)) begin
        start = 1;
        datain = 128;
    end
    else if (((dut1_pc == 3) && sen_n)) begin
        start = 1;
        datain = 3137;
    end
    else if (((dut1_pc == 5) && sen_n)) begin
        start = 1;
        datain = 3329;
    end
    else if (((dut1_pc == 7) && sen_n)) begin
        start = 1;
        datain = 1825;
    end
    else if (((dut1_pc == 9) && sen_n)) begin
        start = 1;
        datain = 2123;
    end
    else if (((dut1_pc == 15) && sen_n && extrqst)) begin
        start = 1;
        datain = extdata;
    end
    else begin
        start = 0;
        datain = 0;
    end
end



assign dataout = dut2_data[8-1:0];
assign sdio = dut2_data[15];


always @(posedge clk, posedge reset) begin: AD9866_DUT2_FSM
    if (reset == 1) begin
        sen_n <= 1;
        sclk <= 0;
        dut2_state <= 1'b0;
        dut2_data <= 0;
        dut2_bitcount <= 0;
    end
    else begin
        case (dut2_state)
            1'b0: begin
                sclk <= 0;
                dut2_bitcount <= 15;
                if (start) begin
                    dut2_data <= datain;
                    sen_n <= 0;
                    dut2_state <= 1'b1;
                end
                else begin
                    sen_n <= 1;
                end
            end
            1'b1: begin
                if ((!sclk)) begin
                    sclk <= 1;
                end
                else begin
                    dut2_data <= {dut2_data[15-1:0], sdo};
                    dut2_bitcount <= (dut2_bitcount - 1);
                    sclk <= 0;
                    if ((dut2_bitcount == 0)) begin
                        dut2_state <= 1'b0;
                    end
                end
            end
        endcase
    end
end

endmodule
