#-
# Copyright (c) 2013 Michael Roe
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

from beritest_tools import BaseBERITestCase
from nose.plugins.attrib import attr

class test_raw_fpu_cvt_d32(BaseBERITestCase):

    @attr('float32')
    def test_raw_fpu_cvt_d32(self):
        '''Test can convert from double to single precision when in 32-bit mode'''
        self.assertRegisterMaskEqual(self.MIPS.a1, 0xfffffffe, 0x3e2aaaaa, "Failed to convert double to single precision")

        self.assertRegisterMaskEqual(self.MIPS.a1, 0x1, 1, "Failed to round to nearest when converting from double precision to single precision")

    @attr('float32') 
    def test_raw_fpu_cvt_d32_mode(self):
        '''Test that the rounding mode is round to nearest even'''
        self.assertRegisterEqual(self.MIPS.a0, 0, "Floating point rounding mode is not round to nearest even")
