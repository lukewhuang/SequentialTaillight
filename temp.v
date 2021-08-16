module controller(input clk,
  input dimclk,
  input rst,
  input left,
  input right,
  input brake,
  input hazard,
  input runlight,
  output [5:0] lights
);
 
  // order for literals is RcRbRaLaLbLc
  reg [5:0] pattern = 6'b0;
 
  // instantiate dimmer module
  dimmer dim(.pattern(pattern),
    .dim_clk(dimclk),
    .run_light(runlight),
    .out(lights));
 
// async reset switch 
  always@(rst) begin
    if (rst == 1'b1) begin
      pattern = 6'b0;
      wait (rst == 1'b1);
    end
  end
 
  // right side 
  always@(posedge clk) begin
    // Rc
    pattern[5] <= (brake && left && pattern[3] && pattern[4]) ||
      (brake && left && ! pattern[4] && ! pattern[5]) ||
      (brake && pattern[3] && pattern[4] && ! right) ||
      (brake && ! pattern[4] && ! pattern[5] && ! right) ||
      (! brake && hazard && ! pattern[3] && ! pattern[4] && ! pattern[5]) ||
      (hazard && pattern[3] && pattern[4] && ! pattern[5]) ||
      (left && ! pattern[3] && ! pattern[4] && ! pattern[5] && right) ||
      (pattern[3] && pattern[4] && ! pattern[5] && right);
    // Rb
    pattern[4] <= (brake && left && pattern[3] && pattern[4]) ||
      (brake && pattern[3] && pattern[4] && ! right) ||
      (brake && pattern[3] && ! pattern[5]) ||
      (brake && ! pattern[4] && ! pattern[5] && ! right) ||
      (! brake && hazard && ! pattern[3] && ! pattern[4] && ! pattern[5])
      || (hazard && pattern[3] && pattern[4] && ! pattern[5]) ||
      (! hazard && ! left && pattern[3] && ! pattern[5] && right) ||
      (left && ! pattern[3] && ! pattern[4] && ! pattern[5] && right) ||
      (pattern[3] && pattern[4] && ! pattern[5] && right);
    // Rc
    pattern[3] <= (brake && left && pattern[3] && pattern[4]) ||
      (brake && pattern[3] && pattern[4] && ! right) ||
      (brake && ! pattern[4] && ! pattern[5]) ||
      (hazard && pattern[3] && pattern[4] && ! pattern[5]) ||
      (hazard && ! pattern[3] && ! pattern[4] && ! pattern[5]) ||
      (! hazard && ! left && ! pattern[4] && ! pattern[5] && right) ||
      (pattern[3] && pattern[4] && ! pattern[5] && right) ||
      (! pattern[3] && ! pattern[4] && ! pattern[5] && right);
  end
  // left side
  always@(posedge clk) begin
    // La
    pattern[2] <= (brake && right && pattern[2] && pattern[1]) ||
      (brake && pattern[2] && pattern[1] && ! left) ||
      (brake && ! pattern[1] && ! pattern[0]) ||
      (hazard && pattern[2] && pattern[1] && ! pattern[0]) ||
      (hazard && ! pattern[2] && ! pattern[1] && ! pattern[0]) ||
      (! hazard && ! right && ! pattern[1] && ! pattern[0] && left) ||
      (pattern[2] && pattern[1] && ! pattern[0] && left) ||
      (! pattern[2] && ! pattern[1] && ! pattern[0] && left);
    // Lb
    pattern[1] <= (brake && right && pattern[2] && pattern[1]) ||
      (brake && pattern[2] && pattern[1] && ! left) ||
      (brake && pattern[2] && ! pattern[0]) ||
      (brake && ! pattern[1] && ! pattern[0] && ! left) ||
      (! brake && hazard && ! pattern[2] && ! pattern[1] && ! pattern[0]) ||
      (hazard && pattern[2] && pattern[1] && ! pattern[0]) ||
      (! hazard && ! right && pattern[2] && ! pattern[0] && left) ||
      (right && ! pattern[2] && ! pattern[1] && ! pattern[0] && left) ||
      (pattern[2] && pattern[1] && ! pattern[0] && left);
    // Lc
    pattern[0] <= (brake && right && pattern[2] && pattern[1]) ||
      (brake && right && ! pattern[1] && ! pattern[0]) ||
      (brake && pattern[2] && pattern[1] && ! left) ||
      (brake && ! pattern[1] && ! pattern[0] && ! left) ||
      (! brake && hazard && ! pattern[2] && ! pattern[1] && ! pattern[0]) ||
      (hazard && pattern[2] && pattern[1] && ! pattern[0]) ||
      (right && ! pattern[2] && ! pattern[1] && ! pattern[0] && left) ||
      (pattern[2] && pattern[1] && ! pattern[0] && left);
  end
endmodule
