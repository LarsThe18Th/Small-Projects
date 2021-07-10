; Megareport DOS v0.1
;

	output megarep.com

	defpage 0,100h
	page 0
	code @ 100h





				jp begin
nametag:
				db "MegaReport1.2"
				db "DOS Loader  v0.1"
				db "(c)2017         "
				dw #614C,#7372,#5420,#6568,#3120,#5438,#2068
				db "                  "

;----------------------------------------------------------------
part1:
				in a,(#a8)
				and #fc
				out (#a8),a
part2:
				incbin megarep.bin,7,440

;----------------------------------------------------------------
			
begin:
				
				di
				ld hl,part1
				ld bc,begin-part1
				ld de,#b600-(part2-part1)
				ldir

				jp #b600-(part2-part1)


				ret

end