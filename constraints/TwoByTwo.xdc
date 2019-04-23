create_pblock pblock_testOsc
add_cells_to_pblock [get_pblocks pblock_testOsc] [get_cells -quiet [list adpll_11/testOsc]]
resize_pblock [get_pblocks pblock_testOsc] -add {SLICE_X62Y96:SLICE_X67Y97}
create_pblock pblock_pDetLeft
add_cells_to_pblock [get_pblocks pblock_pDetLeft] [get_cells -quiet [list adpll_11/pDetLeft]]
resize_pblock [get_pblocks pblock_pDetLeft] -add {SLICE_X58Y86:SLICE_X61Y91}
create_pblock pblock_div8
resize_pblock [get_pblocks pblock_div8] -add {SLICE_X64Y94:SLICE_X67Y95}
create_pblock pblock_loopFilter
add_cells_to_pblock [get_pblocks pblock_loopFilter] [get_cells -quiet [list adpll_11/loopFilter]]
resize_pblock [get_pblocks pblock_loopFilter] -add {SLICE_X62Y86:SLICE_X67Y93}
create_pblock pblock_errorCombiner
add_cells_to_pblock [get_pblocks pblock_errorCombiner] [get_cells -quiet [list adpll_11/errorCombiner]]
resize_pblock [get_pblocks pblock_errorCombiner] -add {SLICE_X58Y80:SLICE_X67Y85}
create_pblock pblock_testOsc_1
add_cells_to_pblock [get_pblocks pblock_testOsc_1] [get_cells -quiet [list adpll_12/testOsc]]
resize_pblock [get_pblocks pblock_testOsc_1] -add {SLICE_X72Y96:SLICE_X77Y97}
create_pblock pblock_pDetLeft_1
add_cells_to_pblock [get_pblocks pblock_pDetLeft_1] [get_cells -quiet [list adpll_12/pDetLeft]]
resize_pblock [get_pblocks pblock_pDetLeft_1] -add {SLICE_X68Y86:SLICE_X71Y91}
create_pblock pblock_loopFilter_1
add_cells_to_pblock [get_pblocks pblock_loopFilter_1] [get_cells -quiet [list adpll_12/loopFilter]]
resize_pblock [get_pblocks pblock_loopFilter_1] -add {SLICE_X72Y86:SLICE_X77Y93}
create_pblock pblock_errorCombiner_1
add_cells_to_pblock [get_pblocks pblock_errorCombiner_1] [get_cells -quiet [list adpll_12/errorCombiner]]
resize_pblock [get_pblocks pblock_errorCombiner_1] -add {SLICE_X68Y80:SLICE_X77Y85}
create_pblock pblock_div8_1
resize_pblock [get_pblocks pblock_div8_1] -add {SLICE_X74Y94:SLICE_X77Y95}

create_pblock pblock_errorCombiner_2
add_cells_to_pblock [get_pblocks pblock_errorCombiner_2] [get_cells -quiet [list adpll_21/errorCombiner]]
resize_pblock [get_pblocks pblock_errorCombiner_2] -add {SLICE_X58Y69:SLICE_X67Y74}
create_pblock pblock_loopFilter_2
add_cells_to_pblock [get_pblocks pblock_loopFilter_2] [get_cells -quiet [list adpll_21/loopFilter]]
resize_pblock [get_pblocks pblock_loopFilter_2] -add {SLICE_X62Y61:SLICE_X67Y68}
create_pblock pblock_div8_2
resize_pblock [get_pblocks pblock_div8_2] -add {SLICE_X64Y59:SLICE_X67Y60}
create_pblock pblock_pDetAbove
add_cells_to_pblock [get_pblocks pblock_pDetAbove] [get_cells -quiet [list adpll_21/pDetAbove]]
resize_pblock [get_pblocks pblock_pDetAbove] -add {SLICE_X62Y75:SLICE_X67Y78}
create_pblock pblock_testOsc_2
add_cells_to_pblock [get_pblocks pblock_testOsc_2] [get_cells -quiet [list adpll_21/testOsc]]
resize_pblock [get_pblocks pblock_testOsc_2] -add {SLICE_X62Y57:SLICE_X67Y58}
create_pblock pblock_pDetAbove_1
add_cells_to_pblock [get_pblocks pblock_pDetAbove_1] [get_cells -quiet [list adpll_22/pDetAbove]]
resize_pblock [get_pblocks pblock_pDetAbove_1] -add {SLICE_X72Y75:SLICE_X77Y78}
create_pblock pblock_errorCombiner_3
add_cells_to_pblock [get_pblocks pblock_errorCombiner_3] [get_cells -quiet [list adpll_22/errorCombiner]]
resize_pblock [get_pblocks pblock_errorCombiner_3] -add {SLICE_X68Y69:SLICE_X77Y74}
create_pblock pblock_loopFilter_3
add_cells_to_pblock [get_pblocks pblock_loopFilter_3] [get_cells -quiet [list adpll_22/loopFilter]]
resize_pblock [get_pblocks pblock_loopFilter_3] -add {SLICE_X72Y61:SLICE_X77Y68}
create_pblock pblock_div8_3
resize_pblock [get_pblocks pblock_div8_3] -add {SLICE_X74Y59:SLICE_X77Y60}
create_pblock pblock_testOsc_3
add_cells_to_pblock [get_pblocks pblock_testOsc_3] [get_cells -quiet [list adpll_22/testOsc]]
resize_pblock [get_pblocks pblock_testOsc_3] -add {SLICE_X72Y57:SLICE_X77Y58}

create_pblock pblock_pDetLeft_2
add_cells_to_pblock [get_pblocks pblock_pDetLeft_2] [get_cells -quiet [list adpll_22/pDetLeft]]
resize_pblock [get_pblocks pblock_pDetLeft_2] -add {SLICE_X68Y63:SLICE_X71Y68}

create_pblock pblock_pDetLeft_3
add_cells_to_pblock [get_pblocks pblock_pDetLeft_3] [get_cells -quiet [list adpll_21/pDetLeft]]
resize_pblock [get_pblocks pblock_pDetLeft_3] -add {SLICE_X58Y63:SLICE_X61Y68}
create_pblock pblock_pDetAbove_2
add_cells_to_pblock [get_pblocks pblock_pDetAbove_2] [get_cells -quiet [list adpll_11/pDetAbove]]
resize_pblock [get_pblocks pblock_pDetAbove_2] -add {SLICE_X62Y99:SLICE_X67Y102}
create_pblock pblock_pDetAbove_3
add_cells_to_pblock [get_pblocks pblock_pDetAbove_3] [get_cells -quiet [list adpll_12/pDetAbove]]
resize_pblock [get_pblocks pblock_pDetAbove_3] -add {SLICE_X72Y99:SLICE_X77Y102}

create_pblock pblock_pDetAbove_4
add_cells_to_pblock [get_pblocks pblock_pDetAbove_4] [get_cells -quiet [list adpll_13/pDetAbove]]
resize_pblock [get_pblocks pblock_pDetAbove_4] -add {SLICE_X82Y100:SLICE_X87Y103}
create_pblock pblock_pDetLeft_4
add_cells_to_pblock [get_pblocks pblock_pDetLeft_4] [get_cells -quiet [list adpll_13/pDetLeft]]
resize_pblock [get_pblocks pblock_pDetLeft_4] -add {SLICE_X78Y86:SLICE_X81Y91}
create_pblock pblock_loopFilter_4
add_cells_to_pblock [get_pblocks pblock_loopFilter_4] [get_cells -quiet [list adpll_13/loopFilter]]
resize_pblock [get_pblocks pblock_loopFilter_4] -add {SLICE_X82Y86:SLICE_X87Y93}
create_pblock pblock_errorCombiner_4
add_cells_to_pblock [get_pblocks pblock_errorCombiner_4] [get_cells -quiet [list adpll_13/errorCombiner]]
resize_pblock [get_pblocks pblock_errorCombiner_4] -add {SLICE_X78Y80:SLICE_X87Y85}
create_pblock pblock_testOsc_4
add_cells_to_pblock [get_pblocks pblock_testOsc_4] [get_cells -quiet [list adpll_13/testOsc]]
resize_pblock [get_pblocks pblock_testOsc_4] -add {SLICE_X82Y96:SLICE_X87Y97}
create_pblock pblock_pDetAbove_5
add_cells_to_pblock [get_pblocks pblock_pDetAbove_5] [get_cells -quiet [list adpll_23/pDetAbove]]
resize_pblock [get_pblocks pblock_pDetAbove_5] -add {SLICE_X82Y75:SLICE_X87Y78}
create_pblock pblock_errorCombiner_5
add_cells_to_pblock [get_pblocks pblock_errorCombiner_5] [get_cells -quiet [list adpll_23/errorCombiner]]
resize_pblock [get_pblocks pblock_errorCombiner_5] -add {SLICE_X78Y69:SLICE_X87Y74}
create_pblock pblock_loopFilter_5
add_cells_to_pblock [get_pblocks pblock_loopFilter_5] [get_cells -quiet [list adpll_23/loopFilter]]
resize_pblock [get_pblocks pblock_loopFilter_5] -add {SLICE_X82Y61:SLICE_X87Y68}
create_pblock pblock_pDetLeft_5
add_cells_to_pblock [get_pblocks pblock_pDetLeft_5] [get_cells -quiet [list adpll_23/pDetLeft]]
resize_pblock [get_pblocks pblock_pDetLeft_5] -add {SLICE_X78Y63:SLICE_X81Y68}
create_pblock pblock_testOsc_5
add_cells_to_pblock [get_pblocks pblock_testOsc_5] [get_cells -quiet [list adpll_23/testOsc]]
resize_pblock [get_pblocks pblock_testOsc_5] -add {SLICE_X82Y57:SLICE_X87Y58}
create_pblock pblock_pDetAbove_6
add_cells_to_pblock [get_pblocks pblock_pDetAbove_6] [get_cells -quiet [list adpll_33/pDetAbove]]
resize_pblock [get_pblocks pblock_pDetAbove_6] -add {SLICE_X72Y51:SLICE_X77Y54}
create_pblock pblock_errorCombiner_6
add_cells_to_pblock [get_pblocks pblock_errorCombiner_6] [get_cells -quiet [list adpll_33/errorCombiner]]
resize_pblock [get_pblocks pblock_errorCombiner_6] -add {SLICE_X68Y45:SLICE_X77Y50}
create_pblock pblock_loopFilter_6
add_cells_to_pblock [get_pblocks pblock_loopFilter_6] [get_cells -quiet [list adpll_33/loopFilter]]
resize_pblock [get_pblocks pblock_loopFilter_6] -add {SLICE_X72Y37:SLICE_X77Y44}
create_pblock div8_5
create_pblock pblock_pDetLeft_6
add_cells_to_pblock [get_pblocks pblock_pDetLeft_6] [get_cells -quiet [list adpll_33/pDetLeft]]
resize_pblock [get_pblocks pblock_pDetLeft_6] -add {SLICE_X68Y39:SLICE_X71Y44}
create_pblock pblock_testOsc_6
add_cells_to_pblock [get_pblocks pblock_testOsc_6] [get_cells -quiet [list adpll_33/testOsc]]
resize_pblock [get_pblocks pblock_testOsc_6] -add {SLICE_X72Y33:SLICE_X77Y34}
create_pblock pblock_pDetAbove_7
add_cells_to_pblock [get_pblocks pblock_pDetAbove_7] [get_cells -quiet [list adpll_32/pDetAbove]]
resize_pblock [get_pblocks pblock_pDetAbove_7] -add {SLICE_X62Y51:SLICE_X67Y54}
create_pblock pblock_errorCombiner_7
add_cells_to_pblock [get_pblocks pblock_errorCombiner_7] [get_cells -quiet [list adpll_32/errorCombiner]]
resize_pblock [get_pblocks pblock_errorCombiner_7] -add {SLICE_X58Y45:SLICE_X67Y50}
create_pblock pblock_loopFilter_7
add_cells_to_pblock [get_pblocks pblock_loopFilter_7] [get_cells -quiet [list adpll_32/loopFilter]]
resize_pblock [get_pblocks pblock_loopFilter_7] -add {SLICE_X62Y37:SLICE_X67Y44}
create_pblock pblock_pDetLeft_7
add_cells_to_pblock [get_pblocks pblock_pDetLeft_7] [get_cells -quiet [list adpll_32/pDetLeft]]
resize_pblock [get_pblocks pblock_pDetLeft_7] -add {SLICE_X58Y39:SLICE_X61Y44}
create_pblock pblock_testOsc_7
add_cells_to_pblock [get_pblocks pblock_testOsc_7] [get_cells -quiet [list adpll_32/testOsc]]
resize_pblock [get_pblocks pblock_testOsc_7] -add {SLICE_X62Y33:SLICE_X67Y34}
create_pblock pblock_pDetAbove_8
add_cells_to_pblock [get_pblocks pblock_pDetAbove_8] [get_cells -quiet [list adpll_31/pDetAbove]]
resize_pblock [get_pblocks pblock_pDetAbove_8] -add {SLICE_X52Y51:SLICE_X57Y54}
create_pblock pblock_errorCombiner_8
add_cells_to_pblock [get_pblocks pblock_errorCombiner_8] [get_cells -quiet [list adpll_31/errorCombiner]]
resize_pblock [get_pblocks pblock_errorCombiner_8] -add {SLICE_X48Y45:SLICE_X57Y50}
create_pblock pblock_loopFilter_8
add_cells_to_pblock [get_pblocks pblock_loopFilter_8] [get_cells -quiet [list adpll_31/loopFilter]]
resize_pblock [get_pblocks pblock_loopFilter_8] -add {SLICE_X52Y37:SLICE_X57Y44}
create_pblock pblock_pDetLeft_8
add_cells_to_pblock [get_pblocks pblock_pDetLeft_8] [get_cells -quiet [list adpll_31/pDetLeft]]
resize_pblock [get_pblocks pblock_pDetLeft_8] -add {SLICE_X48Y39:SLICE_X51Y44}
create_pblock pblock_testOsc_8
add_cells_to_pblock [get_pblocks pblock_testOsc_8] [get_cells -quiet [list adpll_31/testOsc]]
resize_pblock [get_pblocks pblock_testOsc_8] -add {SLICE_X52Y33:SLICE_X57Y34}
