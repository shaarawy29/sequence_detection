`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/12/2024 08:21:25 PM
// Design Name: 
// Module Name: sequence_detection_unit
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


module sequence_detection_unit(nrst, clk, data, flag);

    // -----------------------------------------------------------
    // inputs
    // -----------------------------------------------------------
    input wire nrst;
    input wire clk;
    input wire [7:0] data;
    // -----------------------------------------------------------
    
    // -----------------------------------------------------------
    // outputs 
    // -----------------------------------------------------------
    output reg flag;
    // -----------------------------------------------------------
    
    // ---------------------------------------------------------------
    // pre-defiend sequence 
    // ------------------------------------------------------------
    localparam byte1 = 8'hAB,
               byte2 = 8'hCD,
               byte3 = 8'hEF,
               byte4 = 8'h24;
    // ---------------------------------------------------------------
    
    // ------------------------------------------------------------
    // state encoding (binary encoding)
    // -------------------------------------------------------------
    localparam ideal = 3'd0,
               s1 = 3'd1,
               s2 = 3'd2,
               s3 = 3'd3,
               s4 = 3'd4;
    // --------------------------------------------------------------
    
    // ----------------------------------------------------------------
    // state reg declaration 
    // ----------------------------------------------------------------
    reg [2:0] current_state;
    reg [2:0] next_state;
    // ---------------------------------------------------------------
    
    // ---------------------------------------------------------------
    // clocked always block modeling state register (Async rest)
    // ---------------------------------------------------------------
    always @(posedge clk, negedge nrst) begin
        if (nrst == 1'b0)
            current_state <= ideal;
        else
            current_state <= next_state;
    end
    // ----------------------------------------------------------------
    
    // ---------------------------------------------------------------
    // process modeling the next state logic (combinationl)
    // ----------------------------------------------------------------
    always @(current_state, data)begin
        case(current_state)
            ideal: begin 
                if(data == byte1) next_state = s1;
                else next_state = ideal;
            end
            s1: begin
                if(data == byte2) next_state = s2;
                else if(data == byte1) next_state = s1;
                else next_state = ideal;
            end
            s2: begin
                if(data == byte3) next_state = s3;
                else if(data == byte1) next_state = s1;
                else next_state = ideal;
            end
            s3: begin
                if(data == byte4) next_state = s4;
                else if(data == byte1) next_state = s1;
                else next_state = ideal;
            end
            s4: begin
                if(data == byte1) next_state = s1;
                else next_state = ideal;
            end
            default: next_state = ideal;
        endcase
    end
    // --------------------------------------------------------------
    
    // -----------------------------------------------------------------
    // always block modeling the output logic (combinational)
    // ------------------------------------------------------------------
    always @(current_state)begin
        case(current_state)
            ideal: flag = 1'b0;
            s1: flag = 1'b0;
            s2: flag = 1'b0;
            s3: flag = 1'b0;
            s4: flag = 1'b1;
            default: flag = 1'b0;
        endcase
    end
    
endmodule
