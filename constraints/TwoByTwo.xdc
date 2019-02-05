create_pblock pblock_testOsc
add_cells_to_pblock [get_pblocks pblock_testOsc] [get_cells -quiet [list adpll_11/testOsc]]
resize_pblock [get_pblocks pblock_testOsc] -add {SLICE_X72Y96:SLICE_X77Y97}
create_pblock pblock_pDetLeft
add_cells_to_pblock [get_pblocks pblock_pDetLeft] [get_cells -quiet [list adpll_11/pDetLeft]]
resize_pblock [get_pblocks pblock_pDetLeft] -add {SLICE_X68Y86:SLICE_X71Y91}
create_pblock pblock_div8
add_cells_to_pblock [get_pblocks pblock_div8] [get_cells -quiet [list adpll_11/div8]]
resize_pblock [get_pblocks pblock_div8] -add {SLICE_X74Y94:SLICE_X77Y95}
create_pblock pblock_loopFilter
add_cells_to_pblock [get_pblocks pblock_loopFilter] [get_cells -quiet [list adpll_11/loopFilter]]
resize_pblock [get_pblocks pblock_loopFilter] -add {SLICE_X72Y86:SLICE_X77Y93}
create_pblock pblock_errorCombiner
add_cells_to_pblock [get_pblocks pblock_errorCombiner] [get_cells -quiet [list adpll_11/errorCombiner]]
resize_pblock [get_pblocks pblock_errorCombiner] -add {SLICE_X68Y80:SLICE_X77Y85}
create_pblock pblock_testOsc_1
add_cells_to_pblock [get_pblocks pblock_testOsc_1] [get_cells -quiet [list adpll_12/testOsc]]
resize_pblock [get_pblocks pblock_testOsc_1] -add {SLICE_X82Y96:SLICE_X87Y97}
create_pblock pblock_pDetLeft_1
add_cells_to_pblock [get_pblocks pblock_pDetLeft_1] [get_cells -quiet [list adpll_12/pDetLeft]]
resize_pblock [get_pblocks pblock_pDetLeft_1] -add {SLICE_X78Y86:SLICE_X81Y91}
create_pblock pblock_loopFilter_1
add_cells_to_pblock [get_pblocks pblock_loopFilter_1] [get_cells -quiet [list adpll_12/loopFilter]]
resize_pblock [get_pblocks pblock_loopFilter_1] -add {SLICE_X82Y86:SLICE_X87Y93}
create_pblock pblock_errorCombiner_1
add_cells_to_pblock [get_pblocks pblock_errorCombiner_1] [get_cells -quiet [list adpll_12/errorCombiner]]
resize_pblock [get_pblocks pblock_errorCombiner_1] -add {SLICE_X78Y80:SLICE_X87Y85}
create_pblock pblock_div8_1
add_cells_to_pblock [get_pblocks pblock_div8_1] [get_cells -quiet [list adpll_12/div8]]
resize_pblock [get_pblocks pblock_div8_1] -add {SLICE_X84Y94:SLICE_X87Y95}

create_pblock pblock_errorCombiner_2
add_cells_to_pblock [get_pblocks pblock_errorCombiner_2] [get_cells -quiet [list adpll_21/errorCombiner]]
resize_pblock [get_pblocks pblock_errorCombiner_2] -add {SLICE_X68Y69:SLICE_X77Y74}
create_pblock pblock_loopFilter_2
add_cells_to_pblock [get_pblocks pblock_loopFilter_2] [get_cells -quiet [list adpll_21/loopFilter]]
resize_pblock [get_pblocks pblock_loopFilter_2] -add {SLICE_X72Y61:SLICE_X77Y68}
create_pblock pblock_div8_2
add_cells_to_pblock [get_pblocks pblock_div8_2] [get_cells -quiet [list adpll_21/div8]]
resize_pblock [get_pblocks pblock_div8_2] -add {SLICE_X74Y59:SLICE_X77Y60}
create_pblock pblock_pDetAbove
add_cells_to_pblock [get_pblocks pblock_pDetAbove] [get_cells -quiet [list adpll_21/pDetAbove]]
resize_pblock [get_pblocks pblock_pDetAbove] -add {SLICE_X72Y76:SLICE_X77Y79}
create_pblock pblock_testOsc_2
add_cells_to_pblock [get_pblocks pblock_testOsc_2] [get_cells -quiet [list adpll_21/testOsc]]
resize_pblock [get_pblocks pblock_testOsc_2] -add {SLICE_X72Y57:SLICE_X77Y58}
create_pblock pblock_pDetAbove_1
add_cells_to_pblock [get_pblocks pblock_pDetAbove_1] [get_cells -quiet [list adpll_22/pDetAbove]]
resize_pblock [get_pblocks pblock_pDetAbove_1] -add {SLICE_X82Y76:SLICE_X87Y79}
create_pblock pblock_errorCombiner_3
add_cells_to_pblock [get_pblocks pblock_errorCombiner_3] [get_cells -quiet [list adpll_22/errorCombiner]]
resize_pblock [get_pblocks pblock_errorCombiner_3] -add {SLICE_X78Y69:SLICE_X87Y74}
create_pblock pblock_loopFilter_3
add_cells_to_pblock [get_pblocks pblock_loopFilter_3] [get_cells -quiet [list adpll_22/loopFilter]]
resize_pblock [get_pblocks pblock_loopFilter_3] -add {SLICE_X82Y61:SLICE_X87Y68}
create_pblock pblock_div8_3
add_cells_to_pblock [get_pblocks pblock_div8_3] [get_cells -quiet [list adpll_22/div8]]
resize_pblock [get_pblocks pblock_div8_3] -add {SLICE_X84Y59:SLICE_X87Y60}
create_pblock pblock_testOsc_3
add_cells_to_pblock [get_pblocks pblock_testOsc_3] [get_cells -quiet [list adpll_22/testOsc]]
resize_pblock [get_pblocks pblock_testOsc_3] -add {SLICE_X82Y57:SLICE_X87Y58}

create_pblock pblock_pDetLeft_2
add_cells_to_pblock [get_pblocks pblock_pDetLeft_2] [get_cells -quiet [list adpll_22/pDetLeft]]
resize_pblock [get_pblocks pblock_pDetLeft_2] -add {SLICE_X78Y63:SLICE_X81Y68}

create_pblock pblock_pDetLeft_3
add_cells_to_pblock [get_pblocks pblock_pDetLeft_3] [get_cells -quiet [list adpll_21/pDetLeft]]
resize_pblock [get_pblocks pblock_pDetLeft_3] -add {SLICE_X68Y63:SLICE_X71Y68}
create_pblock pblock_pDetAbove_2
add_cells_to_pblock [get_pblocks pblock_pDetAbove_2] [get_cells -quiet [list adpll_11/pDetAbove]]
resize_pblock [get_pblocks pblock_pDetAbove_2] -add {SLICE_X72Y100:SLICE_X77Y103}
create_pblock pblock_pDetAbove_3
add_cells_to_pblock [get_pblocks pblock_pDetAbove_3] [get_cells -quiet [list adpll_12/pDetAbove]]
resize_pblock [get_pblocks pblock_pDetAbove_3] -add {SLICE_X82Y100:SLICE_X87Y103}