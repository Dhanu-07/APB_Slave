module apb_slave(input wire pclk,input wire prstn,input wire psel,input wire penable,input wire pwrite,input wire [31:0] paddr,input wire [31:0] pwdata,output reg [31:0] prdata,output reg pready, output reg pslverr);

reg [31:0] mem [0:255];
always @(posedge pclk or negedge prstn)
begin
if(!prstn) begin
pready<=0;
pslverr<=0;
prdata<=32'b0;
end else begin
pready<=0;
pslverr<=0;
if(psel && penable) begin
pready<=1;
if(pwrite)
begin
mem[paddr]<=pwdata;
end else begin
prdata<=mem[paddr];
end
end
end
end
endmodule
