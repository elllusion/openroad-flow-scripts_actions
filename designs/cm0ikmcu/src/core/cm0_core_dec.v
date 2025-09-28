//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited.
//
//            (C) COPYRIGHT 2008-2010 ARM Limited.
//                ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited.
//
//      SVN Information
//
//      Checked In          : $Date: 2009-06-25 15:36:15 +0100 (Thu, 25 Jun 2009) $
//
//      Revision            : $Revision: 111863 $
//
//      Release Information : Cortex-M0-AT510-r0p0-03rel0
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// CORTEX-M0 CORE DECODER
//-----------------------------------------------------------------------------

// BEFORE MODIFYING REFER TO README

module cm0_core_dec
   (output wire [ 7:0] ex_ctl_nxt,
    output wire        ex_last_nxt,
    output wire        atomic_nxt,
    output wire        alu_en_nxt,
    output wire        spu_en_nxt,
    output wire        b_cond_de,
    output wire        branch_de,
    output wire        aux_en,
    output wire        aux_tbit,
    output wire        aux_align,
    output wire        aux_sel_addr,
    output wire        aux_sel_xpsr,
    output wire        aux_sel_iaex,
    output wire        psp_sel_en,
    output wire        psp_sel_nxt,
    output wire        psp_sel_auto,
    output wire        ra_addr_en,
    output wire        ra_sel_z2_0,
    output wire        ra_sel_7_2_0,
    output wire        ra_sel_z5_3,
    output wire        ra_sel_z10_8,
    output wire        ra_sel_sp,
    output wire        ra_sel_pc,
    output wire        rb_addr_en,
    output wire        rb_sel_z5_3,
    output wire        rb_sel_z8_6,
    output wire        rb_sel_6_3,
    output wire        rb_sel_3_0,
    output wire        rb_sel_wr_ex,
    output wire        rb_sel_list,
    output wire        rb_sel_sp,
    output wire        rb_sel_aux,
    output wire        wr_addr_raw_en,
    output wire        wr_sel_z2_0,
    output wire        wr_sel_z10_8,
    output wire        wr_sel_11_8,
    output wire        wr_sel_10_7,
    output wire        wr_sel_7777,
    output wire        wr_sel_3_0,
    output wire        wr_sel_list,
    output wire        wr_sel_excp,
    output wire        im74_en,
    output wire        im74_sel_6_3,
    output wire        im74_sel_z10,
    output wire        im74_sel_z10_9,
    output wire        im74_sel_z6_4,
    output wire        im74_sel_7_4,
    output wire        im74_sel_list,
    output wire        im74_sel_excp,
    output wire        im74_sel_exnum,
    output wire        im30_en,
    output wire        im30_sel_2_0z,
    output wire        im30_sel_9_6,
    output wire        im30_sel_8_6z,
    output wire        im30_sel_3_0,
    output wire        im30_sel_z8_6,
    output wire        im30_sel_list,
    output wire        im30_sel_incr,
    output wire        im30_sel_one,
    output wire        im30_sel_seven,
    output wire        im30_sel_eight,
    output wire        im30_sel_exnum,
    output wire        wr_en,
    output wire        wr_use_wr,
    output wire        wr_use_ra,
    output wire        wr_use_lr,
    output wire        wr_use_sp,
    output wire        wr_use_list,
    output wire        ra_use_aux,
    output wire        stk_align_en,
    output wire        txev,
    output wire        wfe_execute,
    output wire        wfi_execute,
    output wire        ex_idle,
    output wire        dbg_halt_ack,
    output wire        bkpt_ex,
    output wire        lockup,
    output wire        svc_request,
    output wire        hdf_request_raw,
    output wire        int_taken,
    output wire        int_return,
    output wire        instr_rfi,
    output wire        exnum_en,
    output wire        exnum_sel_bus,
    output wire        exnum_sel_int,
    output wire        nzflag_en,
    output wire        cflag_en,
    output wire        vflag_en,
    output wire        msr_en,
    output wire        cps_en,
    output wire        addr_ex,
    output wire        addr_ra,
    output wire        addr_agu,
    output wire        hwrite,
    output wire        bus_idle,
    output wire        addr_phase,
    output wire        data_phase,
    output wire        iaex_agu,
    output wire        iaex_spu,
    output wire        iaex_en,
    output wire        interwork,
    output wire [19:0] alu_ctl_raw,
    output wire [ 1:0] ls_size_raw,
    output wire        mul_ctl,
    output wire [32:0] spu_ctl_raw,
    input  wire [15:0] opcode,
    input  wire        special,
    input  wire        dbg_halt_req,
    input  wire        dbg_op_run,
    input  wire        debug_en,
    input  wire        int_preempt,
    input  wire        int_delay,
    input  wire        valid_rfi,
    input  wire        sleep_rfi,
    input  wire        wfe_adv,
    input  wire        wfi_adv,
    input  wire        atomic,
    input  wire        hdf_escalate,
    input  wire        svc_escalate,
    input  wire        cfg_smul,
    input  wire        smul_last,
    input  wire        cc_pass,
    input  wire        cfg_be,
    input  wire [ 1:0] addr_last,
    input  wire        data_abort,
    input  wire        list_empty,
    input  wire        list_elast,
    input  wire        ex_last,
    input  wire [ 7:0] ex_ctl);

   // ------------------------------------------------------------
   // Declare local wires for common sub-expressions
   // ------------------------------------------------------------

   wire   net_1, net_1003, net_1005, net_1011, net_1015, net_1019,
          net_102, net_1022, net_1028, net_1036, net_1039,
          net_1047, net_1059, net_1066, net_107, net_1073,
          net_1075, net_1078, net_1079, net_1081, net_1084,
          net_1090, net_1100, net_1113, net_1117, net_112,
          net_1120, net_1121, net_1123, net_113, net_1136,
          net_115, net_1150, net_1161, net_117, net_1173,
          net_1177, net_1195, net_1199, net_120, net_1217,
          net_122, net_1222, net_1237, net_1244, net_1252,
          net_1255, net_1256, net_126, net_127, net_1274,
          net_1282, net_1286, net_129, net_1292, net_1296, net_13,
          net_130, net_1304, net_1306, net_1316, net_1317,
          net_1320, net_1328, net_1330, net_1333, net_1334,
          net_1348, net_135, net_1357, net_136, net_1362,
          net_1367, net_137, net_1370, net_138, net_1382,
          net_1383, net_1386, net_1391, net_1392, net_1393,
          net_1396, net_1399, net_14, net_140, net_1408, net_141,
          net_1419, net_1421, net_143, net_144, net_1452,
          net_1458, net_1460, net_1465, net_1469, net_147,
          net_148, net_150, net_1507, net_1517, net_1521,
          net_1524, net_1528, net_153, net_154, net_1543,
          net_1547, net_1558, net_1574, net_1578, net_158,
          net_1589, net_1594, net_1603, net_161, net_1617,
          net_1620, net_1655, net_1701, net_1704, net_172,
          net_1723, net_1727, net_173, net_1735, net_175,
          net_1758, net_1767, net_1783, net_1797, net_18,
          net_1807, net_181, net_1815, net_182, net_1827,
          net_1845, net_1853, net_1854, net_1878, net_1881,
          net_1882, net_189, net_19, net_191, net_1921, net_1922,
          net_1961, net_197, net_1973, net_1975, net_198, net_199,
          net_20, net_2004, net_2014, net_2025, net_204, net_205,
          net_208, net_2089, net_209, net_2094, net_2096, net_21,
          net_210, net_211, net_2126, net_2163, net_218, net_2182,
          net_219, net_2193, net_2199, net_22, net_221, net_2254,
          net_2295, net_2296, net_2298, net_2299, net_23,
          net_2300, net_2301, net_2302, net_2303, net_2304,
          net_2305, net_2306, net_2307, net_2308, net_2309,
          net_235, net_238, net_24, net_240, net_243, net_246,
          net_254, net_257, net_258, net_259, net_26, net_264,
          net_268, net_269, net_27, net_273, net_274, net_275,
          net_28, net_281, net_282, net_283, net_285, net_286,
          net_288, net_29, net_292, net_296, net_298, net_299,
          net_30, net_302, net_303, net_304, net_306, net_312,
          net_313, net_314, net_316, net_318, net_321, net_325,
          net_327, net_328, net_33, net_331, net_333, net_334,
          net_338, net_340, net_342, net_349, net_353, net_356,
          net_357, net_36, net_363, net_364, net_365, net_368,
          net_37, net_371, net_372, net_377, net_378, net_38,
          net_382, net_384, net_385, net_386, net_389, net_39,
          net_390, net_394, net_396, net_4, net_40, net_403,
          net_407, net_41, net_411, net_415, net_418, net_42,
          net_420, net_427, net_43, net_433, net_434, net_436,
          net_439, net_44, net_443, net_449, net_45, net_451,
          net_455, net_457, net_459, net_46, net_460, net_467,
          net_468, net_47, net_470, net_473, net_476, net_477,
          net_480, net_483, net_486, net_489, net_490, net_495,
          net_498, net_499, net_5, net_502, net_505, net_51,
          net_510, net_513, net_515, net_517, net_52, net_522,
          net_525, net_530, net_533, net_536, net_538, net_54,
          net_545, net_546, net_547, net_549, net_55, net_551,
          net_554, net_56, net_560, net_562, net_570, net_573,
          net_574, net_575, net_579, net_580, net_59, net_590,
          net_594, net_6, net_60, net_601, net_604, net_605,
          net_606, net_608, net_609, net_61, net_610, net_613,
          net_614, net_62, net_620, net_623, net_631, net_634,
          net_635, net_636, net_639, net_64, net_642, net_646,
          net_647, net_65, net_651, net_652, net_653, net_655,
          net_658, net_667, net_67, net_670, net_673, net_674,
          net_676, net_679, net_68, net_680, net_681, net_684,
          net_686, net_687, net_689, net_692, net_695, net_696,
          net_7, net_70, net_701, net_704, net_71, net_713,
          net_715, net_718, net_719, net_72, net_723, net_73,
          net_732, net_733, net_737, net_741, net_743, net_745,
          net_75, net_754, net_758, net_76, net_770, net_771,
          net_774, net_78, net_780, net_782, net_784, net_788,
          net_794, net_798, net_8, net_803, net_815, net_816,
          net_819, net_820, net_823, net_825, net_826, net_834,
          net_835, net_850, net_853, net_857, net_86, net_862,
          net_864, net_87, net_879, net_886, net_888, net_89,
          net_890, net_891, net_897, net_898, net_908, net_912,
          net_917, net_921, net_926, net_927, net_93, net_930,
          net_932, net_938, net_951, net_952, net_954, net_957,
          net_958, net_96, net_961, net_968, net_969, net_97,
          net_971, net_977, net_98, net_980, net_986, net_990,
          net_991, net_997;

   // ------------------------------------------------------------
   // Define common sub-expressions
   // ------------------------------------------------------------

   assign net_1    = ~net_328;
   assign net_1003 = (spu_ctl_raw[29] & spu_ctl_raw[28]);
   assign net_1005 = ((ex_ctl[7] | (int_preempt |
               (~spu_ctl_raw[21] | ~net_498))) & (~alu_ctl_raw[0]
               | ~net_172));
   assign net_1011 = (~net_1059 | ~net_459);
   assign net_1015 = (~(opcode[10] & (opcode[8] | net_977)) &
               ~(~net_28 & ~net_1419));
   assign net_1019 = (opcode[8] | opcode[6]);
   assign net_102  = (rb_sel_sp & net_2295);
   assign net_1022 = (net_1961 | net_1921);
   assign net_1028 = (~rb_sel_z5_3 | ~net_286);
   assign net_1036 = (int_delay & net_1807);
   assign net_1039 = (list_empty | net_43);
   assign net_1047 = (opcode[14] & net_480);
   assign net_1059 = (opcode[10] & opcode[9]);
   assign net_1066 = (net_1161 | net_1758);
   assign net_107  = (spu_ctl_raw[21] & net_2300);
   assign net_1073 = (ex_ctl[3] & net_2298);
   assign net_1075 = (~int_preempt & ~wfi_adv);
   assign net_1078 = (net_816 & net_2295);
   assign net_1079 = (~ex_ctl[6] | ~rb_sel_wr_ex);
   assign net_1081 = ((net_1735 & net_609) & (net_1521 |
               net_2298));
   assign net_1084 = (~spu_ctl_raw[29] | ~net_745);
   assign net_1090 = (~ex_ctl[3] | ~net_820);
   assign net_1100 = (~net_269 | ~net_286);
   assign net_1113 = (~opcode[6] & ~net_28);
   assign net_1117 = (~rb_sel_z5_3 | ~net_254);
   assign net_112  = (~ex_ctl[0] | ~spu_ctl_raw[29]);
   assign net_1120 = (rb_sel_sp & spu_ctl_raw[28]);
   assign net_1121 = (~opcode[11] & ~opcode[10]);
   assign net_1123 = (~net_286 | ~net_574);
   assign net_113  = (~ex_ctl[1] & ~net_2300);
   assign net_1136 = (opcode[12] & net_2308);
   assign net_115  = (~ex_ctl[1] & ~ex_ctl[4]);
   assign net_1150 = (~net_719 | ~net_499);
   assign net_1161 = (opcode[3] | (opcode[2] | net_620));
   assign net_117  = (ex_ctl[1] & ex_ctl[7]);
   assign net_1173 = (~opcode[9] & ~net_19);
   assign net_1177 = (opcode[6] | net_1370);
   assign net_1195 = (ex_ctl[7] | net_47);
   assign net_1199 = (~data_abort | ~net_2304);
   assign net_120  = (spu_ctl_raw[29] & net_2295);
   assign net_1217 = (~net_26 & ~net_1419);
   assign net_122  = (~ex_ctl[6] | ~net_368);
   assign net_1222 = (opcode[5] & opcode[4]);
   assign net_1237 = (~net_2004 | ~net_33);
   assign net_1244 = (~ex_ctl[5] | ~net_2300);
   assign net_1252 = (wr_use_sp & net_2296);
   assign net_1255 = (~net_2303 | ~net_551);
   assign net_1256 = (~ex_ctl[0] | ~(net_1382 & spu_ctl_raw[32]));
   assign net_126  = (~net_115 | ~net_378);
   assign net_127  = (net_2299 | net_316);
   assign net_1274 = (data_abort & (ex_ctl[7] & spu_ctl_raw[28]));
   assign net_1282 = (~opcode[15] & ~opcode[14]);
   assign net_1286 = (net_2296 & spu_ctl_raw[28]);
   assign net_129  = (ex_ctl[7] & net_211);
   assign net_1292 = (~opcode[15] & ~net_477);
   assign net_1296 = (net_113 & net_209);
   assign net_13   = ~net_1655;
   assign net_130  = (ex_ctl[0] & net_1286);
   assign net_1304 = (~int_preempt & ~net_2295);
   assign net_1306 = (~ex_ctl[4] | ~spu_ctl_raw[32]);
   assign net_1316 = (~data_abort & ~net_36);
   assign net_1317 = (~ex_ctl[1] & ~valid_rfi);
   assign net_1320 = (net_658 & (net_538 & net_864));
   assign net_1328 = (net_1 & net_2307);
   assign net_1330 = (opcode[6] | opcode[10]);
   assign net_1333 = (net_1382 & net_205);
   assign net_1334 = (net_525 & (rb_sel_sp & net_658));
   assign net_1348 = (ex_ctl[4] & net_719);
   assign net_135  = (opcode[12] & im74_sel_z6_4);
   assign net_1357 = (net_2300 & net_2299);
   assign net_136  = (net_2308 & net_2305);
   assign net_1362 = (opcode[14] & net_579);
   assign net_1367 = (opcode[7] & net_22);
   assign net_137  = (rb_sel_z5_3 & net_2307);
   assign net_1370 = (~opcode[8] | ~net_28);
   assign net_138  = (net_2306 & net_2307);
   assign net_1382 = ((net_1120 & net_538) & net_2308);
   assign net_1383 = (spu_ctl_raw[29] & net_670);
   assign net_1386 = (~net_102 | ~net_1320);
   assign net_1391 = (net_197 & net_312);
   assign net_1392 = (int_delay | (~net_745 | ~net_198));
   assign net_1393 = (net_2298 | net_434);
   assign net_1396 = (net_897 & net_173);
   assign net_1399 = (~(net_39 & net_44) | ~net_2298);
   assign net_14   = ~net_137;
   assign net_140  = (~opcode[15] & ~special);
   assign net_1408 = (~net_1881 & ~net_1767);
   assign net_141  = (ex_last & net_2305);
   assign net_1419 = (~opcode[9] | ~net_24);
   assign net_1421 = (opcode[13] & net_579);
   assign net_143  = (net_758 | net_8);
   assign net_144  = (net_137 & net_460);
   assign net_1452 = (~net_2308 & ~net_770);
   assign net_1458 = (opcode[13] | net_701);
   assign net_1460 = ~(opcode[5] ^ opcode[6]);
   assign net_1465 = (~wr_use_sp | ~net_1620);
   assign net_1469 = (~net_2304 | ~spu_ctl_raw[32]);
   assign net_147  = (~atomic | ~ex_ctl[0]);
   assign net_148  = (atomic & ex_ctl[5]);
   assign net_150  = (~net_205 | ~net_2302);
   assign net_1507 = (~net_209 | ~net_2304);
   assign net_1517 = (~dbg_op_run | ~net_30);
   assign net_1521 = (~data_abort | ~net_2299);
   assign net_1524 = (~int_preempt | ~net_115);
   assign net_1528 = (~spu_ctl_raw[28] | ~net_39);
   assign net_153  = (opcode[15] & net_137);
   assign net_154  = (~int_preempt & ~net_2308);
   assign net_1543 = (~net_269 | ~net_1136);
   assign net_1547 = (net_1655 & net_575);
   assign net_1558 = (~opcode[14] | ~net_140);
   assign net_1574 = (~net_73 & ~net_495);
   assign net_1578 = (~dbg_halt_req & ~net_19);
   assign net_158  = (~rb_sel_sp | ~net_2305);
   assign net_1589 = ((net_1237 & net_932) & net_609);
   assign net_1594 = (ex_ctl[7] & net_1807);
   assign net_1603 = (net_70 | net_1090);
   assign net_161  = (opcode[11] & net_1059);
   assign net_1617 = (net_2299 | net_1701);
   assign net_1620 = (net_2295 & net_40);
   assign net_1655 = (opcode[11] & opcode[13]);
   assign net_1701 = (net_2298 | net_1084);
   assign net_1704 = (ex_ctl[7] | net_64);
   assign net_172  = (net_850 & spu_ctl_raw[32]);
   assign net_1723 = (net_2302 & net_2300);
   assign net_1727 = (net_825 | net_826);
   assign net_173  = (net_670 & spu_ctl_raw[28]);
   assign net_1735 = (net_62 | net_1199);
   assign net_175  = (~ex_ctl[1] | ~net_745);
   assign net_1758 = (opcode[6] | opcode[4]);
   assign net_1767 = (~opcode[14] | ~net_525);
   assign net_1783 = (atomic & ex_ctl[4]);
   assign net_1797 = (~net_115 | ~spu_ctl_raw[28]);
   assign net_18   = ~net_285;
   assign net_1807 = (net_745 & net_2298);
   assign net_181  = (~ex_ctl[1] & ~ex_ctl[6]);
   assign net_1815 = (ex_ctl[1] & ex_ctl[6]);
   assign net_182  = (~ex_ctl[7] & ~net_2295);
   assign net_1827 = (net_601 & net_2298);
   assign net_1845 = (~spu_ctl_raw[29] | ~net_499);
   assign net_1853 = (net_209 & net_204);
   assign net_1854 = (spu_ctl_raw[21] & net_2299);
   assign net_1878 = ((valid_rfi & ((net_97 & wr_use_sp) |
               (~net_1195 & ~ex_ctl[1]))) | ((net_211 &
               dbg_halt_req) | net_522));
   assign net_1881 = (ex_ctl[5] | (~net_113 | ~rb_sel_sp));
   assign net_1882 = (~net_211 | ~special);
   assign net_189  = (spu_ctl_raw[23] & net_1304);
   assign net_19   = ~opcode[11];
   assign net_191  = (~ex_ctl[4] & ~net_71);
   assign net_1921 = (~opcode[9] | ~opcode[8]);
   assign net_1922 = (~opcode[3] | ~dbg_halt_req);
   assign net_1961 = (~opcode[6] | ~net_28);
   assign net_197  = (~ex_ctl[0] & ~ex_ctl[6]);
   assign net_1973 = (net_113 & net_639);
   assign net_1975 = (int_preempt & net_499);
   assign net_198  = (ex_ctl[3] & ex_ctl[5]);
   assign net_199  = (~net_470 | ~net_670);
   assign net_20   = ~net_1059;
   assign net_2004 = (~spu_ctl_raw[28] & ~net_434);
   assign net_2014 = (net_468 & (net_75 | ((~net_470 |
               ~list_empty) & net_258)));
   assign net_2025 = (ex_ctl[5] & net_2163);
   assign net_204  = (ex_ctl[6] & net_2298);
   assign net_205  = (~atomic & ~int_preempt);
   assign net_208  = (net_502 & net_2298);
   assign net_2089 = (~((net_71 | net_59) & (~net_745 | ~net_97))
               | ~net_296);
   assign net_209  = (ex_ctl[7] & spu_ctl_raw[32]);
   assign net_2094 = (~net_78 & ~net_112);
   assign net_2096 = (ex_ctl[4] & net_2301);
   assign net_21   = ~net_455;
   assign net_210  = (net_719 & exnum_sel_bus);
   assign net_211  = (~data_abort & ~net_2302);
   assign net_2126 = (spu_ctl_raw[29] & net_639);
   assign net_2163 = (net_209 & net_652);
   assign net_218  = (ex_ctl[1] & spu_ctl_raw[28]);
   assign net_2182 = (net_2014 & (spu_ctl_raw[32] | net_68));
   assign net_219  = (~ex_ctl[3] | ~net_2296);
   assign net_2193 = (~net_1357 | ~net_897);
   assign net_2199 = (~data_abort & ~ex_ctl[6]);
   assign net_22   = ~opcode[10];
   assign net_221  = (ex_ctl[1] & spu_ctl_raw[32]);
   assign net_2254 = (net_5 & net_1458);
   assign net_2295 = ~ex_ctl[0];
   assign net_2296 = ~ex_ctl[1];
   assign net_2298 = ~ex_ctl[4];
   assign net_2299 = ~ex_ctl[5];
   assign net_23   = ~opcode[9];
   assign net_2300 = ~ex_ctl[6];
   assign net_2301 = ~ex_ctl[7];
   assign net_2302 = ~ex_last;
   assign net_2303 = ~data_abort;
   assign net_2304 = ~atomic;
   assign net_2305 = ~int_preempt;
   assign net_2306 = ~opcode[12];
   assign net_2307 = ~opcode[13];
   assign net_2308 = ~opcode[14];
   assign net_2309 = ~opcode[15];
   assign net_235  = (net_97 & net_686);
   assign net_238  = (~ex_ctl[7] & ~spu_ctl_raw[32]);
   assign net_24   = ~opcode[8];
   assign net_240  = (net_113 & spu_ctl_raw[32]);
   assign net_243  = (~(~(~(net_594 | ex_ctl[0]) | ~(~net_218 |
               ~net_803)) & ~(net_575 & net_551)) | ~(~net_2307 |
               ~(net_798 & net_269)));
   assign net_246  = (~ex_ctl[1] | ~net_719);
   assign net_254  = (~opcode[15] & ~net_19);
   assign net_257  = (~int_preempt | ~spu_ctl_raw[32]);
   assign net_258  = (~spu_ctl_raw[29] | ~net_470);
   assign net_259  = (~exnum_sel_bus & ~net_502);
   assign net_26   = ~net_957;
   assign net_264  = (((net_476 & (net_403 | spu_ctl_raw[32])) |
               net_47) & net_473);
   assign net_268  = (~net_22 & ~opcode[8]);
   assign net_269  = (ex_last & opcode[15]);
   assign net_27   = ~net_1961;
   assign net_273  = (opcode[11] & net_2308);
   assign net_274  = (net_455 & net_24);
   assign net_275  = (net_269 & net_285);
   assign net_28   = ~opcode[7];
   assign net_281  = (~rb_sel_sp | ~net_667);
   assign net_282  = (~(list_empty & net_467) | ~net_2298);
   assign net_283  = ((~net_547 & ~(~net_549 | ~(~net_551 |
               ~net_137))) & (net_545 | net_546));
   assign net_285  = (net_19 & net_33);
   assign net_286  = (opcode[14] & opcode[13]);
   assign net_288  = (~net_204 | ~net_467);
   assign net_29   = ~net_826;
   assign net_292  = (~net_835 & ~(~((net_635 & (~net_191 |
               ~net_2301)) | net_2302) | ~net_87));
   assign net_296  = (net_2302 | net_483);
   assign net_298  = (~ex_ctl[6] | ~net_372);
   assign net_299  = (ex_ctl[1] & net_2299);
   assign net_30   = ~opcode[3];
   assign net_302  = ((~int_preempt & ~net_908) & net_2300);
   assign net_303  = (net_921 & net_2299);
   assign net_304  = (~alu_ctl_raw[10] | ~net_2300);
   assign net_306  = (~spu_ctl_raw[31] | ~alu_ctl_raw[19]);
   assign net_312  = (net_1316 & net_2302);
   assign net_313  = (net_209 & spu_ctl_raw[28]);
   assign net_314  = (~net_820 | ~exnum_sel_bus);
   assign net_316  = (~atomic | ~exnum_sel_bus);
   assign net_318  = (~net_2305 | ~net_718);
   assign net_321  = ((net_2193 & net_1392) & (~net_1391 |
               ~net_2298));
   assign net_325  = (opcode[11] & net_1113);
   assign net_327  = (~net_274 | ~net_952);
   assign net_328  = (~net_1292 | ~net_378);
   assign net_33   = ~dbg_halt_req;
   assign net_331  = (~net_459 | ~net_19);
   assign net_333  = (net_608 & (ex_ctl[6] | net_732));
   assign net_334  = (net_209 & net_986);
   assign net_338  = (~net_22 | ~net_23);
   assign net_340  = (net_579 & net_1328);
   assign net_342  = (opcode[6] | net_24);
   assign net_349  = (~net_73 & ~net_37);
   assign net_353  = (spu_ctl_raw[28] & net_2299);
   assign net_356  = ((~addr_last[0] | ~net_365) & (addr_last[0] |
               net_420));
   assign net_357  = ((~spu_ctl_raw[28] & ~net_64) |
               spu_ctl_raw[24]);
   assign net_36   = ~net_205;
   assign net_363  = (ex_ctl[0] & ex_ctl[6]);
   assign net_364  = (~net_403 & ~(addr_last[1] | addr_last[0]));
   assign net_365  = (addr_last[1] & cfg_be);
   assign net_368  = (ex_ctl[1] & ex_ctl[5]);
   assign net_37   = ~net_897;
   assign net_371  = (ex_last & net_2295);
   assign net_372  = (ex_ctl[1] & ex_ctl[0]);
   assign net_377  = (~ex_ctl[0] & ~net_86);
   assign net_378  = (~data_abort & ~int_preempt);
   assign net_38   = ~net_850;
   assign net_382  = (cfg_be & net_364);
   assign net_384  = (net_396 & (~net_181 | ~addr_last[0]));
   assign net_385  = (~addr_last[1] | ~net_51);
   assign net_386  = (spu_ctl_raw[21] & spu_ctl_raw[32]);
   assign net_389  = ((addr_last[0] | net_385) & (net_411 |
               net_52));
   assign net_39   = ~int_delay;
   assign net_390  = ((~net_377 | ~net_394) & (net_411 |
               (spu_ctl_raw[28] | net_415)));
   assign net_394  = (cfg_be ^ addr_last[1]);
   assign net_396  = (~net_218 | ~net_2295);
   assign net_4    = ~net_1558;
   assign net_40   = ~valid_rfi;
   assign net_403  = (~net_2295 | ~spu_ctl_raw[28]);
   assign net_407  = (~net_2296 | ~net_2304);
   assign net_41   = ~wfi_adv;
   assign net_411  = (addr_last[1] | net_51);
   assign net_415  = (~net_113 | ~ex_ctl[4]);
   assign net_418  = (addr_last[0] | (~net_365 |
               ~spu_ctl_raw[28]));
   assign net_42   = ~net_820;
   assign net_420  = (addr_last[1] | cfg_be);
   assign net_427  = (ex_ctl[6] & ex_ctl[7]);
   assign net_43   = ~net_719;
   assign net_433  = (net_175 & net_246);
   assign net_434  = (~ex_ctl[6] | ~net_719);
   assign net_436  = (~ex_last | ~opcode[13]);
   assign net_439  = (~net_825 | ~net_1237);
   assign net_44   = ~net_1084;
   assign net_443  = (net_1333 & net_2295);
   assign net_449  = (~net_525 | ~im74_sel_z6_4);
   assign net_45   = ~net_1783;
   assign net_451  = (opcode[8] | net_20);
   assign net_455  = (opcode[9] & net_22);
   assign net_457  = (opcode[8] & net_1113);
   assign net_459  = (~opcode[13] & ~net_2302);
   assign net_46   = ~wr_use_sp;
   assign net_460  = (~int_preempt & ~net_1558);
   assign net_467  = (net_719 & ex_ctl[5]);
   assign net_468  = (~ex_ctl[1] | ~atomic);
   assign net_47   = ~net_816;
   assign net_470  = (atomic & net_2298);
   assign net_473  = (~net_210 | ~net_718);
   assign net_476  = (~ex_ctl[7] | ~net_499);
   assign net_477  = (dbg_halt_req | special);
   assign net_480  = (opcode[11] & net_22);
   assign net_483  = (ex_ctl[0] | ex_ctl[7]);
   assign net_486  = (~spu_ctl_raw[29] | ~(net_204 & net_897));
   assign net_489  = (~net_670 | ~spu_ctl_raw[32]);
   assign net_490  = (net_209 & net_2296);
   assign net_495  = (~atomic | ~net_97);
   assign net_498  = (net_658 & net_2302);
   assign net_499  = (ex_ctl[5] & spu_ctl_raw[28]);
   assign net_5    = ~net_286;
   assign net_502  = (spu_ctl_raw[31] & spu_ctl_raw[28]);
   assign net_505  = (net_2296 & spu_ctl_raw[32]);
   assign net_51   = ~cfg_be;
   assign net_510  = (~opcode[15] & ~opcode[13]);
   assign net_513  = (~opcode[13] | ~net_525);
   assign net_515  = (opcode[13] & net_1282);
   assign net_517  = (opcode[13] & net_538);
   assign net_52   = ~addr_last[0];
   assign net_522  = (int_preempt & net_2304);
   assign net_525  = (opcode[12] & opcode[15]);
   assign net_530  = (~net_1059 | ~opcode[8]);
   assign net_533  = (opcode[14] & net_205);
   assign net_536  = (~atomic | ~ex_ctl[3]);
   assign net_538  = (~opcode[12] & ~net_2309);
   assign net_54   = ~list_empty;
   assign net_545  = (~net_274 | net_1113);
   assign net_546  = (dbg_halt_req | net_771);
   assign net_547  = (net_459 & (~opcode[14] & ~net_477));
   assign net_549  = (net_609 & (net_770 | net_546));
   assign net_55   = ~rb_sel_wr_ex;
   assign net_551  = (net_33 & opcode[15]);
   assign net_554  = (dbg_halt_req & net_610);
   assign net_56   = ~rb_sel_list;
   assign net_560  = (opcode[1] & ~opcode[0]);
   assign net_562  = (opcode[2] & opcode[7]);
   assign net_570  = (~net_19 | ~net_2307);
   assign net_573  = (~net_2306 & ~net_2308);
   assign net_574  = (ex_last & net_19);
   assign net_575  = (rb_sel_z5_3 & net_2308);
   assign net_579  = (rb_sel_z5_3 & net_19);
   assign net_580  = (net_470 & spu_ctl_raw[30]);
   assign net_59   = ~net_182;
   assign net_590  = (ex_ctl[3] & net_719);
   assign net_594  = (~net_1382 | ~net_2304);
   assign net_6    = ~net_154;
   assign net_60   = ~net_96;
   assign net_601  = (spu_ctl_raw[21] & spu_ctl_raw[31]);
   assign net_604  = (~net_719 | ~net_353);
   assign net_605  = (~net_72 & ~net_45);
   assign net_606  = (~net_1090 & ~net_61);
   assign net_608  = (net_42 | net_631);
   assign net_609  = (~net_522 | ~net_40);
   assign net_61   = ~net_651;
   assign net_610  = (dbg_op_run & net_2004);
   assign net_613  = (~ex_last & ~net_634);
   assign net_614  = (~net_888 | ~net_2300);
   assign net_62   = ~net_209;
   assign net_620  = (opcode[1] | opcode[0]);
   assign net_623  = (spu_ctl_raw[29] & net_2299);
   assign net_631  = (ex_ctl[3] | ex_ctl[7]);
   assign net_634  = (net_65 | net_71);
   assign net_635  = (~spu_ctl_raw[29] | ~(~spu_ctl_raw[21] |
               ~net_879));
   assign net_636  = (~net_652 | ~net_2301);
   assign net_639  = (ex_ctl[4] & net_2304);
   assign net_64   = ~net_1815;
   assign net_642  = (~rb_sel_wr_ex | ~net_2025);
   assign net_646  = (spu_ctl_raw[29] & net_205);
   assign net_647  = (~ex_ctl[1] & ~ex_ctl[0]);
   assign net_65   = ~net_204;
   assign net_651  = (ex_ctl[7] & net_2299);
   assign net_652  = (ex_ctl[6] & net_2295);
   assign net_653  = (net_2302 & spu_ctl_raw[28]);
   assign net_655  = (~spu_ctl_raw[29] | ~ex_ctl[5]);
   assign net_658  = (ex_ctl[6] & spu_ctl_raw[32]);
   assign net_667  = (net_2304 & net_2299);
   assign net_67   = ~spu_ctl_raw[23];
   assign net_670  = (~ex_ctl[5] & ~net_2295);
   assign net_673  = (((net_834 & ((net_862 & (~net_926 |
               ~net_2306)) | net_912)) & (~net_303 |
               ~svc_escalate)) & (net_864 | (~net_917 | ~(net_658
               & rb_sel_wr_ex))));
   assign net_674  = (~net_1853 | ~net_1854);
   assign net_676  = (ex_ctl[5] & net_2295);
   assign net_679  = (net_2304 & spu_ctl_raw[28]);
   assign net_68   = ~exnum_sel_bus;
   assign net_680  = (int_preempt | net_2299);
   assign net_681  = (~net_97 | ~net_44);
   assign net_684  = (~ex_ctl[4] | ~net_850);
   assign net_686  = (ex_ctl[5] & spu_ctl_raw[32]);
   assign net_687  = (~(net_286 & net_141) | ~net_2309);
   assign net_689  = (~net_136 | ~net_2309);
   assign net_692  = (~net_741 & ~(net_470 & net_502));
   assign net_695  = (net_2295 & net_2299);
   assign net_696  = (net_143 & (net_525 | net_7));
   assign net_7    = ~im74_sel_z6_4;
   assign net_70   = ~net_197;
   assign net_701  = (opcode[15] | opcode[11]);
   assign net_704  = (net_243 | (~((((((net_788 & (((net_21 |
               net_794) & (net_20 | net_28)) | (~opcode[8] |
               ~net_579))) & (net_436 | opcode[15])) | net_477) &
               ((net_468 & (~net_780 & ~(~net_782 | ~(~net_275 |
               ~net_784)))) & (~opcode[14] | ~net_275))) &
               (~net_774 | ~net_459)) & net_549) | ~(net_594 |
               opcode[3])));
   assign net_71   = ~net_368;
   assign net_713  = (net_499 & net_2295);
   assign net_715  = (net_198 & int_delay);
   assign net_718  = (~sleep_rfi | ~net_41);
   assign net_719  = (atomic & spu_ctl_raw[32]);
   assign net_72   = ~net_670;
   assign net_723  = (~opcode[2] | ~net_719);
   assign net_73   = ~net_353;
   assign net_732  = (~wr_use_sp | ~net_850);
   assign net_733  = (~atomic | ~net_670);
   assign net_737  = (~opcode[15] | ~rb_sel_z5_3);
   assign net_741  = (~ex_ctl[6] & ~net_468);
   assign net_743  = (atomic & net_198);
   assign net_745  = (atomic & ex_ctl[6]);
   assign net_75   = ~net_499;
   assign net_754  = (im74_sel_z6_4 & net_22);
   assign net_758  = (~opcode[15] | ~rb_sel_z8_6);
   assign net_76   = ~net_115;
   assign net_770  = (opcode[9] | net_22);
   assign net_771  = (~net_269 | ~net_2308);
   assign net_774  = ((~special & ~net_18) & net_2308);
   assign net_78   = ~net_218;
   assign net_780  = (net_2025 & net_2302);
   assign net_782  = (net_258 | ex_ctl[6]);
   assign net_784  = (net_23 & net_24);
   assign net_788  = (~opcode[11] | ~net_137);
   assign net_794  = (~net_27 | ~cfg_smul);
   assign net_798  = (net_20 & net_33);
   assign net_8    = ~net_136;
   assign net_803  = (net_670 & net_2302);
   assign net_815  = (ex_ctl[5] & exnum_sel_bus);
   assign net_816  = (~ex_last & ~atomic);
   assign net_819  = (atomic & net_197);
   assign net_820  = (atomic & spu_ctl_raw[29]);
   assign net_823  = ((rb_sel_list & net_427) & net_2304);
   assign net_825  = (~opcode[15] | ~net_610);
   assign net_826  = (~net_30 & ~net_620);
   assign net_834  = (net_1735 & (net_1199 | net_112));
   assign net_835  = (~net_59 & ~net_1244);
   assign net_850  = (~int_preempt & ~net_2296);
   assign net_853  = (ex_ctl[1] & net_209);
   assign net_857  = (~spu_ctl_raw[21] | ~net_2308);
   assign net_86   = (~ex_ctl[1] | ~net_499);
   assign net_862  = (~net_140 & ~net_927);
   assign net_864  = (~net_1961 & ~net_1222);
   assign net_87   = (~spu_ctl_raw[30] | ~net_218);
   assign net_879  = (~ex_ctl[1] | ~net_2298);
   assign net_886  = (net_96 & net_2304);
   assign net_888  = (ex_ctl[0] & rb_sel_sp);
   assign net_89   = (~net_209 | ~net_107);
   assign net_890  = (ex_ctl[0] & net_2302);
   assign net_891  = ((~net_1316 | net_1845) & (ex_ctl[4] |
               (net_483 | net_38)));
   assign net_897  = (net_850 & net_2302);
   assign net_898  = (~net_499 | ~net_1594);
   assign net_908  = (~net_209 | ~net_1827);
   assign net_912  = (~net_205 | ~(~net_61 & ~net_415));
   assign net_917  = (net_97 & net_136);
   assign net_921  = (net_197 & (~ex_ctl[1] & ~net_47));
   assign net_926  = (~special & ~net_2308);
   assign net_927  = (net_1136 | net_1282);
   assign net_93   = (spu_ctl_raw[31] & net_2295);
   assign net_930  = (ex_ctl[6] & spu_ctl_raw[28]);
   assign net_932  = (~net_745 | ~net_715);
   assign net_938  = (~net_820 | ~spu_ctl_raw[30]);
   assign net_951  = (data_abort | (~wr_sel_7777 | ~(net_285 |
               net_798)));
   assign net_952  = (~net_1255 & ~net_7);
   assign net_954  = (net_19 & net_24);
   assign net_957  = (net_27 & opcode[5]);
   assign net_958  = (rb_sel_wr_ex & net_850);
   assign net_96   = (~ex_ctl[7] & ~net_2299);
   assign net_961  = (spu_ctl_raw[29] & net_2298);
   assign net_968  = ((net_952 & (~opcode[12] | ~net_545)) |
               (net_1357 & net_958));
   assign net_969  = (net_1161 | (~net_161 | ~(net_952 &
               opcode[8])));
   assign net_97   = (~ex_ctl[0] & ~net_2298);
   assign net_971  = (~opcode[6] & ~opcode[7]);
   assign net_977  = (opcode[1] & (opcode[0] & net_562));
   assign net_98   = (net_1199 & (net_47 | net_1524));
   assign net_980  = (net_37 & (valid_rfi | net_150));
   assign net_986  = (net_897 & net_695);
   assign net_990  = (ex_last & net_2308);
   assign net_991  = (~ex_ctl[1] | ~net_197);
   assign net_997  = (~net_1316 | ~rb_sel_list);

   // ------------------------------------------------------------
   // Define primary decoder outputs
   // ------------------------------------------------------------

   assign addr_agu = ((spu_ctl_raw[29] & (net_676 | (net_372 |
               ex_ctl[4]))) | (net_1286 | (((~(~net_499 |
               ~ex_ctl[6]) | ~(~spu_ctl_raw[21] | ~ex_ctl[1])) |
               ((net_667 & net_1073) | net_197)) | net_2301)));

   assign addr_ex  = (~(((((net_2193 & (~net_816 | ~(net_1854 &
               net_181))) & (~ex_ctl[0] | ~(net_378 & wr_use_sp)))
               & ((net_642 & (((~net_1783 | ~net_2199) & (~net_221
               | ~rb_sel_sp)) & (net_61 | (~net_44 | ~net_1073))))
               & ((~net_312 | ~net_2298) | ex_ctl[0]))) &
               ((~net_470 | ~net_499) | int_preempt)) &
               (~ex_ctl[7] | ~(~(net_1399 & net_997) | ~(~net_601
               | ~ex_ctl[4])))) | ~net_2182);

   assign addr_phase = (~net_2182 | ~((net_891 & (~net_986 &
               ~(~((~net_1348 | ~net_2199) & (~net_961 |
               ~net_897)) | ~(((net_1528 | net_258) & (net_62 |
               net_997)) & net_321)))) & (net_127 | net_318)));

   assign addr_ra  = (~(~net_1827 & ~(~((~net_679 | ~net_120) &
               (net_536 | ex_ctl[5])) | ~(net_78 | net_489))) |
               ~((net_2295 | net_67) & (~net_386 | ~net_2296)));

   assign alu_ctl_raw[0] = ((ex_ctl[5] & net_107) & net_2302);

   assign alu_ctl_raw[1] = (~net_46 | ~(~rb_sel_wr_ex | ~net_667));

   assign alu_ctl_raw[10] = (~ex_ctl[3] & ~net_733);

   assign alu_ctl_raw[11] = ((~(~net_2126 & ~net_2096) | ~(net_991
               | ex_ctl[5])) | ((ex_ctl[3] & ((spu_ctl_raw[29] &
               (ex_ctl[4] | net_2299)) | ((net_240 & net_2295) |
               spu_ctl_raw[30]))) | (~(~net_2163 | ~net_198) |
               ~(~net_1383 | ~net_113))));

   assign alu_ctl_raw[12] = (rb_sel_sp & net_299);

   assign alu_ctl_raw[13] = (((net_695 & ex_ctl[6]) & (net_209 &
               ex_ctl[3])) | (~((~net_745 | ~(net_695 | (net_97 |
               ex_ctl[3]))) & (~spu_ctl_raw[21] | ~net_613)) |
               ~(~net_313 | ~net_639)));

   assign alu_ctl_raw[14] = (((~net_71 & ~(net_483 & (~ex_ctl[3] |
               ~net_2300))) | (~net_2302 & ~net_655)) | ((net_886
               & net_2300) | (~(~ex_last | ~net_130) |
               ~(~(~ex_ctl[0] & ~net_655) | ~net_2304))));

   assign alu_ctl_raw[15] = (~(~net_819 & ~(~(~net_490 |
               ~spu_ctl_raw[28]) | ~(~(ex_ctl[7] & (net_647 |
               (net_218 & ex_ctl[6]))) | ~net_2302))) | ~(net_2295
               | net_259));

   assign alu_ctl_raw[16] = (net_204 & (net_182 & net_221));

   assign alu_ctl_raw[17] = (~net_71 & ~net_1306);

   assign alu_ctl_raw[18] = (~net_2299 & ~net_147);

   assign alu_ctl_raw[19] = (net_120 & net_2298);

   assign alu_ctl_raw[2] = (net_181 & net_2096);

   assign alu_ctl_raw[3] = ((net_2296 & (net_238 | net_2126)) |
               net_1973);

   assign alu_ctl_raw[4] = (~net_98 | ~(((net_1079 | net_2298) &
               (~net_1078 | ~int_preempt)) & (ex_ctl[4] |
               (~spu_ctl_raw[30] | ~net_2300))));

   assign alu_ctl_raw[5] = (net_299 | ((net_930 & ex_ctl[4]) |
               (net_2298 & (net_372 | (~net_61 | ~(net_1469 |
               ex_ctl[7]))))));

   assign alu_ctl_raw[6] = (((net_204 & (net_117 & net_1383)) |
               (~net_199 | ~(~net_209 | ~(net_363 & ex_last)))) |
               ((net_2094 & net_2298) | net_2089));

   assign alu_ctl_raw[7] = (ex_last & (net_1003 |
               (~spu_ctl_raw[28] & ~net_1704)));

   assign alu_ctl_raw[8] = (~(~net_2089 & ~((net_2096 & (ex_ctl[6]
               ^ ex_ctl[1])) | ((ex_last & (net_372 & net_427)) |
               net_2094))) | ~(net_733 | ex_ctl[6]));

   assign alu_ctl_raw[9] = ((net_2298 & (~(net_476 & (atomic |
               net_2299)) | ~net_2296)) | ((~(net_64 | ex_ctl[5])
               | ~(~net_204 | ~net_386)) | ((~(~ex_ctl[0] |
               ~net_499) | ~(~net_470 | ~net_2300)) | (~((net_55 |
               net_415) & (net_70 | spu_ctl_raw[32])) |
               ~net_1507))));

   assign alu_en_nxt = ((net_33 & (net_211 & ((opcode[15] &
               ((net_2308 & ((~(net_770 & opcode[13]) |
               ~((net_1370 | (net_1066 | (net_19 | net_22))) |
               opcode[5])) | (net_784 & net_19))) | (~(~cc_pass |
               ~net_2307) & ~net_161))) | ((net_4 & (opcode[12] |
               (net_457 | ((~(~(net_24 & net_28) & ~(net_27 &
               cfg_smul)) | (opcode[9] ^ net_27)) | opcode[10]))))
               | (net_140 & (opcode[13] | (opcode[11] &
               opcode[12]))))))) | (~(~((~((~ex_ctl[7] | ~net_467)
               | sleep_rfi) | ~((net_39 | net_258) | ex_ctl[3])) |
               ((net_745 & net_1975) | (~net_1255 &
               ~(~((((~net_1921 & ~net_28) & net_1460) & net_19) &
               (rb_sel_3_0 & opcode[14])) & ~(net_575 |
               net_579))))) & ~((~data_abort & ~(~((~net_2308 &
               ~(net_788 | net_477)) | (net_780 | ((exnum_sel_bus
               & net_890) | net_823))) & ~(net_1078 & net_115))) |
               ((~(net_2014 & (~net_1408 | ~net_2304)) |
               ~net_1589) | (~((net_594 & ((net_782 & net_1393) &
               (net_1386 | opcode[14]))) & (net_1150 | net_1075))
               | ~net_1727)))) | ~(net_434 | net_73)));

   assign atomic_nxt = (net_1878 | (~(~net_1975 & ~(~((net_1543 |
               (net_13 | (~debug_en | ~(~data_abort & ~net_451))))
               & (net_2308 | net_1882)) | ~(((net_631 &
               (~ex_ctl[7] | ~net_2298)) | net_2304) & net_314)))
               | ~(~net_2299 | ~(((dbg_halt_req & (~net_219 &
               ~net_65)) | (~(~(opcode[14] & special) | ~net_1973)
               | ~(~atomic | ~net_2303))) | net_470))));

   assign aux_align = (net_990 | (opcode[11] & rb_sel_z5_3));

   assign aux_en   = ((net_144 & (~dbg_halt_req & ~(net_1121 &
               (~cfg_smul | net_1022)))) | ((net_2305 &
               (~((~net_1421 | ~net_551) & (~spu_ctl_raw[23] |
               ~net_890)) | ~net_642)) | (~(~(~(~net_798 |
               ~wr_sel_7777) | ~(~(net_590 & (((net_2309 &
               dbg_op_run) & (~opcode[3] | ~net_620)) | net_33)) |
               ~net_2295)) & ~(~(~(~net_433 | ~(~net_470 |
               ~(net_623 & ex_ctl[3]))) & ~((opcode[12] & (net_154
               & net_275)) | net_1396)) | ~(net_316 | net_306))) |
               ~(net_732 | ex_ctl[3]))));

   assign aux_sel_addr = ((net_2304 & (opcode[10] | net_701)) |
               ((net_820 & net_2296) | net_816));

   assign aux_sel_iaex = (net_719 & (~net_1517 | ~(dbg_halt_req &
               net_2296)));

   assign aux_sel_xpsr = (~net_175 | ~(net_1922 | (~dbg_op_run |
               ~net_505)));

   assign aux_tbit = (~((net_723 | net_1922) & (net_331 |
               net_1921)) | ~(~opcode[12] | ~ex_last));

   assign b_cond_de = ~net_951;

   assign bkpt_ex  = (ex_ctl[0] & net_719);

   assign branch_de = ((~data_abort & ~(~((net_113 & (net_890 &
               net_313)) | (rb_sel_3_0 & (net_525 & (net_325 |
               (opcode[8] | net_1173))))) & ~((~(net_530 &
               (~net_268 | ~net_977)) & ~(~net_510 | ~net_1362)) |
               ((net_269 & ((opcode[12] & ((opcode[13] &
               ((opcode[8] & ((opcode[11] & net_1161) | (opcode[9]
               ^ opcode[11]))) | (net_1059 & ((~opcode[11] &
               ~net_957) | (~net_19 & ~opcode[8]))))) |
               (opcode[14] & net_161))) | net_286)) | net_921))))
               | (((~(net_1882 & (~net_1853 | ~net_803)) |
               ~net_1881) | (((net_115 & net_2302) & net_386) |
               net_1878)) | ((atomic & (~ex_ctl[0] & ~(~ex_ctl[7]
               | ~(~ex_ctl[6] | ~spu_ctl_raw[28])))) |
               (spu_ctl_raw[28] & (net_719 | (int_preempt |
               net_470))))));

   assign bus_idle = (~(~net_606 & ~(~((((net_642 & (((~net_204 &
               ~(~list_empty & ~(net_718 | net_1797))) & (~net_695
               | ~net_2298)) | net_43)) & (net_61 | (~data_abort |
               ~ex_ctl[4]))) & ((net_932 & ((net_1603 & net_674) &
               (~net_353 | ~net_1036))) & (~int_preempt |
               ~(~(net_1465 & (((net_1617 & ((atomic | net_1845) &
               (~net_299 | ~net_1723))) & (net_879 | net_46)) &
               ((net_1039 | net_1797) & (~net_1078 | ~(net_2298 |
               net_686))))) | ~(net_56 | net_1507))))) & (~net_745
               | ~net_670)) | ~net_908)) | ~net_834);

   assign cflag_en = (~net_292 | ~((((~net_238 & ~(~net_59 &
               ~(~spu_ctl_raw[28] & ~spu_ctl_raw[31]))) &
               (~spu_ctl_raw[30] | ~net_1815)) | net_2298) &
               (net_2302 | (net_636 & net_655))));

   assign cps_en   = (~net_60 & ~net_684);

   assign data_phase = (~(((((~net_490 | ~net_211) & (~net_1594 |
               ~spu_ctl_raw[28])) & (net_1393 & (~net_1316 |
               ~(net_502 & ex_ctl[7])))) & (~net_1574 |
               ~net_2303)) & (~(net_93 | (~net_1797 | ~(~net_204 |
               ~net_499))) | ~(net_378 & net_209))) | ~(((net_127
               & (~net_204 | ~(~net_1469 & ~(~net_353 |
               ~net_2303)))) & (~net_211 | ~net_499)) |
               ex_ctl[0]));

   assign dbg_halt_ack = (net_605 | (net_745 & (~spu_ctl_raw[28] &
               ~net_61)));

   assign ex_ctl_nxt[0] = (((~dbg_halt_req & ~(~(~((~net_240 |
               ~rb_sel_wr_ex) & (~net_153 | ~opcode[11])) |
               ~(((~net_1452 | ~rb_sel_z8_6) & (~net_286 |
               ~net_579)) & (net_2302 | ((((~net_1136 | ~net_21) &
               (opcode[14] | opcode[11])) | opcode[15]) &
               (((~(net_1136 & (~(~net_27 & ~(~opcode[6] &
               ~net_19)) | ~net_24)) | ~opcode[13]) & ((((net_513
               | net_455) & (~net_1047 | ~opcode[15])) &
               ((~net_515 & ~special) & (net_1767 | opcode[8]))) &
               (net_22 | net_1458))) & (~opcode[15] | ~(net_286 &
               (~opcode[5] | ~(net_1367 & net_1758))))))))) &
               ~(~opcode[15] & ~(~net_579 | ~(~((opcode[6] |
               (~opcode[9] & ~net_24)) & (net_28 | net_24)) |
               ~(~net_27 | ~net_23)))))) | (~((net_1081 &
               ((net_1393 | ex_ctl[5]) & (net_288 | net_1075))) &
               (net_758 | net_18)) | ~net_1727)) | ((ex_ctl[0] &
               ((list_empty & (net_1723 & net_686)) |
               (((rb_sel_wr_ex & (net_853 | spu_ctl_raw[31])) |
               (rb_sel_sp & net_2304)) | ((net_816 & (~list_empty
               & ~(~ex_ctl[7] | ~(spu_ctl_raw[31] | net_930)))) |
               net_1252)))) | ((wr_use_sp & ((~(net_75 |
               list_elast) | ~(net_71 | ex_ctl[0])) | net_1317)) |
               (~((net_281 & ((net_1704 & (~net_670 |
               ~spu_ctl_raw[23])) | ex_last)) & (net_680 |
               net_1701)) | ~(~spu_ctl_raw[28] | ~(net_816 &
               (~(ex_ctl[7] | valid_rfi) | ~(~net_647 |
               ~list_empty))))))));

   assign ex_ctl_nxt[1] = (~(((~(~(data_abort | (~net_1578 |
               ~(net_754 | wr_sel_10_7))) | ~(net_1005 &
               ((~net_172 | ~rb_sel_sp) & (~net_148 |
               ~spu_ctl_raw[21])))) & ~net_741) & ((~net_1334 |
               ~net_533) & (((~net_172 | ~(rb_sel_wr_ex &
               (~ex_ctl[5] & ~net_70))) & (~net_1594 | ~(net_502 &
               list_empty))) & ((~net_499 | ~(~data_abort &
               ~(~net_363 | ~(net_897 & net_209)))) & (list_empty
               | (~net_312 | ~(net_218 & net_652))))))) &
               (~(net_33 & net_378) | ~(net_1547 | (~(~(net_926 &
               rb_sel_z5_3) | ~(~(~net_570 & ~((opcode[7] &
               net_455) & net_342)) | ~(~opcode[8] | ~(~(~net_28 |
               ~net_1330) | ~((opcode[6] & net_22) |
               opcode[9]))))) | ~((~net_269 | ~(~((~net_24 |
               ~net_2307) & (~net_5 | ~net_19)) | ~(~net_480 &
               ~(net_2308 & (~debug_en | ~net_24))))) & (~ex_last
               | ~(~((~opcode[10] | ~(net_1136 & net_254)) &
               (~opcode[12] | ~(~net_1558 | ~(~net_1173 |
               special)))) | ~(~special | ~net_2308)))))))) |
               ~((((net_642 & (net_1617 & (~net_1252 | ~(net_1620
               | spu_ctl_raw[21])))) & (~wr_use_sp | ~net_173)) &
               (~net_888 | ~(net_686 | net_2300))) | int_preempt));

   assign ex_ctl_nxt[2] = (~(((~(~ex_ctl[7] & ~net_316) &
               ~(~net_1603 | ~(((~net_719 & ~(net_745 &
               int_preempt)) | net_2299) | net_2298))) & net_1256)
               & ((~net_610 & ~(~((((~net_470 | ~int_delay) |
               net_73) & (~net_1357 | ~net_820)) & net_246) |
               ~net_898)) & (net_1589 & (~net_137 | ~(~net_1255 &
               ~opcode[14]))))) | ~((ex_ctl[3] | (((net_434 |
               net_41) & (~spu_ctl_raw[30] | ~atomic)) &
               (~int_preempt | ~(~net_1039 & ~ex_ctl[4])))) &
               (data_abort | ((((~net_1574 & ~((net_1578 &
               net_455) & (net_4 & rb_sel_z8_6))) & (~net_686 |
               ~net_102)) & (((~net_153 & ~(~(((~net_137 |
               ~(~net_1015 | ~(((net_1019 & (~net_1113 | ~net_23))
               | opcode[10]) & opcode[14]))) | special) &
               (net_1558 | ((net_1011 & (~opcode[13] |
               ~rb_sel_z5_3)) & (~rb_sel_z8_6 | ~net_23)))) |
               ~(net_770 | net_1543))) & (net_771 | opcode[13])) |
               net_18)) & (((~net_1547 | ~net_1292) & (list_empty
               | (~net_499 | ~wr_use_sp))) & (net_13 | ((opcode[5]
               | (dbg_halt_req | (net_1543 | net_1177))) | (net_20
               | net_1161))))))));

   assign ex_ctl_nxt[3] = (~(~(~net_1084 & ~(~ex_ctl[4] &
               ~(net_2299 & net_1528))) & ~((net_743 & (~ex_ctl[6]
               | ~net_39)) | (net_719 & ((net_2300 & (~((ex_ctl[4]
               | ex_ctl[5]) & (net_1524 | list_empty)) |
               ~net_1521)) | (ex_ctl[3] & (net_33 | (net_1517 |
               (~opcode[15] | ~net_977)))))))) | ~(int_preempt |
               (((((~(~(net_1507 | net_1079) | ~(~net_1078 |
               ~exnum_sel_bus)) & ~(~((net_1117 & net_1028) &
               (~rb_sel_3_0 | ~net_1173)) | ~(~list_empty |
               ~(~((~net_803 | ~net_658) & (~net_1296 | ~net_890))
               | ~(net_86 | (~wr_use_sp | ~list_elast)))))) &
               ((~rb_sel_z8_6 | ~net_19) & (~net_1274 |
               ~net_2304))) & (((net_758 & ((~ex_ctl[1] |
               ~(net_182 & net_498)) & (opcode[10] | (net_771 |
               net_24)))) & (~wr_use_sp | ~net_197)) &
               (((~ex_ctl[0] | ~rb_sel_wr_ex) | net_1244) &
               (~net_575 | ~opcode[15])))) & (ex_ctl[1] |
               (((((~net_182 | ~net_40) & ((~spu_ctl_raw[32] |
               ~net_2299) | atomic)) | ex_last) & (~rb_sel_wr_ex |
               ~(~net_1469 | ~net_2295))) & net_1465))) &
               (((((~data_abort & ~(net_477 | (~((~opcode[12] |
               ~(net_1059 | (~net_2307 & ~opcode[15]))) &
               (~net_1452 | ~net_2309)) | ~((opcode[8] | net_2254)
               & (opcode[14] | net_570))))) & (~net_286 |
               ~(~net_1460 | ~opcode[9]))) & (opcode[7] |
               net_2254)) & (net_23 | (((net_13 & (~opcode[6] |
               ~net_1136)) | net_28) & ((~opcode[12] | ~net_971) &
               (~net_510 | ~net_22))))) | net_2302))));

   assign ex_ctl_nxt[4] = (((((~net_333 | ~(~ex_ctl[4] | ~(net_820
               & net_197))) | ((net_958 & net_96) | (~int_preempt
               & ~(~(~net_1255 & ~(~net_1421 & ~(rb_sel_3_0 &
               net_954))) & ~(~(~(net_573 | (opcode[13] &
               net_1217)) | ~net_275) & ~data_abort))))) |
               ((net_205 & net_1408) | net_439)) | (((net_2302 &
               list_empty) & ((net_1316 & (net_815 | (net_115 &
               net_2295))) | net_189)) | ((~(net_127 | ex_ctl[7])
               | ~(net_1399 | net_73)) | ((~(~((net_1396 &
               spu_ctl_raw[32]) & (list_elast & list_empty)) &
               ~(~(net_1392 & net_1393) | ~(~net_1391 |
               ~ex_ctl[5]))) | ~(net_1386 | net_8)) | ((net_958 &
               net_1383) | net_443))))) | ((net_1328 & (~(net_2302
               | (~net_273 | ~(~opcode[12] | ~net_338))) |
               ~(~net_1362 | ~(~(~(~(net_1370 | net_20) |
               ~(~net_784 | ~net_977)) & ~(net_1019 & net_1367)) |
               ~net_338)))) | (net_968 | ((((~net_969 &
               ~opcode[5]) & (~opcode[4] | ~opcode[6])) & net_28)
               | (~data_abort & ~(~((net_451 & (wr_sel_7777 &
               net_33)) | net_1348) & ~(net_774 &
               im30_sel_z8_6)))))));

   assign ex_ctl_nxt[5] = (~(((~(~(~(~(~net_1334 | ~net_154) |
               ~(~net_1333 | ~net_30)) & ~((((net_28 & opcode[9])
               & net_1330) & (opcode[8] & net_340)) | net_334)) |
               ~(net_1123 | net_328)) & ~((rb_sel_wr_ex &
               ((~(~net_917 | ~net_1320) | ~(~net_1317 |
               ~net_646)) | ((net_1316 & (net_686 | (net_2300 &
               (~ex_ctl[4] | ~svc_escalate)))) | ((~hdf_escalate &
               ~(~(~net_8 & ~net_1306) & ~(net_209 & ~net_38))) |
               (~(~net_1304 | ~spu_ctl_raw[31]) | ~(~net_646 |
               ~net_670)))))) | ((net_378 & ((net_1296 &
               rb_sel_list) | (net_1292 & ((ex_last & net_273) &
               (~opcode[12] | ~net_23))))) | (~(~(ex_ctl[7] &
               ((~(net_997 | list_empty) | ~(~spu_ctl_raw[31] |
               ~net_745)) | (net_470 & net_1286))) &
               ~((~hdf_escalate & ~(~(net_1274 | ((rb_sel_wr_ex &
               net_2300) | (spu_ctl_raw[32] & ((rb_sel_sp &
               (net_926 | net_927)) | (data_abort & net_2295)))))
               | ~net_205)) | (~net_770 & ~(~net_340 | ~(net_24 &
               net_977))))) | ~(net_631 | net_980))))) &
               ((((net_1256 & net_614) & (net_788 | net_1255)) &
               (~net_1252 | ~net_2299)) | int_preempt)) &
               (((((net_1150 & net_938) & (~rb_sel_sp | ~net_850))
               & ((net_1237 & ((net_37 | net_1244) & (~(~net_8 &
               ~(special | (net_18 | opcode[13]))) | ~net_211))) &
               (net_1090 | ex_ctl[6]))) & (net_45 | ex_ctl[7])) &
               ((~net_349 | ~net_658) & (~net_815 | ~net_470)))) |
               ~(~opcode[12] | ~((~(((opcode[7] & (~opcode[6] |
               ~opcode[11])) | net_327) & (net_969 | (~net_1222 |
               ~net_971))) | ~(~(~data_abort & ~(~net_1217 &
               ~(~net_770 & ~net_24))) | ~(net_136 & net_275))) |
               (~net_436 & ~net_328))));

   assign ex_ctl_nxt[6] = (~((net_433 & (((net_733 & net_495) &
               (~valid_rfi | ~net_522)) & (int_preempt |
               (((((((~opcode[15] | ~(net_579 | (rb_sel_z8_6 &
               net_24))) & ((net_1195 & ((net_1199 & (~(~special &
               ~(net_22 | net_977)) | ~net_579)) & (~dbg_halt_req
               | ~ex_last))) & (opcode[14] | (((~net_579 &
               ~(~opcode[15] & ~(~ex_ctl[6] | ~rb_sel_sp))) &
               ((~special & ~(opcode[13] ^ opcode[12])) |
               net_2302)) & (~net_888 | ~opcode[3]))))) & (net_47
               | net_991)) & (~net_269 | ~(~(((~opcode[10] &
               ~(opcode[7] ^ opcode[9])) | opcode[11]) &
               (~opcode[13] | ~(~net_1177 & ~opcode[4]))) |
               ~(~opcode[12] | ~((~opcode[10] & ~(~net_1173 &
               ~net_1113)) | (~(net_451 | debug_en) | ~(net_24 |
               net_1059))))))) & ((((~(~net_24 & ~(~net_269 |
               ~net_1161)) | ~opcode[13]) & (~ex_ctl[5] |
               ~(~(wfi_adv | net_434) | ~(~(net_890 & net_658) |
               ~ex_ctl[1])))) & (~net_803 | ~net_1003)) &
               ((((((net_718 | net_1150) & (~net_204 | ~net_816))
               & (net_86 | ex_last)) | list_empty) &
               (~rb_sel_wr_ex | ~(~((~net_181 | ~net_670) &
               (~net_204 | ~net_2304)) | ~net_655))) & (~rb_sel_sp
               | ~(((net_2300 & (hdf_escalate & svc_escalate)) |
               ex_ctl[5]) | ((net_1136 & spu_ctl_raw[28]) |
               ex_ctl[1])))))) & (special | (((((net_1079 |
               atomic) & (net_331 | net_770)) & net_1123) &
               (((~net_1121 | ~rb_sel_z8_6) & (~net_1120 |
               ~opcode[14])) & net_1117)) & (~net_579 |
               ~(~((net_455 ^ net_24) & ((~net_1113 | ~net_22) &
               (opcode[9] | net_28))) | ~(~opcode[8] |
               ~net_27)))))) & net_1100)))) & (net_1084 | net_73))
               | ~(~ex_ctl[7] | ~(~(net_1090 & (list_empty |
               (net_1084 | ex_ctl[0]))) | ~(net_536 | net_33))));

   assign ex_ctl_nxt[7] = (~((((((((net_75 | net_1084) &
               (~net_1078 | ~net_40)) & net_1081) & (((net_1079 |
               net_61) & (~net_1078 | ~spu_ctl_raw[32])) &
               (((net_1075 | net_1039) | ex_ctl[3]) & (~wr_use_sp
               | ~net_1073)))) & (((~net_719 | ~net_2299) &
               ((~net_269 | ~(~(net_1059 & ((((net_28 & opcode[5])
               & (~opcode[11] | ~net_1066)) & net_2308) &
               (opcode[13] & net_1019))) | ~(net_24 |
               opcode[11]))) & (net_2299 | net_782))) & (net_47 |
               ex_ctl[6]))) & (net_2302 | ((~net_477 & ~net_1047)
               & (net_5 | net_19)))) & net_147) & (((net_1028 &
               ((net_316 | (ex_ctl[5] & ex_ctl[7])) & (~ex_ctl[7]
               | ~((~(net_1039 | sleep_rfi) | ~(~net_890 |
               ~spu_ctl_raw[31])) | ((net_218 & net_2302) |
               net_1036))))) & (~rb_sel_sp | ~spu_ctl_raw[32])) &
               net_737)) | ~(((net_1011 & (~rb_sel_z5_3 |
               ~(~(((net_19 & net_1022) & (~net_457 | ~net_23)) &
               (opcode[7] | (net_1019 | net_338))) | ~net_1015)))
               & (net_338 | ~rb_sel_z8_6)) | net_2308));

   assign ex_idle  = (~net_1005 | ~net_288);

   assign ex_last_nxt = ((list_empty & ((net_897 & (net_623 |
               (ex_ctl[0] & ((~data_abort & ~(~spu_ctl_raw[32] |
               ~net_499)) | (net_1003 & list_elast))))) |
               (~(net_997 | ex_ctl[0]) | ~(~net_312 |
               ~exnum_sel_bus)))) | ((~(~(~(net_150 | net_991) |
               ~(~net_990 | ~net_1)) & ~((~ex_ctl[7] & ~(~net_897
               | ~wfe_adv)) | (spu_ctl_raw[32] & (net_986 |
               net_743)))) | ~(net_60 | net_980)) | ((net_340 &
               (((net_22 & net_794) | (~opcode[8] & ~net_977)) |
               (opcode[8] & net_23))) | (((~net_969 & ~(opcode[5]
               & net_971)) | net_968) | ((net_958 & (((ex_ctl[0] &
               (net_204 & ex_ctl[5])) | (~(~wfi_adv | ~net_2300) |
               ~(~smul_last | ~net_2295))) | net_961)) |
               (~(~net_952 | ~(net_954 & (net_22 | (opcode[9] &
               net_957)))) | ~(net_951 | cc_pass)))))));

   assign exnum_en = (~(((net_938 & net_175) & (net_306 |
               ex_ctl[6])) & (net_681 | (net_2305 | net_2299))) |
               ~net_932);

   assign exnum_sel_bus = (net_2300 & spu_ctl_raw[28]);

   assign exnum_sel_int = (net_930 | net_198);

   assign hdf_request_raw = (~(hdf_escalate | (((net_879 |
               (~rb_sel_wr_ex | ~(net_670 & net_209))) & net_673)
               & (net_857 | net_912))) | ~(~svc_escalate |
               ~net_302));

   assign hwrite   = (~net_891 | ~(((net_304 & ((~net_204 |
               ~net_2303) | (net_38 | net_476))) & net_468) &
               ((net_898 & (~net_670 | ~(~net_68 & ~net_126))) &
               net_486)));

   assign iaex_agu = (net_888 | (net_890 & net_2296));

   assign iaex_en  = ((~((((~net_107 | ~(~net_71 & ~net_257)) &
               (~net_886 | ~spu_ctl_raw[29])) & (~ex_ctl[3] |
               ~(net_646 & net_115))) & (~net_211 | ~(ex_ctl[7] |
               (~net_879 | ~(~net_670 & ~net_652))))) |
               ~(~((spu_ctl_raw[21] & (net_853 & hdf_escalate)) |
               (~(~(rb_sel_wr_ex & net_181) | ~net_2304) |
               ~(~net_646 | ~net_2296))) | ~net_2299)) |
               ((ex_ctl[4] & (((hdf_escalate & ((spu_ctl_raw[32] &
               ((~net_864 & ~(~ex_ctl[3] | ~net_136)) | (net_205 &
               (~net_862 | ~(~opcode[14] | ~net_538))))) |
               (~net_36 & ~net_857))) | (net_853 & net_2303)) |
               ((~(~net_850 | ~ex_ctl[0]) | ~(~net_719 |
               ~data_abort)) | (~(~net_601 & ~(~(~net_686 |
               ~net_378) | ~(~net_745 | ~net_353))) | ~net_434))))
               | (~(~net_835 & ~((spu_ctl_raw[30] & ex_ctl[0]) &
               (net_658 & int_preempt))) | ~(~hdf_escalate |
               net_834))));

   assign iaex_spu = (~net_495 | ~(~ex_ctl[5] | ~net_102));

   assign im30_en  = ((((~net_33 & ~(net_29 | net_825)) | net_823)
               | (((int_delay & net_743) & net_2295) |
               ((~(~net_713 | ~net_820) | ~(~net_819 | ~net_718))
               | ((net_815 & net_816) | (~net_54 & ~net_316))))) |
               (net_580 | ((~(~int_preempt | ~net_197) |
               ~(~net_547 | ~opcode[10])) | net_704)));

   assign im30_sel_2_0z = (net_154 & (rb_sel_z8_6 | (net_269 &
               net_19)));

   assign im30_sel_3_0 = ((~net_696 | ~(~net_459 | ~(net_154 &
               net_254))) | ((net_205 & rb_sel_sp) | net_754));

   assign im30_sel_8_6z = im74_sel_z10_9;

   assign im30_sel_9_6 = (~((net_14 | net_689) & (~im30_sel_z8_6 |
               ~net_19)) | ~net_687);

   assign im30_sel_eight = (net_522 | (~ex_ctl[6] & ~net_45));

   assign im30_sel_exnum = (net_743 | (net_745 & net_76));

   assign im30_sel_incr = (~net_692 | ~((net_680 | ~net_498) &
               (net_76 | net_150)));

   assign im30_sel_list = (~((net_6 | net_737) | net_19) |
               ~(net_22 | net_449));

   assign im30_sel_one = (~((net_732 & net_733) & (net_37 |
               ex_ctl[5])) | ~(((~net_579 | ~net_2307) | net_6) &
               (net_150 | (~ex_ctl[1] | ~net_2300))));

   assign im30_sel_seven = (~net_604 | ~(ex_ctl[5] | net_723));

   assign im30_sel_z8_6 = (~int_preempt & ~(~rb_sel_z8_6 |
               ~net_2309));

   assign im74_en  = (net_704 | (~net_264 | ~(((~net_470 |
               ~(net_715 | (exnum_sel_bus & list_empty))) &
               ((net_546 | opcode[13]) & (~net_44 | ~net_713))) &
               (net_70 | net_257))));

   assign im74_sel_6_3 = (wr_sel_10_7 | (rb_sel_z8_6 & net_154));

   assign im74_sel_7_4 = (~net_696 | ~(((~opcode[10] |
               ~im74_sel_z6_4) & (~net_701 | ~(net_137 &
               net_154))) & net_158));

   assign im74_sel_excp = wr_sel_excp;

   assign im74_sel_exnum = (~(net_175 & net_45) | ~net_536);

   assign im74_sel_list = (~(net_692 & net_147) | ~(~net_205 |
               ~rb_sel_list));

   assign im74_sel_z10 = (~net_687 | ~(~net_459 | net_689));

   assign im74_sel_z10_9 = (net_153 & net_136);

   assign im74_sel_z6_4 = (~net_436 & ~net_8);

   assign instr_rfi = (~((~net_378 | ~net_235) | net_55) |
               ~(net_684 | net_655));

   assign int_return = (~net_65 & ~net_604);

   assign int_taken = (~net_680 & ~net_681);

   assign interwork = (net_120 | (net_676 | ((spu_ctl_raw[29] &
               ex_ctl[1]) | net_679)));

   assign lockup   = ((hdf_escalate & (~net_673 | ~net_674)) |
               (~((net_2303 | net_61) | net_45) | ~(~(rb_sel_wr_ex
               & (((net_136 & net_113) & (hdf_escalate & net_670))
               | (net_667 & net_115))) | ~spu_ctl_raw[32])));

   assign ls_size_raw[0] = (~net_655 | ~(~net_2299 | ~(net_658 |
               net_2295)));

   assign ls_size_raw[1] = (net_647 | (~(~net_653 & ~(net_363 &
               net_368)) | ~(~net_651 | ~net_652)));

   assign msr_en   = (~(net_495 | spu_ctl_raw[28]) |
               ~(~(spu_ctl_raw[31] & net_646) | ~net_2300));

   assign mul_ctl  = (~(net_642 | int_preempt) | ~(~net_371 |
               ~net_191));

   assign nzflag_en = (~(~spu_ctl_raw[30] | ~net_639) | ~(~ex_last
               | ~(net_238 | ((~net_636 | ~(~ex_ctl[4] |
               ~(spu_ctl_raw[21] & net_2296))) | (~((net_634 &
               net_635) & (net_59 | ex_ctl[6])) | ~net_631)))));

   assign psp_sel_auto = (~((~net_623 & ~net_522) & (net_43 |
               ex_ctl[3])) | ~((~net_30 | ~spu_ctl_raw[32]) &
               (spu_ctl_raw[28] | (atomic & net_620))));

   assign psp_sel_en = (~(~(~(net_614 | atomic) | ~(~net_613 |
               ~net_386)) & ~(~(~net_554 & ~(~net_608 | ~net_609))
               | ~(((~net_605 & ~net_606) & (net_604 | ex_ctl[4]))
               & (~net_601 | ~wr_use_sp)))) | ~(net_30 | net_594));

   assign psp_sel_nxt = (~(~(net_205 & spu_ctl_raw[28]) |
               ~opcode[0]) | ~(~(net_590 & net_560) | ~opcode[3]));

   assign ra_addr_en = (~(((~net_580 & ~(~((~net_579 | ~net_551) &
               (opcode[8] | (~net_275 | ~net_22))) | ~(net_42 |
               ex_ctl[7]))) & (net_477 | (((~net_575 &
               ~(~(~net_459 | ~net_20) | ~(~net_579 | ~net_24))) &
               (~net_573 | ~net_574)) & (~(~opcode[15] &
               ~net_2302) | ~(net_570 | opcode[7]))))) & (~net_554
               | ~((opcode[0] & (~net_562 | ~net_30)) |
               (~(~net_560 & ~net_2309) | ~(opcode[3] |
               opcode[1]))))) | ~net_283);

   assign ra_sel_7_2_0 = (~(~opcode[10] | ~ra_sel_z2_0) |
               ~(net_536 | opcode[3]));

   assign ra_sel_pc = (~((((~net_205 | ~net_517) | opcode[11]) &
               (net_29 | net_536)) & (~net_533 | ~net_525)) |
               ~(~ra_sel_z2_0 | ~(~net_19 | ~net_530)));

   assign ra_sel_sp = (net_517 | ((atomic & (spu_ctl_raw[28] |
               opcode[3])) | ((net_525 & (net_23 | net_2307)) |
               net_522)));

   assign ra_sel_z10_8 = (net_205 & (net_515 | (opcode[14] &
               opcode[15])));

   assign ra_sel_z2_0 = ((net_533 & net_138) & net_2309);

   assign ra_sel_z5_3 = (net_205 & ((~(net_513 | net_23) |
               ~(~net_138 | ~net_2308)) | ((net_510 & opcode[12])
               | net_286)));

   assign ra_use_aux = (net_490 | ((atomic & (spu_ctl_raw[21] |
               net_505)) | (~((((net_65 | net_403) |
               spu_ctl_raw[29]) & (~net_208 | ~ex_ctl[0])) &
               (~net_498 | ~net_499)) | ~net_495)));

   assign rb_addr_en = (~(((net_75 | net_258) & (net_486 &
               (int_preempt | (net_489 | net_56)))) & (net_483 |
               net_150)) | ~(~net_439 & ~(~(((net_477 |
               (~im30_sel_z8_6 | ~(opcode[14] | net_480))) &
               ((((net_476 | net_150) & (~net_210 | ~int_preempt))
               & net_473) & ((net_468 & (~net_470 | ~(~net_2295 &
               ~ex_ctl[3]))) & net_282))) & (net_18 | (((~net_459
               | ~net_460) & (~(~opcode[5] & ~(~net_457 |
               ~(wr_sel_10_7 & opcode[12]))) | ~net_455)) &
               (net_449 | (net_26 | net_451))))) | ~(~opcode[3] |
               ~net_443))));

   assign rb_sel_3_0 = (~opcode[10] & ~net_436);

   assign rb_sel_6_3 = (opcode[10] & (rb_sel_z5_3 | ~net_436));

   assign rb_sel_aux = (~net_433 | ~net_434);

   assign rb_sel_list = (net_653 & net_2298);

   assign rb_sel_sp = (ex_ctl[4] & net_2302);

   assign rb_sel_wr_ex = (ex_ctl[3] & net_2302);

   assign rb_sel_z5_3 = (~opcode[12] & ~net_2302);

   assign rb_sel_z8_6 = (opcode[12] & net_459);

   assign spu_ctl_raw[0] = ((net_2300 & (~net_356 | ~net_2296)) |
               net_372);

   assign spu_ctl_raw[1] = (~((net_418 | ex_ctl[0]) & (~ex_ctl[3]
               | ~net_427)) | ~(net_384 | net_420));

   assign spu_ctl_raw[10] = (spu_ctl_raw[13] | (~net_407 &
               ~(net_418 & (net_52 | net_420))));

   assign spu_ctl_raw[11] = (~net_390 | ~(net_389 | net_407));

   assign spu_ctl_raw[12] = (~(~spu_ctl_raw[21] & ~(~net_385 &
               ~(net_52 | net_407))) | ~(~net_2296 | ~(net_382 &
               ex_last)));

   assign spu_ctl_raw[13] = (~net_67 | ~(net_70 | net_71));

   assign spu_ctl_raw[14] = (~(~net_357 & ~(~net_394 & ~(net_219 &
               net_396))) | ~net_73);

   assign spu_ctl_raw[15] = spu_ctl_raw[21];

   assign spu_ctl_raw[16] = (~net_390 | ~(net_219 | net_385));

   assign spu_ctl_raw[17] = 1'b0;

   assign spu_ctl_raw[18] = spu_ctl_raw[21];

   assign spu_ctl_raw[19] = spu_ctl_raw[24];

   assign spu_ctl_raw[2] = (~net_389 & net_181);

   assign spu_ctl_raw[20] = spu_ctl_raw[23];

   assign spu_ctl_raw[21] = (ex_ctl[0] & ex_ctl[3]);

   assign spu_ctl_raw[22] = spu_ctl_raw[17];

   assign spu_ctl_raw[23] = (ex_ctl[1] & exnum_sel_bus);

   assign spu_ctl_raw[24] = (net_2298 | ((ex_ctl[0] & net_2296) |
               net_2302));

   assign spu_ctl_raw[25] = ((ex_ctl[7] & (net_211 | net_378)) |
               atomic);

   assign spu_ctl_raw[26] = (~spu_ctl_raw[32] | ~net_72);

   assign spu_ctl_raw[27] = (net_386 | net_299);

   assign spu_ctl_raw[28] = ~ex_ctl[3];

   assign spu_ctl_raw[29] = ex_ctl[2];

   assign spu_ctl_raw[3] = (net_382 | (~net_384 & ~net_385));

   assign spu_ctl_raw[30] = (~ex_ctl[7] & ~ex_ctl[5]);

   assign spu_ctl_raw[31] = (~ex_ctl[1] & ~net_2299);

   assign spu_ctl_raw[32] = ~spu_ctl_raw[29];

   assign spu_ctl_raw[4] = (net_372 | (~(~net_2301 | ~net_2304) |
               ~(~ex_ctl[1] | ~net_75)));

   assign spu_ctl_raw[5] = (~((~(net_378 & net_2302) & ~net_377) &
               (~net_129 | ~net_2296)) | ~net_2304);

   assign spu_ctl_raw[6] = (~net_298 | ~(~exnum_sel_bus |
               ~net_371));

   assign spu_ctl_raw[7] = spu_ctl_raw[8];

   assign spu_ctl_raw[8] = (~(~ex_last | ~(net_197 & ex_ctl[5])) |
               ~net_122);

   assign spu_ctl_raw[9] = (~(~net_357 & ~((net_365 & (~net_64 |
               ~net_219)) | (net_2299 | ((net_364 & net_51) |
               net_363)))) | ~(ex_ctl[1] | net_356));

   assign spu_en_nxt = (~(((~net_334 & ~(~(((int_delay |
               (~alu_ctl_raw[19] | ~(net_353 & atomic))) &
               (((net_316 | net_61) | ex_ctl[0]) & (~net_349 |
               ~spu_ctl_raw[32]))) & (net_67 | net_150)) |
               ~(net_338 | (~net_340 | (net_342 ^ opcode[7]))))) &
               net_333) & (net_321 & ((net_328 | ((net_14 &
               net_331) | opcode[14])) & (net_325 | (net_327 |
               net_2306))))) | ~(~spu_ctl_raw[31] | ~(~(net_314 &
               (net_316 | (net_318 & net_54))) | ~(~net_312 |
               ~net_313))));

   assign stk_align_en = (~net_304 | ~(net_68 | net_306));

   assign svc_request = (~svc_escalate & ~(~net_302 & ~net_303));

   assign txev     = (net_299 & (~net_2298 & ~net_89));

   assign vflag_en = (~net_292 | ~(((~ex_ctl[4] |
               ~spu_ctl_raw[30]) | net_298) & (net_65 | net_296)));

   assign wfe_execute = (ex_ctl[3] & (alu_ctl_raw[16] & net_2299));

   assign wfi_execute = (~((~alu_ctl_raw[18] & ~(~net_71 &
               ~net_89)) | ex_ctl[4]) | ~net_288);

   assign wr_addr_raw_en = ((((ex_last & (net_285 & net_286)) |
               (~(net_282 & net_283) | ~((~net_113 | ~special) |
               net_281))) | ((net_274 & net_275) | (~net_264 |
               ~((((~debug_en | ~net_273) & (net_26 | opcode[11]))
               | dbg_halt_req) | (~net_268 | ~net_269))))) |
               (net_243 | (~(((net_258 | net_259) & (net_68 |
               net_257)) & (net_2302 | ((~(net_33 & (special |
               net_254)) & ~(~net_2306 & ~net_18)) | net_2308))) |
               ~net_246)));

   assign wr_en    = ((net_2304 & (((spu_ctl_raw[30] & (ex_ctl[4]
               | net_240)) | (spu_ctl_raw[31] & net_238)) |
               ((net_2303 & ((net_93 & net_2298) | (int_preempt &
               net_235))) | (~(~(ex_ctl[4] & net_181) |
               ~ex_ctl[0]) | ~(~(net_198 & net_2300) |
               ~data_abort))))) | ((net_211 & (((net_2295 &
               (net_221 | (ex_ctl[7] & net_2300))) | ((~net_2298 &
               ~net_219) | net_218)) | (net_97 & net_2296))) |
               (((~(~net_210 | ~spu_ctl_raw[31]) | ~(~net_208 |
               ~net_209)) | ((spu_ctl_raw[29] & (((net_205 &
               ex_ctl[3]) & (spu_ctl_raw[31] & net_204)) |
               (~(net_199 & (net_61 | (~net_113 |
               ~spu_ctl_raw[21]))) | ~(~net_197 | ~net_198)))) |
               ((spu_ctl_raw[32] & (net_191 & net_182)) |
               net_189))) | ((net_2303 & (alu_ctl_raw[17] &
               ex_ctl[7])) | (~((~(~(net_45 | net_70) | ~(~net_181
               | ~net_182)) & ~(~int_preempt & ~(~alu_ctl_raw[18]
               | ~ex_ctl[6]))) & net_175) | ~(~net_172 |
               ~net_173))))));

   assign wr_sel_10_7 = (~int_preempt & ~net_1100);

   assign wr_sel_11_8 = (~((~net_141 | ~special) & (~net_135 |
               ~net_161)) | ~net_158);

   assign wr_sel_3_0 = (~(~(~opcode[9] | ~(net_22 | opcode[11])) |
               ~net_135) | ~(~net_153 | ~net_154));

   assign wr_sel_7777 = (~net_758 & ~net_6);

   assign wr_sel_excp = (net_522 | (atomic & net_695));

   assign wr_sel_list = (~(~net_148 & ~(~ex_ctl[4] & ~net_150)) |
               ~net_147);

   assign wr_sel_z10_8 = (~(~net_144 & ~(~opcode[12] & ~net_7)) |
               ~net_143);

   assign wr_sel_z2_0 = ((~net_138 & ~(~net_140 | ~net_141)) |
               (~(~net_136 | ~net_137) | ~(~net_135 | ~net_22)));

   assign wr_use_list = (~(net_127 & (~net_129 | ~net_130)) |
               ~(spu_ctl_raw[29] | (net_126 | ex_last)));

   assign wr_use_lr = (net_120 | (~ex_last & ~net_122));

   assign wr_use_ra = (~net_98 | ~(((~net_117 | ~(~net_72 |
               ~(atomic | ex_ctl[4]))) & ((((~net_115 &
               ~(~spu_ctl_raw[28] & ~ex_ctl[7])) | ex_ctl[5]) &
               ((~net_2299 | ~net_113) & (net_2298 | net_112))) &
               (~net_107 | ~net_2298))) & (~net_102 |
               ~spu_ctl_raw[32])));

   assign wr_use_sp = (net_816 & spu_ctl_raw[29]);

   assign wr_use_wr = (~(net_87 & (net_89 & (net_2302 |
               (~(~(~net_97 | ~ex_ctl[7]) | ~(~net_96 |
               ~ex_ctl[6])) & ~net_93)))) | ~(net_2298 | net_86));


endmodule // cm0_core_dec

//-----------------------------------------------------------------------------
// EOF
//-----------------------------------------------------------------------------
