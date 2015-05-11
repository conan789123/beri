#!/usr/bin/perl
#
# Copyright (c) 2011 Simon W. Moore
# Copyright (c) 2011 Robert N. M. Watson
# All rights reserved.
#
# This software was developed by SRI International and the University of
# Cambridge Computer Laboratory under DARPA/AFRL contract FA8750-10-C-0237
# ("CTSRD"), as part of the DARPA CRASH research programme.
#
# @BERI_LICENSE_HEADER_START@
#
# Licensed to BERI Open Systems C.I.C. (BERI) under one or more contributor
# license agreements.  See the NOTICE file distributed with this work for
# additional information regarding copyright ownership.  BERI licenses this
# file to you under the BERI Hardware-Software License, Version 1.0 (the
# "License"); you may not use this file except in compliance with the
# License.  You may obtain a copy of the License at:
#
#   http://www.beri-open-systems.org/legal/license-1-0.txt
#
# Unless required by applicable law or agreed to in writing, Work distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations under the License.
#
# @BERI_LICENSE_HEADER_END@
#
# ============================================================================
# SOPCINFO files to C header with addresses bases
# ============================================================================
# 
# Approach:
# The .sopcinfo files are in XML which is crudely parsed to extract the name
# and base address.
# 
# Usage:
# When run in the main cheri trunk directory, will create parameter files for
# both Bluespec and C.  In the future, these files might become more
# interesting, but for now just contain the JTAG base.

use strict;

my @file;
my $file;

my $jtagBase="";
my $loopBackUARTBase="7f001000";
my $ethernetBase="";

&loadfile("../DE4_SOPC.sopc");
if ($file =~ /jtag\_uart\_MIPS\.avalon\_jtag\_slave.{1,200}baseAddress\" value\=\"0x([0123456789abcdef]+)\"/s) {
	$jtagBase=int($1);
} else {
	# XXXRW: Is this what we actually want?
	$jtagBase="7f000000";
}

#
# Generate parameters.h from sopc data.
#
open(OUT, ">include/parameters.h") || die "jtag_base.h";
print OUT<<end_of_file;
/*-
 * WARNING:
 *
 * This file has been automatically generated by $0.
 * Do not modify it by hand.
 */

#define	JTAG_UART_BASE	(0x90000000${jtagBase}ULL)
#define	LOOPBACK_UART_BASE	(0x90000000${loopBackUARTBase}ULL)
end_of_file
close(OUT);

$jtagBase = hex $jtagBase;
$jtagBase = $jtagBase/32;

$loopBackUARTBase = hex $loopBackUARTBase;
$loopBackUARTBase = $loopBackUARTBase/32;

#
# Generate parameters.bsv from sopc data.
#
open(OUT, ">parameters.bsv") || die "parameters.bsv";
print OUT<<end_of_file;
/*****************************************************************************

 WARNING:

 This file has been automatically generated by $0.
 Do not modify it by hand.

 *****************************************************************************/

`define AVN_JTAG_UART_BASE $jtagBase
`define LOOPBACK_UART_BASE $loopBackUARTBase
end_of_file

exit;


# ---------------------------------- Subroutines --------------------------------
# loadfile: open "filename" (the parameter) and put it into into $file
sub loadfile {
	open(IN, "<@_"); 
	@file=<IN>;
	$file = join(/ /, @file); 
	close(IN);
}

# savefile: save $file into "filename" (the parameter), overwriting it. 
sub savefile {
	open(OUT, ">@_"); 
	print OUT $file;
	close(OUT);
}