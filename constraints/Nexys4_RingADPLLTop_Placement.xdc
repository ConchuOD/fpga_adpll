create_pblock pblock_testRing
add_cells_to_pblock [get_pblocks pblock_testRing] [get_cells -quiet [list adpll/testRing]]
resize_pblock [get_pblocks pblock_testRing] -add {SLICE_X12Y189:SLICE_X21Y198}
create_pblock pblock_div8
add_cells_to_pblock [get_pblocks pblock_div8] [get_cells -quiet [list adpll/div8]]
resize_pblock [get_pblocks pblock_div8] -add {SLICE_X14Y187:SLICE_X19Y188}
create_pblock pblock_testPDet
add_cells_to_pblock [get_pblocks pblock_testPDet] [get_cells -quiet [list adpll/testPDet]]
resize_pblock [get_pblocks pblock_testPDet] -add {SLICE_X12Y183:SLICE_X21Y186}
create_pblock pblock_loopFilter
add_cells_to_pblock [get_pblocks pblock_loopFilter] [get_cells -quiet [list adpll/loopFilter]]
resize_pblock [get_pblocks pblock_loopFilter] -add {SLICE_X12Y175:SLICE_X21Y182}
create_pblock pblock_referenceOsc
add_cells_to_pblock [get_pblocks pblock_referenceOsc] [get_cells -quiet [list referenceOsc]]
resize_pblock [get_pblocks pblock_referenceOsc] -add {SLICE_X24Y175:SLICE_X29Y198}