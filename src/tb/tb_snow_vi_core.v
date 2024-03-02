module tb_snow_vi_core();

  //----------------------------------------------------------------
  // Internal constant and parameter definitions.
  //----------------------------------------------------------------
  parameter DEBUG     = 0;
  parameter DUMP_WAIT = 0;

  parameter CLK_HALF_PERIOD = 1;
  parameter CLK_PERIOD = 2 * CLK_HALF_PERIOD;


  //----------------------------------------------------------------
  // Register and Wire declarations.
  //----------------------------------------------------------------
  reg [31 : 0]   cycle_ctr;
  reg [31 : 0]   error_ctr;
  reg [31 : 0]   tc_ctr;
  reg            tb_monitor;

  reg            display_dut_state;
  reg            display_core_state;

  reg            clk;
  reg            reset_n;
  reg            tb_init;
  reg            tb_next;
  reg [255 : 0]  tb_key;
  wire           tb_ready;
  wire [127 : 0] tb_keystream;


  //----------------------------------------------------------------
  // Device Under Test.
  //----------------------------------------------------------------
  snow_vi_core dut(
                   .clk(clk),
                   .reset_n(reset_n),
                   .init(tb_init),
                   .next(tb_next),
                   .key(tb_key),
                   .keystream(tb_keystream),
                   .ready(tb_ready)
                  );


  //----------------------------------------------------------------
  // clk_gen
  // Always running clock generator process.
  //----------------------------------------------------------------
  always
    begin : clk_gen
      #CLK_HALF_PERIOD;
      tb_clk = !tb_clk;
    end // clk_gen


  //----------------------------------------------------------------
  // sys_monitor()
  // An always running process that creates a cycle counter and
  // conditionally displays information about the DUT.
  //----------------------------------------------------------------
  always
    begin : sys_monitor
      cycle_ctr = cycle_ctr + 1;
      #(CLK_PERIOD);
      if (tb_monitor)
        begin
          dump_dut_state();
        end
    end


  //----------------------------------------------------------------
  // init_sim()
  // Initialize all counters and testbench functionality as well
  // as setting the DUT inputs to defined values.
  //----------------------------------------------------------------
  task init_sim;
    begin
      cycle_ctr          = 0;
      error_ctr          = 0;
      tc_ctr             = 0;
      tb_monitor         = 0;
      display_dut_state  = 0;
      display_core_state = 0;
      tb_clk             = 1'h0;
      tb_reset_n         = 1'h1;
      tb_init            = 1'h0;
      tb_next            = 1'h0;
      tb_key             = 256'h0;
    end
  endtask // init_sim


  //----------------------------------------------------------------
  // reset_dut()
  //
  // Toggle reset to put the DUT into a well known state.
  //----------------------------------------------------------------
  task reset_dut;
    begin
      $display("--- Toggle reset.");
      tb_reset_n = 0;
      #(2 * CLK_PERIOD);
      tb_reset_n = 1;
    end
  endtask // reset_dut


  //----------------------------------------------------------------
  // sys_monitor()
  //
  // An always running process that creates a cycle counter and
  // conditionally displays information about the DUT.
  //----------------------------------------------------------------
  always
    begin : sys_monitor
      cycle_ctr = cycle_ctr + 1;
      #(CLK_PERIOD);
      if (tb_monitor)
        begin
          // dump_dut_state();
        end
    end


  //----------------------------------------------------------------
  // display_test_result()
  //
  // Display the accumulated test results.
  //----------------------------------------------------------------
  task display_test_result;
    begin
      $display("");

      if (error_ctr == 0) begin
        $display("--- All %02d test cases completed successfully", tc_ctr);
      end else begin
        $display("--- %02d tests completed - %02d test cases did not complete successfully.",
                 tc_ctr, error_ctr);
      end
    end
  endtask // display_test_result


  //----------------------------------------------------------------
  // snow_vi_core_test
  //----------------------------------------------------------------
  initial
    begin : snow_vi_core_test
      $display("   -= Testbench for snow_vi_core started =-");
      $display("     ====================================");
      $display("");

      init_sim();
      reset_dut();
      test_name_version();
      display_test_result();
      $display("");
      $display("   -= Testbench for snow_vi_core completed =-");
      $display("     ======================================");
      $display("");
      $finish;
    end // snow_vi_core_test

endmodule // tb_snow_vi_core
