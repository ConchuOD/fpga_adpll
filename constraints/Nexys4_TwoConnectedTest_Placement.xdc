create_pblock pblock_adpll
add_cells_to_pblock [get_pblocks pblock_adpll] [get_cells -quiet [list adpll]]
resize_pblock [get_pblocks pblock_adpll] -add {SLICE_X0Y137:SLICE_X7Y149}
create_pblock pblock_refAdpll
add_cells_to_pblock [get_pblocks pblock_refAdpll] [get_cells -quiet [list refAdpll]]
resize_pblock [get_pblocks pblock_refAdpll] -add {SLICE_X0Y126:SLICE_X7Y135}
