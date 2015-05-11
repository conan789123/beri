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

#
# Test exception priorities in csealcode.
#

class test_cp2_x_csealcode_priority(BaseBERITestCase):

    @attr('capabilities')
    def test_cp2_x_csealcode_priority_1(self):
        '''Test csealcode raised a C2E exception when did not have Permit_Seal or Permit_Execute'''
        self.assertRegisterEqual(self.MIPS.a2, 1,
            "csealcode did not raise an exception when did not have Permit_Seal or Permit_Execute")

    @attr('capabilities')
    def test_cp2_x_csealdata_priority_2(self):
        '''Test capability cause is set correctly when csealcode does not have Permit_seal or Permit_Execute'''
        self.assertRegisterEqual(self.MIPS.a3, 0x1701,
            "csealdata did not set capability cause correctly when didn't have Permit_Seal or Permit_Execute")