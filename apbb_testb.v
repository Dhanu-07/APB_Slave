module apb_slave_tb;

reg pclk;
reg prstn;
reg psel;
reg penable;
reg pwrite;
reg [31:0] paddr;
reg [31:0] pwdata;
wire [31:0] prdata;
wire pready;
wire pslverr;

apb_slave uut(.pclk(pclk),.prstn(prstn),.psel(psel),.penable(penable),.pwrite(pwrite),.paddr(paddr),.pwdata(pwdata),.prdata(prdata),.pready(pready),.pslverr(pslverr));

initial begin
$dumpfile("apb_slave.vcd");
$dumpvars(0,apb_slave_tb);
end

initial begin
pclk=0;
forever # 5 pclk=~pclk;
end

task apb_write(input [31:0] address, input [31:0] data);
begin
psel=1;
pwrite=1;
paddr=address;
pwdata=data;
#10 penable=1;
#10 penable=0;
psel=0;
end
endtask

task apb_read(input [31:0] address, output [31:0] data);
begin
psel=1;
pwrite=0;
paddr=address;
#10 penable=1;
#10 penable=0; psel=0;
#10 data=prdata;
end
endtask

initial begin
prstn=0;
psel=0;
penable=0;
pwrite=0;
paddr=32'h0;
pwdata=32'h0;
#10 prstn=1;

//test case 1
apb_write(32'h10,32'hdeadbeef);
apb_read(32'h10,pwdata);
$display("Test case 1: Read data =%h",pwdata);

//test case 2
apb_write(32'h20,32'hcafebabe);
apb_read(32'h20,pwdata);
$display("Test case 2: Read data = %h",pwdata);

//test case 3
apb_write(32'h30,32'h12345678);
apb_read(32'h10,pwdata);
$display("Test case 3: Read data= %h",pwdata);

//test case 4
apb_write(32'h40,32'h11111111);
apb_write(32'h50,32'h22222222);
apb_write(32'h60,32'h33333333);

//test case 5
apb_read(32'h40,pwdata);
$display(" Test case 5: Read data = %h",pwdata);
apb_read(32'h50,pwdata);
$display(" Test case 5: Read data = %h",pwdata);
apb_read(32'h60,pwdata);
$display(" Test case 5: Read data = %h",pwdata);

//test case 6
apb_write(32'h70,32'hfeedface);
apb_read(32'h70,pwdata);
$display("Test case 6: Read data= %h",pwdata);

//test case 7
apb_write(32'h80,32'haaaaaaaa);
apb_read(32'h80,pwdata);
$display("Test case 7: Read data= %h",pwdata);

//test case 8
apb_write(32'h10,32'h55555555);
apb_read(32'h10,pwdata);
$display("Test case 8: Read data=%h",pwdata);

//test case 9
apb_read(32'h90,pwdata);
$display("Test case 9: Read data=%h",pwdata);

//test case 10
apb_write(32'hA0,32'h99999999);
apb_read(32'hA0,pwdata);
$display("Test case 10: Read data= %h",pwdata);

#100 $finish;
end
endmodule

