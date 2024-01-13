`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/12/2024 11:13:34 PM
// Design Name: 
// Module Name: sequence_detection_unit_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sequence_detection_unit_tb();

    // ------------------------------------------------------------------------
    // signals to drive and monitor the DUT
    // ------------------------------------------------------------------------
    reg clk, nrst;
    reg [7:0] data;
    wire flag;
    // ----------------------------------------------------------------------------
    
    // ------------------------------------------------------------------------------
    // instantiating the DUT
    // ------------------------------------------------------------------------------
    sequence_detection_unit DUT (.nrst(nrst), .clk(clk), .data(data), .flag(flag));
    // ------------------------------------------------------------------------------
    
    // ---------------------------------------------------------------
    // pre-defiend sequence, clock period
    // ------------------------------------------------------------
    localparam byte1 = 8'hAB,
               byte2 = 8'hCD,
               byte3 = 8'hEF,
               byte4 = 8'h24,
               clk_period = 10;
    // ---------------------------------------------------------------
    
    // ----------------------------------------------------------------
    // clock generation task 
    // ----------------------------------------------------------------
    task clk_generation();
        begin
            clk = 0;
            forever #(clk_period/2) clk = ~clk;
        end
    endtask
    // --------------------------------------------------------------------
    
    // --------------------------------------------------------------------
    // generating stimulus task
    // ---------------------------------------------------------------------
    task generate_stim();
        begin
            nrst = 1'b0; #23; nrst = 1'b1;
            @(posedge clk) data = 8'h88;
            @(posedge clk) data = byte1;
            @(posedge clk) data = 8'hA2;
            @(posedge clk) data = byte1;
            @(posedge clk) data = byte2;
            @(posedge clk) data = byte3;
            @(posedge clk) data = byte4;
            @(posedge clk) data = byte1;
            @(posedge clk) data = byte2;
            @(posedge clk) data = 8'h44;
            @(posedge clk) data = byte1;
            @(posedge clk) data = byte2;
            @(posedge clk) data = byte3;
            @(posedge clk) data = byte4;
            @(posedge clk) data = 8'hFF;
            #(clk_period/2);
            nrst = 1'b0;
            @(posedge clk) data = 8'h0C;
            @(posedge clk) data = byte1;
            @(posedge clk) data = byte2;
            @(posedge clk) data = byte3;
            @(posedge clk) data = byte4;
            @(posedge clk) data = byte1;
        end
    endtask
    // -------------------------------------------------------------------
    
    // --------------------------------------------------------------------
    // taks call
    // --------------------------------------------------------------------
    initial clk_generation();
    initial generate_stim();
    // --------------------------------------------------------------------
    

endmodule
