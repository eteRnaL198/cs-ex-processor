#!/usr/bin/perl
$filename = $ARGV[0];
unless(-e $filename){die "File not found\n";}
unless(open(RFILE, $filename)){
	die "Can't open $filename\n";
} else{
	unless(open(WFILE,">rom.v")){
		die "Can't open rom.v\n";
	} else{

print WFILE <<TOP_OF_ROM;
`timescale 1ns/1ns
module rom(adrs, dout);
	input  [ 8:0] adrs;
	output [31:0] dout;
	reg    [31:0] dout;
	
	always@(adrs) begin
		case(adrs)
TOP_OF_ROM
		$line=<RFILE>;
		$line=<RFILE>;
		while($line=<RFILE>){
			chomp($line);
			$line =~ /(\w+)\s+(\w+)\s+(.*)/;
			$adrs = $1;
			$data = $2;
			$str  = $3;
			$adrs =~ s/0x00400//;
			$adrs = hex("$adrs") / 4;
			$adrs = sprintf("9'h%03x",$adrs);
			#$adrs = "9'd" . $adrs;
			$data =~ s/0x/32'h/;
			$str  =~ s/.{25}//;
			print WFILE "\t\t\t$adrs : dout <= $data; // $str\n";
		}
print WFILE <<BOTTOM_OF_ROM;
			default : dout <= 32'h0;
		endcase
	end
endmodule
BOTTOM_OF_ROM
	}
}
close(WFILE);
close(RFILE);
