module tailights_tb () ;
  // declare variables
  reg clk = 0;
  reg dimclk = 0;
  reg rst , left , right , brake , hazard , runlight ;
  wire [5:0] lights;
  initial begin
    forever begin
      clk <= ~clk;
      #5;
    end
  end
  initial begin
    forever begin
      dimclk <= ~dimclk;
      #0.5;
    end
  end
  controller ctl (.clk(clk) ,
    . dimclk(dimclk),
    . rst(rst),
    . left(left),
    . right(right),
    . brake(brake),
    . hazard (hazard),
    . runlight(runlight),
    . lights(lights)
  ) ;
  initial begin
    $dumpfile ("dump.vcd") ;
    $dumpvars;
    // set inputs
    rst <= 1'b1;
    left <= 1'b0;
    right <= 1'b0;
    brake <= 1'b0;
    hazard <= 1'b0;
    runlight <= 1'b0;
    #20;
    // set inputs
    rst <= 1'b0 ;
    left <= 1'b1 ;
    #40;
    // set inputs
    left <= 1'b0 ;
    right <= 1'b1 ;
    #40;
    // set inputs
    brake <= 1'b1 ;
    #40;
    // set inputs
    right <= 1'b0 ;
    left <= 1'b1 ;
    #40;
    // set inputs
    right <= 1'b1 ;
    #40;
    // set inputs
    brake <= 1'b0 ;
    #40;
    // set inputs
    right <= 1'b0 ;
    left <= 1'b0 ;
    #20;
    // set inputs
    hazard <= 1'b1 ;
    #40;
    // set inputs
    left <= 1'b0 ;
    right <= 1'b0 ;
    brake <= 1'b0 ;
    hazard <= 1'b0 ;
    runlight <= 1'b1 ;
    #20;
    // set inputs
    rst <= 1'b0 ;
    left <= 1'b1 ;
    #40;
    // set inputs
    left <= 1'b0 ;
    right <= 1'b1 ;
    #40;
    // set inputs
    brake <= 1'b1 ;
    #40;
    // set inputs
    right <= 1'b0 ;
    left <= 1'b1 ;
    #40;
    // set inputs
    right <= 1'b1 ;
    #40;
    // set inputs
    brake <= 1'b0 ;
    #40;
    // set inputs
    right <= 1'b0 ;
    left <= 1'b0 ;
    #20;
    // set inputs
    hazard <= 1'b1 ;
    #40;
    // end simulation
    $finish ;
  end
endmodule