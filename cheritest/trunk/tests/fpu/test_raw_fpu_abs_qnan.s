#-
# Copyright (c) 2014 Michael Roe
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

.set mips64
.set noreorder
.set nobopt
.set noat

#
# Test abs.s of a "Quiet Not a Number" (QNaN)
#
# In the MIPS spec, abs is what the IEEE floating point standard calls
# 'arithmetic'.
#
		.text
		.global start
		.ent start
start:     
		mfc0 $t0, $12
		li $t1, 1 << 29		# Enable CP1
		or $t0, $t0, $t1    
		dli $t1, 1 << 26        # Put FPU into 64 bit mode
		or $t0, $t0, $t1
		mtc0 $t0, $12 

		nop
		nop
		nop
		nop

		cfc1	$t0, $31		# FCSR
		dli	$t1, 1 << 19		# ABS2008
		nor	$t1, $t1, $t1
		and	$t0, $t0, $t1
		ctc1	$t0, $31

		nop
		nop
		nop
		nop

		lui $t0, 0xff90		# QNaN, with the sign bit set
		mtc1 $t0, $f1

		abs.s $f1, $f1
		mfc1 $a0, $f1

		lui $t0, 0xfff1		# QNaN, with the sign bit set
		dsll $t0, $t0, 32
		dmtc1 $t0, $f2

		abs.d $f2, $f2
		dmfc1 $a2, $f2

		cfc1 $a1, $31           # FCSR
		dsrl $a1, $a1, 19       # ABS2008 bit. 1 if abs behaves as in 
		andi $a1, 0x01          # IEEE 754-2008, 0 for legacy MIPS.

		# Dump registers on the simulator (gxemul dumps regs on exit)

		mtc0 $at, $26
		nop
		nop

		# Terminate the simulator
		mtc0 $at, $23
end:
		b end
		nop

.end start
