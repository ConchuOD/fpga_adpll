create_pblock pblock_loopFilter
add_cells_to_pblock [get_pblocks pblock_loopFilter] [get_cells -quiet [list adpll/loopFilter]]
resize_pblock [get_pblocks pblock_loopFilter] -add {SLICE_X0Y145:SLICE_X7Y150}
create_pblock pblock_testPDet
add_cells_to_pblock [get_pblocks pblock_testPDet] [get_cells -quiet [list adpll/testPDet]]
resize_pblock [get_pblocks pblock_testPDet] -add {SLICE_X0Y151:SLICE_X7Y156}
create_pblock pblock_div8
add_cells_to_pblock [get_pblocks pblock_div8] [get_cells -quiet [list adpll/div8]]
resize_pblock [get_pblocks pblock_div8] -add {SLICE_X2Y157:SLICE_X5Y158}
create_pblock pblock_testOsc
add_cells_to_pblock [get_pblocks pblock_testOsc] [get_cells -quiet [list adpll/testOsc]]
resize_pblock [get_pblocks pblock_testOsc] -add {SLICE_X0Y159:SLICE_X7Y164}