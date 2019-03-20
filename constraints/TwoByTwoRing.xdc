# ADPLL 11
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
resize_pblock [get_pblocks pblock_errorCombiner] -add {SLICE_X12Y175:SLICE_X21Y180}

create_pblock pblock_div8
resize_pblock [get_pblocks pblock_div8] -add {SLICE_X12Y187:SLICE_X15Y188}

create_pblock pblock_div8Early
resize_pblock [get_pblocks pblock_div8Early] -add {SLICE_X16Y187:SLICE_X19Y188}

create_pblock pblock_loopFilter
add_cells_to_pblock [get_pblocks pblock_loopFilter] [get_cells -quiet [list adpll_11/loopFilter]]
resize_pblock [get_pblocks pblock_loopFilter] -add {SLICE_X12Y181:SLICE_X21Y186}


# ADPLL 12
create_pblock pblock_testRing_1
add_cells_to_pblock [get_pblocks pblock_testRing_1] [get_cells -quiet [list adpll_12/testRing]]
resize_pblock [get_pblocks pblock_testRing_1] -add {SLICE_X26Y189:SLICE_X33Y198}

create_pblock pblock_div8_1
resize_pblock [get_pblocks pblock_div8_1] -add {SLICE_X26Y187:SLICE_X29Y188}

create_pblock pblock_loopFilter_1
add_cells_to_pblock [get_pblocks pblock_loopFilter_1] [get_cells -quiet [list adpll_12/loopFilter]]
resize_pblock [get_pblocks pblock_loopFilter_1] -add {SLICE_X26Y181:SLICE_X35Y186}

create_pblock pblock_pDetAbove_1
add_cells_to_pblock [get_pblocks pblock_pDetAbove_1] [get_cells -quiet [list adpll_12/pDetAbove]]
resize_pblock [get_pblocks pblock_pDetAbove_1] -add {SLICE_X22Y187:SLICE_X25Y198}

create_pblock pblock_errorCombiner_1
add_cells_to_pblock [get_pblocks pblock_errorCombiner_1] [get_cells -quiet [list adpll_12/errorCombiner]]
resize_pblock [get_pblocks pblock_errorCombiner_1] -add {SLICE_X26Y175:SLICE_X35Y180}

create_pblock pblock_pDetLeft_1
add_cells_to_pblock [get_pblocks pblock_pDetLeft_1] [get_cells -quiet [list adpll_12/pDetLeft]]
resize_pblock [get_pblocks pblock_pDetLeft_1] -add {SLICE_X22Y175:SLICE_X25Y186}


# ADPLL 21
create_pblock pblock_testRing_2
add_cells_to_pblock [get_pblocks pblock_testRing_2] [get_cells -quiet [list adpll_21/testRing]]
resize_pblock [get_pblocks pblock_testRing_2] -add {SLICE_X12Y164:SLICE_X19Y173}

create_pblock pblock_pDetAbove_2
add_cells_to_pblock [get_pblocks pblock_pDetAbove_2] [get_cells -quiet [list adpll_21/pDetAbove]]
resize_pblock [get_pblocks pblock_pDetAbove_2] -add {SLICE_X8Y162:SLICE_X11Y173}

create_pblock pblock_div8_2
resize_pblock [get_pblocks pblock_div8_2] -add {SLICE_X12Y162:SLICE_X15Y163}

create_pblock pblock_errorCombiner_2
add_cells_to_pblock [get_pblocks pblock_errorCombiner_2] [get_cells -quiet [list adpll_21/errorCombiner]]
resize_pblock [get_pblocks pblock_errorCombiner_2] -add {SLICE_X12Y150:SLICE_X21Y155}

create_pblock pblock_loopFilter_2
add_cells_to_pblock [get_pblocks pblock_loopFilter_2] [get_cells -quiet [list adpll_21/loopFilter]]
resize_pblock [get_pblocks pblock_loopFilter_2] -add {SLICE_X12Y156:SLICE_X21Y161}

create_pblock pblock_pDetLeft_2
add_cells_to_pblock [get_pblocks pblock_pDetLeft_2] [get_cells -quiet [list adpll_21/pDetLeft]]
resize_pblock [get_pblocks pblock_pDetLeft_2] -add {SLICE_X8Y150:SLICE_X11Y161}


# ADPLL 22
create_pblock pblock_testRing_3
add_cells_to_pblock [get_pblocks pblock_testRing_3] [get_cells -quiet [list adpll_22/testRing]]
resize_pblock [get_pblocks pblock_testRing_3] -add {SLICE_X26Y164:SLICE_X33Y173}

create_pblock pblock_div8_3
resize_pblock [get_pblocks pblock_div8_3] -add {SLICE_X26Y162:SLICE_X29Y163}

create_pblock pblock_loopFilter_3
add_cells_to_pblock [get_pblocks pblock_loopFilter_3] [get_cells -quiet [list adpll_22/loopFilter]]
resize_pblock [get_pblocks pblock_loopFilter_3] -add {SLICE_X26Y156:SLICE_X35Y161}

create_pblock pblock_errorCombiner_3
add_cells_to_pblock [get_pblocks pblock_errorCombiner_3] [get_cells -quiet [list adpll_22/errorCombiner]]
resize_pblock [get_pblocks pblock_errorCombiner_3] -add {SLICE_X26Y150:SLICE_X35Y155}

create_pblock pblock_pDetLeft_3
add_cells_to_pblock [get_pblocks pblock_pDetLeft_3] [get_cells -quiet [list adpll_22/pDetLeft]]
resize_pblock [get_pblocks pblock_pDetLeft_3] -add {SLICE_X22Y150:SLICE_X25Y161}

create_pblock pblock_pDetAbove_3
add_cells_to_pblock [get_pblocks pblock_pDetAbove_3] [get_cells -quiet [list adpll_22/pDetAbove]]
resize_pblock [get_pblocks pblock_pDetAbove_3] -add {SLICE_X22Y162:SLICE_X25Y173}


# ADPLL 31
create_pblock pblock_testRing_4
add_cells_to_pblock [get_pblocks pblock_testRing_4] [get_cells -quiet [list adpll_31/testRing]]
resize_pblock [get_pblocks pblock_testRing_4] -add {SLICE_X32Y137:SLICE_X39Y146}

create_pblock pblock_pDetLeft_4
add_cells_to_pblock [get_pblocks pblock_pDetLeft_4] [get_cells -quiet [list adpll_31/pDetLeft]]
resize_pblock [get_pblocks pblock_pDetLeft_4] -add {SLICE_X28Y123:SLICE_X31Y134}

create_pblock pblock_pDetAbove_4
add_cells_to_pblock [get_pblocks pblock_pDetAbove_4] [get_cells -quiet [list adpll_31/pDetAbove]]
resize_pblock [get_pblocks pblock_pDetAbove_4] -add {SLICE_X28Y135:SLICE_X31Y146}

create_pblock pblock_loopFilter_4
add_cells_to_pblock [get_pblocks pblock_loopFilter_4] [get_cells -quiet [list adpll_31/loopFilter]]
resize_pblock [get_pblocks pblock_loopFilter_4] -add {SLICE_X32Y129:SLICE_X41Y134}

create_pblock pblock_errorCombiner_4
add_cells_to_pblock [get_pblocks pblock_errorCombiner_4] [get_cells -quiet [list adpll_31/errorCombiner]]
resize_pblock [get_pblocks pblock_errorCombiner_4] -add {SLICE_X32Y123:SLICE_X41Y128}


# ADPLL 32
create_pblock pblock_testRing_5
add_cells_to_pblock [get_pblocks pblock_testRing_5] [get_cells -quiet [list adpll_32/testRing]]
resize_pblock [get_pblocks pblock_testRing_5] -add {SLICE_X46Y137:SLICE_X53Y146}

create_pblock pblock_pDetLeft_5
add_cells_to_pblock [get_pblocks pblock_pDetLeft_5] [get_cells -quiet [list adpll_32/pDetLeft]]
resize_pblock [get_pblocks pblock_pDetLeft_5] -add {SLICE_X42Y123:SLICE_X45Y134}

create_pblock pblock_pDetAbove_5
add_cells_to_pblock [get_pblocks pblock_pDetAbove_5] [get_cells -quiet [list adpll_32/pDetAbove]]
resize_pblock [get_pblocks pblock_pDetAbove_5] -add {SLICE_X42Y135:SLICE_X45Y146}

create_pblock pblock_loopFilter_5
add_cells_to_pblock [get_pblocks pblock_loopFilter_5] [get_cells -quiet [list adpll_32/loopFilter]]
resize_pblock [get_pblocks pblock_loopFilter_5] -add {SLICE_X46Y129:SLICE_X55Y134}

create_pblock pblock_errorCombiner_5
add_cells_to_pblock [get_pblocks pblock_errorCombiner_5] [get_cells -quiet [list adpll_32/errorCombiner]]
resize_pblock [get_pblocks pblock_errorCombiner_5] -add {SLICE_X46Y123:SLICE_X55Y128}






