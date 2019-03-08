create_pblock pblock_testRing
add_cells_to_pblock [get_pblocks pblock_testRing] [get_cells -quiet [list adpll_11/testRing]]
resize_pblock [get_pblocks pblock_testRing] -add {SLICE_X12Y189:SLICE_X19Y198}



create_pblock pblock_pDetLeft
add_cells_to_pblock [get_pblocks pblock_pDetLeft] [get_cells -quiet [list adpll_11/pDetLeft]]
resize_pblock [get_pblocks pblock_pDetLeft] -add {SLICE_X8Y175:SLICE_X11Y186}

create_pblock pblock_pDetAbove
add_cells_to_pblock [get_pblocks pblock_pDetAbove] [get_cells -quiet [list adpll_11/pDetAbove]]
resize_pblock [get_pblocks pblock_pDetAbove] -add {SLICE_X8Y187:SLICE_X11Y198}

create_pblock pblock_errorCombiner
add_cells_to_pblock [get_pblocks pblock_errorCombiner] [get_cells -quiet [list adpll_11/errorCombiner]]
resize_pblock [get_pblocks pblock_errorCombiner] -add {SLICE_X12Y175:SLICE_X19Y181}

create_pblock pblock_div8
add_cells_to_pblock [get_pblocks pblock_div8] [get_cells -quiet [list adpll_11/div8]]
resize_pblock [get_pblocks pblock_div8] -add {SLICE_X12Y187:SLICE_X15Y188}



create_pblock pblock_testRing_1
resize_pblock [get_pblocks pblock_testRing_1] -add {SLICE_X26Y189:SLICE_X33Y198}

create_pblock pblock_div8_1
resize_pblock [get_pblocks pblock_div8_1] -add {SLICE_X28Y187:SLICE_X31Y188}

create_pblock pblock_loopFilter_1
resize_pblock [get_pblocks pblock_loopFilter_1] -add {SLICE_X26Y182:SLICE_X33Y186}

create_pblock pblock_pDetAbove_1
resize_pblock [get_pblocks pblock_pDetAbove_1] -add {SLICE_X22Y190:SLICE_X25Y198}

create_pblock pblock_errorCombiner_1
resize_pblock [get_pblocks pblock_errorCombiner_1] -add {SLICE_X26Y175:SLICE_X33Y181}

create_pblock pblock_pDetLeft_1
resize_pblock [get_pblocks pblock_pDetLeft_1] -add {SLICE_X22Y178:SLICE_X25Y186}

create_pblock pblock_testRing_2
resize_pblock [get_pblocks pblock_testRing_2] -add {SLICE_X12Y164:SLICE_X19Y173}
create_pblock pblock_pDetAbove_2
resize_pblock [get_pblocks pblock_pDetAbove_2] -add {SLICE_X8Y165:SLICE_X11Y173}
create_pblock pblock_div8_2
resize_pblock [get_pblocks pblock_div8_2] -add {SLICE_X12Y162:SLICE_X15Y163}
create_pblock pblock_errorCombiner_2
resize_pblock [get_pblocks pblock_errorCombiner_2] -add {SLICE_X12Y150:SLICE_X19Y156}
create_pblock pblock_loopFilter_2
resize_pblock [get_pblocks pblock_loopFilter_2] -add {SLICE_X12Y157:SLICE_X19Y161}
create_pblock pblock_pDetLeft_2
resize_pblock [get_pblocks pblock_pDetLeft_2] -add {SLICE_X8Y153:SLICE_X11Y161}

create_pblock pblock_testRing_3
resize_pblock [get_pblocks pblock_testRing_3] -add {SLICE_X26Y164:SLICE_X33Y173}
create_pblock pblock_div8_3
resize_pblock [get_pblocks pblock_div8_3] -add {SLICE_X26Y162:SLICE_X29Y163}
create_pblock pblock_loopFilter_3
resize_pblock [get_pblocks pblock_loopFilter_3] -add {SLICE_X26Y157:SLICE_X33Y161}
create_pblock pblock_errorCombiner_3
resize_pblock [get_pblocks pblock_errorCombiner_3] -add {SLICE_X26Y150:SLICE_X33Y156}
create_pblock pblock_pDetLeft_3
resize_pblock [get_pblocks pblock_pDetLeft_3] -add {SLICE_X22Y153:SLICE_X25Y161}
create_pblock pblock_pDetAbove_3
resize_pblock [get_pblocks pblock_pDetAbove_3] -add {SLICE_X22Y165:SLICE_X25Y173}






create_pblock pblock_div8Early
add_cells_to_pblock [get_pblocks pblock_div8Early] [get_cells -quiet [list adpll_11/div8Early]]
resize_pblock [get_pblocks pblock_div8Early] -add {SLICE_X16Y187:SLICE_X19Y189}


create_pblock pblock_loopFilter
add_cells_to_pblock [get_pblocks pblock_loopFilter] [get_cells -quiet [list adpll_11/loopFilter]]
resize_pblock [get_pblocks pblock_loopFilter] -add {SLICE_X12Y182:SLICE_X19Y186}


