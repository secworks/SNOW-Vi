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


  //----------------------------------------------------------------
  // Concurrent connectivity for ports etc.
  //----------------------------------------------------------------
  assign keystream = tmp_keystream;
  assign ready     = ready_reg;


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
          lfsr_a_reg <= 16'h0;
          lfsr_b_reg <= 16'h0;
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
      reg [31 : 0] b0;
      reg [31 : 0] b1;
      reg [31 : 0] b2;
      reg [31 : 0] b3;

      for (i = 0 ; i < 5 ; i = i + 1)
        h_new[i] = 32'h0;
      h_we = 1'h0;

      for (i = 0 ; i < 5 ; i = i + 1)
        c_new[i] = 32'h0;
      c_we = 1'h0;

      for (i = 0 ; i < 4 ; i = i + 1)
        r_new[i] = 32'h0;
      r_we = 1'h0;

      for (i = 0 ; i < 4 ; i = i + 1)
        s_new[i] = 32'h0;
      s_we = 1'h0;

      for (i = 0 ; i < 4 ; i = i + 1)
        mac_new[i] = 32'h0;
      mac_we = 1'h0;

      b0 = le(block[031 : 000]);
      b1 = le(block[063 : 032]);
      b2 = le(block[095 : 064]);
      b3 = le(block[127 : 096]);

      if (state_init)
        begin
          c_we     = 1'h1;
          h_we     = 1'h1;

          // Clamping of the key when assigning r.
          r_new[0] = le(key[255 : 224]) & 32'h0fffffff;
          r_new[1] = le(key[223 : 192]) & 32'h0ffffffc;
          r_new[2] = le(key[191 : 160]) & 32'h0ffffffc;
          r_new[3] = le(key[159 : 128]) & 32'h0ffffffc;
          r_we     = 1'h1;

          s_new[0] = le(key[127 : 096]);
          s_new[1] = le(key[095 : 064]);
          s_new[2] = le(key[063 : 032]);
          s_new[3] = le(key[031 : 000]);
          s_we     = 1'h1;
        end

      // Note that we only check bits 0..3 in blocklen.
      // This means that a blocklen of 0 and 16 are
      // handled the same way.
      if (load_block)
        begin
          if (blocklen[3 : 0] > 0)
            begin
              // Handling of partial (final) blocks.
              case (blocklen[3 : 0])
                0: begin
                  c_new[0] = 32'h1;
                end

                1: begin
                  c_new[0] = {24'h1, b3[7 : 0]};
                end

                2: begin
                  c_new[0] = {16'h1, b3[15 : 0]};
                end

                3: begin
                  c_new[0] = {8'h1, b3[23 : 0]};
                end

                4: begin
                  c_new[0] = b3;
                  c_new[1] = 32'h1;
                end

                5: begin
                  c_new[0] = b3;
                  c_new[1] = {24'h1, b2[7 : 0]};
                end

                6: begin
                  c_new[0] = b3;
                  c_new[1] = {16'h1, b2[15 : 0]};
                end

                7: begin
                  c_new[0] = b3;
                  c_new[1] = {8'h1, b2[23 : 0]};
                end

                8: begin
                  c_new[0] = b3;
                  c_new[1] = b2;
                  c_new[2] = 32'h1;
                end

                9: begin
                  c_new[0] = b3;
                  c_new[1] = b2;
                  c_new[2] = {24'h1, b1[7 : 0]};
                end

                10: begin
                  c_new[0] = b3;
                  c_new[1] = b2;
                  c_new[2] = {16'h1, b1[15 : 0]};
                end

                11: begin
                  c_new[0] = b3;
                  c_new[1] = b2;
                  c_new[2] = {8'h1, b1[23 : 0]};
                end

                12: begin
                  c_new[0] = b3;
                  c_new[1] = b2;
                  c_new[2] = b1;
                  c_new[3] = 32'h1;
                end

                13: begin
                  c_new[0] = b3;
                  c_new[1] = b2;
                  c_new[2] = b1;
                  c_new[3] = {24'h1, b0[7 : 0]};
                end

                14: begin
                  c_new[0] = b3;
                  c_new[1] = b2;
                  c_new[2] = b1;
                  c_new[3] = {16'h1, b0[15 : 0]};
                end

                15: begin
                  c_new[0] = b3;
                  c_new[1] = b2;
                  c_new[2] = b1;
                  c_new[3] = {8'h1, b0[23 : 0]};
                end
              endcase // case (blocklen[3 : 0])
              c_new[4] = 32'h0;
              c_we     = 1'h1;
            end
          else
            begin
              // Handling of full blocks.
              c_new[0] = b3;
              c_new[1] = b2;
              c_new[2] = b1;
              c_new[3] = b0;
              c_new[4] = 32'h1;
              c_we     = 1'h1;
            end
        end


      if (state_update)
        begin
          for (i = 0 ; i < 5 ; i = i + 1)
            h_new[i] = pblock_h_new[i];
          h_we = 1'h1;
        end


      if (mac_update)
        begin
          mac_new[3] = le(hres0);
          mac_new[2] = le(hres1);
          mac_new[1] = le(hres2);
          mac_new[0] = le(hres3);
          mac_we     = 1'h1;
        end
    end // snow_vi_core_logic


  //----------------------------------------------------------------
  // snow_vi_core_ctrl
  //----------------------------------------------------------------
  always @*
    begin : snow_vi_core_ctrl
      state_init             = 1'h0;
      load_block             = 1'h0;
      state_update           = 1'h0;
      pblock_start           = 1'h0;
      final_start            = 1'h0;
      mac_update             = 1'h0;
      ready_new              = 1'h0;
      ready_we               = 1'h0;
      snow_vi_core_ctrl_new = CTRL_IDLE;
      snow_vi_core_ctrl_we  = 1'h0;


      case (snow_vi_core_ctrl_reg)
        CTRL_IDLE:
          begin
            if (init)
              begin
                state_init             = 1'h1;
                ready_new              = 1'h0;
                ready_we               = 1'h1;
                snow_vi_core_ctrl_new = CTRL_READY;
                snow_vi_core_ctrl_we  = 1'h1;
              end

            if (next)
              begin
                load_block             = 1'h1;
                ready_new              = 1'h0;
                ready_we               = 1'h1;

                if (blocklen > 0)
                  begin
                    snow_vi_core_ctrl_new = CTRL_NEXT;
                    snow_vi_core_ctrl_we  = 1'h1;
                  end
                else
                  begin
                    snow_vi_core_ctrl_new = CTRL_READY;
                    snow_vi_core_ctrl_we  = 1'h1;
                  end
              end

            if (finish)
              begin
                final_start            = 1'h1;
                ready_new              = 1'h0;
                ready_we               = 1'h1;
                snow_vi_core_ctrl_new = CTRL_FINAL;
                snow_vi_core_ctrl_we  = 1'h1;
              end
          end


        CTRL_NEXT:
          begin
            pblock_start           = 1'h1;
            snow_vi_core_ctrl_new = CTRL_NEXT_WAIT;
            snow_vi_core_ctrl_we  = 1'h1;
          end


        CTRL_NEXT_WAIT:
          begin
            if (pblock_ready)
              begin
                state_update           = 1'h1;
                snow_vi_core_ctrl_new = CTRL_READY;
                snow_vi_core_ctrl_we  = 1'h1;
              end
          end


        CTRL_FINAL:
          begin
            if (final_ready)
              begin
                mac_update             = 1'h1;
                ready_new              = 1'h1;
                ready_we               = 1'h1;
                snow_vi_core_ctrl_new = CTRL_IDLE;
                snow_vi_core_ctrl_we  = 1'h1;
              end
          end


        CTRL_READY:
          begin
            ready_new              = 1'h1;
            ready_we               = 1'h1;
            snow_vi_core_ctrl_new = CTRL_IDLE;
            snow_vi_core_ctrl_we  = 1'h1;
          end

        default:
          begin
          end
      endcase // case (snow_vi_core_ctrl_reg)
    end

endmodule // snow_vi_core

//======================================================================
// EOF snow_
// vi_core.v
//======================================================================
