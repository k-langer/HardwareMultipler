#!/usr/bin/perl
use strict;
use warnings;

print "module multipler (\n";
print "    input  [31:0]  op0,\n";
print "    input  [31:0]  op1,\n";
print "    output [63:0]  res \n";
print ");\n";

print "wire [5:0] P[63:0];\n";
print "wire [31:0] p0,";
for (my $i=1; $i < 32; $i++) {
    print ",p".$i," ";
}
print ";\n";

for (my $i=0; $i < 32; $i++) {
    printf "assign p%d[31:0] = {32{op0[%d]}} & op1[31:0];\n",$i,$i;
}

my $product_lo = 0 ; 
my $product_hi = 0; 
my $bit_hi  = 0; 
for (my $i=0; $i < 64; $i++) {
    if ($bit_hi > 31) {
        $bit_hi = 31;  
    }   
    if ($i < 32) {
        $product_lo =  0;
        $product_hi = $i;
    } else {
        $product_lo =  $i-31;
        $product_hi = 31;
    } 
    my $bit = $bit_hi; 
    printf "assign P[%d] =",$i;
    for (my $j = $product_lo; $j <= $product_hi; $j++) {
        printf " p%d[%d] + ",$j,$bit;
        $bit = $bit - 1; 
    }
    if ( $i == 0 ) { 
        print " 0;\n"; 
    } else { 
        printf "P[%d][5:1];\n",$i-1;
    }
    $bit_hi = $bit_hi + 1; 
} 
print "assign       res[63:0] = {P[63][0]";
for (my $i = 62; $i >=0; $i--) {
    printf ",P[%d][0]",$i;
}
print "};\nendmodule;\n"; 
