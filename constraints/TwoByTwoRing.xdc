create_pblock pblock_testRing
add_cells_to_pblock [get_pblocks pblock_testRing] [get_cells -quiet [list adpll_11/testRing]]
resize_pblock [get_pblocks pblock_testRing] -add {SLICE_X0Y189:SLICE_X7Y199}



create_pblock pblock_pDetLeft
add_cells_to_pblock [get_pblocks pblock_pDetLeft] [get_cells -quiet [list adpll_11/pDetLeft]]
resize_pblock [get_pblocks pblock_pDetLeft] -add {SLICE_X0Y173:SLICE_X7Y175}

create_pblock pblock_pDetAbove
add_cells_to_pblock [get_pblocks pblock_pDetAbove] [get_cells -quiet [list adpll_11/pDetAbove]]
resize_pblock [get_pblocks pblock_pDetAbove] -add {SLICE_X8Y194:SLICE_X11Y199}

create_pblock pblock_errorCombiner
add_cells_to_pblock [get_pblocks pblock_errorCombiner] [get_cells -quiet [list adpll_11/errorCombiner]]
resize_pblock [get_pblocks pblock_errorCombiner] -add {SLICE_X0Y176:SLICE_X7Y181}

create_pblock pblock_div8
add_cells_to_pblock [get_pblocks pblock_div8] [get_cells -quiet [list adpll_11/div8]]
resize_pblock [get_pblocks pblock_div8] -add {SLICE_X0Y187:SLICE_X3Y188}

create_pblock pblock_loopFilter
add_cells_to_pblock [get_pblocks pblock_loopFilter] [get_cells -quiet [list adpll_11/loopFilter]]
resize_pblock [get_pblocks pblock_loopFilter] -add {SLICE_X0Y182:SLICE_X7Y186}


create_pblock pblock_testRing_1
add_cells_to_pblock [get_pblocks pblock_testRing_1] [get_cells -quiet [list adpll_12/testRing]]
resize_pblock [get_pblocks pblock_testRing_1] -add {SLICE_X12Y189:SLICE_X19Y199}

create_pblock pblock_div8_1
add_cells_to_pblock [get_pblocks pblock_div8_1] [get_cells -quiet [list adpll_12/div8]]
resize_pblock [get_pblocks pblock_div8_1] -add {SLICE_X12Y187:SLICE_X15Y188}

create_pblock pblock_loopFilter_1
add_cells_to_pblock [get_pblocks pblock_loopFilter_1] [get_cells -quiet [list adpll_12/loopFilter]]
resize_pblock [get_pblocks pblock_loopFilter_1] -add {SLICE_X12Y182:SLICE_X19Y186}

create_pblock pblock_pDetAbove_1
add_cells_to_pblock [get_pblocks pblock_pDetAbove_1] [get_cells -quiet [list adpll_12/pDetAbove]]
resize_pblock [get_pblocks pblock_pDetAbove_1] -add {SLICE_X20Y194:SLICE_X23Y199}

create_pblock pblock_errorCombiner_1
add_cells_to_pblock [get_pblocks pblock_errorCombiner_1] [get_cells -quiet [list adpll_12/errorCombiner]]
resize_pblock [get_pblocks pblock_errorCombiner_1] -add {SLICE_X12Y176:SLICE_X19Y181}

create_pblock pblock_pDetLeft_1
add_cells_to_pblock [get_pblocks pblock_pDetLeft_1] [get_cells -quiet [list adpll_12/pDetLeft]]
resize_pblock [get_pblocks pblock_pDetLeft_1] -add {SLICE_X8Y182:SLICE_X11Y187}

create_pblock pblock_testRing_2
add_cells_to_pblock [get_pblocks pblock_testRing_2] [get_cells -quiet [list adpll_21/testRing]]
resize_pblock [get_pblocks pblock_testRing_2] -add {SLICE_X0Y162:SLICE_X7Y172}
create_pblock pblock_pDetAbove_2
add_cells_to_pblock [get_pblocks pblock_pDetAbove_2] [get_cells -quiet [list adpll_21/pDetAbove]]
resize_pblock [get_pblocks pblock_pDetAbove_2] -add {SLICE_X8Y167:SLICE_X11Y172}
create_pblock pblock_div8_2
add_cells_to_pblock [get_pblocks pblock_div8_2] [get_cells -quiet [list adpll_21/div8]]
resize_pblock [get_pblocks pblock_div8_2] -add {SLICE_X0Y160:SLICE_X3Y161}
create_pblock pblock_errorCombiner_2
add_cells_to_pblock [get_pblocks pblock_errorCombiner_2] [get_cells -quiet [list adpll_21/errorCombiner]]
resize_pblock [get_pblocks pblock_errorCombiner_2] -add {SLICE_X0Y149:SLICE_X7Y154}
create_pblock pblock_loopFilter_2
add_cells_to_pblock [get_pblocks pblock_loopFilter_2] [get_cells -quiet [list adpll_21/loopFilter]]
resize_pblock [get_pblocks pblock_loopFilter_2] -add {SLICE_X0Y155:SLICE_X7Y159}
create_pblock pblock_pDetLeft_2
add_cells_to_pblock [get_pblocks pblock_pDetLeft_2] [get_cells -quiet [list adpll_21/pDetLeft]]
resize_pblock [get_pblocks pblock_pDetLeft_2] -add {SLICE_X0Y146:SLICE_X7Y148}

create_pblock pblock_testRing_3
add_cells_to_pblock [get_pblocks pblock_testRing_3] [get_cells -quiet [list adpll_22/testRing]]
resize_pblock [get_pblocks pblock_testRing_3] -add {SLICE_X12Y162:SLICE_X19Y172}
create_pblock pblock_div8_3
add_cells_to_pblock [get_pblocks pblock_div8_3] [get_cells -quiet [list adpll_22/div8]]
resize_pblock [get_pblocks pblock_div8_3] -add {SLICE_X12Y160:SLICE_X15Y161}
create_pblock pblock_loopFilter_3
add_cells_to_pblock [get_pblocks pblock_loopFilter_3] [get_cells -quiet [list adpll_22/loopFilter]]
resize_pblock [get_pblocks pblock_loopFilter_3] -add {SLICE_X12Y155:SLICE_X19Y159}
create_pblock pblock_errorCombiner_3
add_cells_to_pblock [get_pblocks pblock_errorCombiner_3] [get_cells -quiet [list adpll_22/errorCombiner]]
resize_pblock [get_pblocks pblock_errorCombiner_3] -add {SLICE_X12Y149:SLICE_X19Y154}
create_pblock pblock_pDetLeft_3
add_cells_to_pblock [get_pblocks pblock_pDetLeft_3] [get_cells -quiet [list adpll_22/pDetLeft]]
resize_pblock [get_pblocks pblock_pDetLeft_3] -add {SLICE_X8Y155:SLICE_X11Y160}
create_pblock pblock_pDetAbove_3
add_cells_to_pblock [get_pblocks pblock_pDetAbove_3] [get_cells -quiet [list adpll_22/pDetAbove]]
resize_pblock [get_pblocks pblock_pDetAbove_3] -add {SLICE_X20Y167:SLICE_X23Y172}




