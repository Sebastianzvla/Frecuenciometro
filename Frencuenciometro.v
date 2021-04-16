module Frecuenciometro(clk, signal);

  input clk;                         //Reloj FPGA a 10MHz
  input signal;                      // Señal de entrada en P97
output [6:0] vSevenseg;

 reg [6:0] vSevenseg;

  /*output reg [1:4]d;                 
  output reg [7:0]z;*/                 
  
  reg [19:0]counter = 0;             // contador posEdge
  reg [19:0]counted = 10000;         //Últimos posEdges contados

  reg [15:0] period = 1000;          //Periodo calculado en microsegundos
  reg isLowPeriod   = 0;             //Verdadero si el período <1000

  reg [7:0] x;                       //BCD

  reg [5:0]signalPast = 6'b010101;   //señaliza los últimos 6 valores

  /*Variables utilizadas para mostrar números en 7segs
  reg [15:0] c=16'b0;
  reg [3:0] w;*/
  
  
  // cuaerpo del codigo 
  always @(posedge clk) begin

    // counter logico
    if (signalPast == 6'b000000 && signal == 1) begin     //if input signal is at posEdge
      counted = counter;                                  //save counter value
      counter <= 0;                                       //reset counter
    end else begin                                        //else
      counter <= counter + 1;                             //count
    end
    
    //Almacenamiento de los últimos 6 valores de la señal
    signalPast = signalPast << 1;
    signalPast[0] = signal;
    
    
    //señal para mostrar números en 7seg
    //c <= c+1;
    
  end

  
  //Period Compu
  always @(counted) begin
  
    period = counted / 10;
    isLowPeriod = period < 1000;
  
  end
  
  
  //BCD Compu
  always @(period) begin
  
    if (isLowPeriod) begin
                                                    //957 -> .95
      x[7:4] <= (period       - period % 100)/100;
      x[3:0] <= (period % 100 - period % 10 )/10 ;
    end 
	 else if 
		x[7:4] <= (period       - period % 10)/10; 
      x[3:0] <= (period % 10 - period % 1 )/1 ;
	 end
	 else begin
                                                    //3589 -> 3.5
      x[7:4] <= (period        - period % 1000)/1000;
      x[3:0] <= (period % 1000 - period % 100 )/100 ;
    end

 

  
  
	//Mostrar en 7seg
	always @*
		case (x)
		4'h0: vSevenseg = 7'b1000000;
		4'h1: vSevenseg = 7'b1111001;
		4'h2: vSevenseg = 7'b0100100;
		4'h3: vSevenseg = 7'b0110000;
		4'h4: vSevenseg = 7'b0011001;
		4'h5: vSevenseg = 7'b0010010;
		4'h6: vSevenseg = 7'b0000010;
		4'h7: vSevenseg = 7'b1111000;
		4'h8: vSevenseg = 7'b0000000;
		4'h9: vSevenseg = 7'b0010000;
		4'hA: vSevenseg = 7'b0001000;
		4'hB: vSevenseg = 7'b0000011;
		4'hC: vSevenseg = 7'b1000110;
		4'hD: vSevenseg = 7'b0100001;
		4'hE: vSevenseg = 7'b0000110;
		4'hF: vSevenseg = 7'b0001110;

		endcase
  

endmodule 