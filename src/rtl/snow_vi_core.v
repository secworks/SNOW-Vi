//======================================================================
//
// snow_vi_core.v
// ---------------
// Core functionality of the snow-vi stream cipher.
//
// Copyright (c) 2024, Assured AB
// Joachim Strömbergson
//
// Redistribution and use in source and binary forms, with or
// without modification, are permitted provided that the following
// conditions are met:
//
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in
//    the documentation and/or other materials provided with the
//    distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
// FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
// COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
// ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//======================================================================

`default_nettype none

module snow_vi_core(
                     input wire            clk,
                     input wire            reset_n,

                     input wire            init,
                     input wire            next,

                     input wire [255 : 0]  key,

                     output wire           ready,
                     output wire [127 : 0] keystream
                    );


  //----------------------------------------------------------------
  // Internal constant and parameter definitions.
  //----------------------------------------------------------------
  localparam CTRL_IDLE      = 3'h0;
  localparam CTRL_INIT      = 3'h1;
  localparam CTRL_NEXT      = 3'h2;
  localparam CTRL_READY     = 3'h7;


  //----------------------------------------------------------------
  // Internal functions.
  //----------------------------------------------------------------


  //----------------------------------------------------------------
  // Registers including update variables and write enable.
  //----------------------------------------------------------------
  reg [15 : 0] lfsr_a_reg [0 : 15];
  reg [15 : 0] lfsr_a_new [0 : 15];
  reg          lfsr_a_we;

  reg [15 : 0] lfsr_b_reg [0 : 15];
  reg [15 : 0] lfsr_b_new [0 : 15];
  reg          lfsr_b_we;

  reg [127 : 0] r1_reg;
  reg [127 : 0] r1_new;
  reg           r1_we;

  reg [127 : 0] r2_reg;
  reg [127 : 0] r2_new;
  reg           r2_we;

  reg [127 : 0] r3_reg;
  reg [127 : 0] r3_new;
  reg           r3_we;

  reg          ready_reg;
  reg          ready_new;
  reg          ready_we;

  reg [2 : 0]  snow_vi_core_ctrl_reg;
  reg [2 : 0]  snow_vi_core_ctrl_new;
  reg          snow_vi_core_ctrl_we;


  //----------------------------------------------------------------
  // Wires.
  //----------------------------------------------------------------
  wire [127 : 0] tmp_keystream;

  wire [127 : 0] t1;
  wire [127 : 0] t2;


  //----------------------------------------------------------------
  // Concurrent connectivity for ports etc.
  //----------------------------------------------------------------
  assign keystream = tmp_keystream;
  assign ready     = ready_reg;

  assign t1 = {lfsr_b_reg[7], lfsr_b_reg[6], lfsr_b_reg[5], lfsr_b_reg[4],
	       lfsr_b_reg[3], lfsr_b_reg[2], lfsr_b_reg[1], lfsr_b_reg[0]};

  assign t2 = {lfsr_a_reg[7], lfsr_a_reg[6], lfsr_a_reg[5], lfsr_a_reg[4],
	       lfsr_a_reg[3], lfsr_a_reg[2], lfsr_a_reg[1], lfsr_a_reg[0]};


  //----------------------------------------------------------------
  // reg_update
  //
  // Update functionality for all registers in the core.
  // All registers are positive edge triggered with synchronous
  // active low reset.
  //----------------------------------------------------------------
  always @ (posedge clk)
    begin : reg_update
      integer i;
      if (!reset_n) begin
        for (i = 0 ; i < 16 ; i = i + 1) begin
          lfsr_a_reg[i] <= 16'h0;
          lfsr_b_reg[i] <= 16'h0;
        end

        ready_reg             <= 1'h0;
        snow_vi_core_ctrl_reg <= CTRL_IDLE;
      end

      else begin
        if (ready_we) begin
          ready_reg <= ready_new;
	end

        if (lfsr_a_we) begin
          for (i = 0 ; i < 16 ; i = i + 1) begin
            lfsr_a_reg[i] <= lfsr_a_new[i];
          end
	end

        if (lfsr_b_we) begin
          for (i = 0 ; i < 16 ; i = i + 1) begin
            lfsr_b_reg[i] <= lfsr_b_new[i];
          end
	end

        if (snow_vi_core_ctrl_we) begin
          snow_vi_core_ctrl_reg <= snow_vi_core_ctrl_new;
	end
      end
    end


  //----------------------------------------------------------------
  // snow_vi_core_logic
  //----------------------------------------------------------------
  always @*
    begin : snow_vi_core_logic
      integer i;
    end // snow_vi_core_logic


  //----------------------------------------------------------------
  // snow_vi_core_ctrl
  //----------------------------------------------------------------
  always @*
    begin : snow_vi_core_ctrl
      snow_vi_core_ctrl_new = CTRL_IDLE;
      snow_vi_core_ctrl_we  = 1'h0;

      case (snow_vi_core_ctrl_reg)
        CTRL_IDLE: begin
          if (init) begin
	    snow_vi_core_ctrl_new = CTRL_INIT;
	    snow_vi_core_ctrl_we  = 1'h1;
          end

          if (next) begin
	    snow_vi_core_ctrl_new = CTRL_NEXT;
	    snow_vi_core_ctrl_we  = 1'h1;
          end
        end

        CTRL_INIT: begin
	  snow_vi_core_ctrl_new = CTRL_IDLE;
	  snow_vi_core_ctrl_we  = 1'h1;
        end

        CTRL_NEXT: begin
	  snow_vi_core_ctrl_new = CTRL_IDLE;
	  snow_vi_core_ctrl_we  = 1'h1;
        end

        default: begin
        end
      endcase // case (snow_vi_core_ctrl_reg)
    end

endmodule // snow_vi_core

//======================================================================
// EOF snow_vi_core.v
//======================================================================
