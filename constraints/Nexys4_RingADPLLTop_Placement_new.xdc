create_pblock pblock_testRing
add_cells_to_pblock [get_pblocks pblock_testRing] [get_cells -quiet [list adpll/testRing]]
resize_pblock [get_pblocks pblock_testRing] -add {SLICE_X0Y190:SLICE_X7Y199}
create_pblock pblock_testPDet
add_cells_to_pblock [get_pblocks pblock_testPDet] [get_cells -quiet [list adpll/testPDet]]
resize_pblock [get_pblocks pblock_testPDet] -add {SLICE_X0Y186:SLICE_X7Y188}
create_pblock pblock_div8
resize_pblock [get_pblocks pblock_div8] -add {SLICE_X0Y189:SLICE_X7Y189}
create_pblock pblock_loopFilter
resize_pblock [get_pblocks pblock_loopFilter] -add {SLICE_X0Y182:SLICE_X7Y185}

#create_pblock pblock_testRing
#add_cells_to_pblock [get_pblocks pblock_testRing] [get_cells -quiet [list testRing]]
#resize_pblock [get_pblocks pblock_testRing] -add {SLICE_X0Y194:SLICE_X7Y199}
#create_pblock pblock_testPDet
#add_cells_to_pblock [get_pblocks pblock_testPDet] [get_cells -quiet [list testPDet]]
#resize_pblock [get_pblocks pblock_testPDet] -add {SLICE_X0Y190:SLICE_X7Y192}
#create_pblock pblock_div8
#add_cells_to_pblock [get_pblocks pblock_div8] [get_cells -quiet [list div8]]
#resize_pblock [get_pblocks pblock_div8] -add {SLICE_X0Y193:SLICE_X7Y193}
#create_pblock pblock_loopFilter
#add_cells_to_pblock [get_pblocks pblock_loopFilter] [get_cells -quiet [list loopFilter]]
#resize_pblock [get_pblocks pblock_loopFilter] -add {SLICE_X0Y186:SLICE_X7Y189}

