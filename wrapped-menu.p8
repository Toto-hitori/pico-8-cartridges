pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
function _init()
	slide = 0
	max_slides = 2
	timer = 0
	next_slide = false
	anim ={
		timer1 = 0,
		spr1 = 0,
		timer2 = 0,
		spr2 = 0
	}
	txt = {
		timer = 0,
		clr = 1,
		show = false,
		delay = 999
	}
	shutdown = {
		timer = 0,
		transition = false
	}
	blues = {12,13,1,0}
	init_transition()
	init_slide_0()
	
end

function _update()
	if btn(❎) and time() - timer > 0.5 then
		next_slide = true
	end
	if slide == 0 then
		update_slide_0()
	elseif slide == 1 then
		update_slide_1()
	elseif slide == 2 then
		update_slide_2()
	end
	if(transition.active) then
		upd_transition()
	end
	if(slide > max_slides) then
		slide = max_slides
	end
	update_txt()
end 

function _draw()
	cls()
	if slide == 0 then
		draw_slide_0()
	elseif slide == 1 then
		draw_slide_1()
	elseif slide == 2 then
		draw_slide_2()
	end
	if(transition.active)then
		draw_transition()
	end
	draw_progress_bar()
	//print(shutdown.timer,0,0,0)
end
-->8
function go_next_slide()
		next_slide = false
		slide += 1
		timer = time()
		init_transition()
		reset_anim()
		txt.timer = time()
end
-->8
function init_slide_0()
		num_pos = { x = 42,y = 48, col = 4}
		flap_timer = 0
		flap = { 
			spr1 = 0,
		 	spr2 = 8,
			timer = 0
		}
		palt(0,false)
		palt(13,true)
		pal(0,3)
end
function init_slide_1()
		num_pos = { x = 42,y = 48, col = 4 }
		flap_timer = 0
		flap = { 
			spr1 = 0,
		 	spr2 = 8,
			timer = 0
		}
		palt(0,false)
		palt(13,true)
		pal(0,3)
end
function init_slide_2()
		knight = {
			spr1 = 42,
			x = 40,
			y = 40		
		}
		pal()
		palt(0,false)
		palt(13,true)
		wig_dx = 0
		txt.delay = 2
end
function init_transition()
	rec = {
			x = 128,
			y = 0,
			w = 256,
			h = 16,
			col = 0
		}
	card = {
		max_w = 68,
		max_h = 68,
		max_dy = -28,
		dx = 0,
		dy = 0,
		w = 0,
		h = 0
	}
	transition = {
		active = false,
		ended = false
	}
end
function reset_anim()
	anim.timer1 = time()
	anim.spr1 = 0
	anim.timer2 = time()
	anim.spr2 = 0
end
function lerp(a,b,t)
	local result=a+t*(b-a)
	return result
end
-->8
function update_slide_0()
	upd_text_move()
	if(next_slide) then
		go_next_slide()
		init_slide_1()
	end
end
function update_slide_1()
	if(next_slide) then
		transition.active = true
		next_slide = false
		rec.col = 12
	end
	upd_text_move()
	if transition.ended then
		init_slide_2()
		go_next_slide()
	end
end

function update_slide_2()
	if(next_slide) then
		transition.started = true
		next_slide = false
		rec.col = 4
	end
	num_pos.y = lerp(num_pos.y,40,0.08)
	
	if time() - anim.timer1 > 0.4 then
		anim.timer1 = time()
		if anim.spr1 == 0 then
			anim.spr1 = 1
			wig_dx = 3
		else
			anim.spr1 = 0
			wig_dx = 0
		end	
	end
	if(txt.show) then 
		txt.clr = lerp(txt.clr,4,0.1)
	end
	upd_card()
end
function update_txt()
	if(time() - txt.timer > txt.delay)then
		txt.show = true
	end
end
function upd_transition()
	rec.x = lerp(rec.x,-128,0.08)
	if(rec.x <-127 and not shutdown.transition) then
		shutdown.timer = time()
		shutdown.transition = true
	end
	if shutdown.transition then
		shutdown_transition()
	end
end
function shutdown_transition()
	if time() - shutdown.timer > 0.2 then
		transition.ended = true
		shutdown_transition = false
	end
end
function upd_text_move()
	num_pos.y = lerp(num_pos.y,38,0.08)
	tmpcol = lerp(num_pos.col,0,0.1)
	pal(ceil(num_pos.col),flr(tmpcol)-1,1)
	num_pos.col = tmpcol
end

function upd_card()
	card.w = lerp(card.w,card.max_w,0.14)
	card.h = lerp(card.h,card.max_h,0.14)
	if(card.max_w -card.w < 0.5) then
		card.dy = lerp(card.dy,card.max_dy,0.14)
	end
end
-->8
function draw_slide_0()
	rectfill(0,0,128,128,11)
	draw_bands(80,0)
	draw_bands(40,111)
	draw_bands(110,84,-1)
	draw_bands(-2,-4,1)
	//numbers
	spr(2,num_pos.x,num_pos.y,2,3)//20
	spr(4,num_pos.x+14,num_pos.y,2,3)//0
	spr(2+4,num_pos.x+4*7,num_pos.y,2,3)//x
	spr(2+4,num_pos.x+6*7,num_pos.y,2,3)//x
	//wrapped
	spr(8,num_pos.x-16,num_pos.y+21,4,2)//wra
	spr(12,num_pos.x+16,num_pos.y+21,3,3)//pp
	spr(15,num_pos.x+40,num_pos.y+21,2,2)//e
	spr(12,num_pos.x+48,num_pos.y+17,1.4,3,true,true)//d
	print("amigue invisible edition",19,num_pos.y+48,0)
end
function draw_slide_1()
	rectfill(0,0,128,128,9)
	draw_bands(110,84,-1)
	draw_bands(-2,-4,1)
	//wrapped
	print("hola! bienvenide a tu" ,22,num_pos.y+13,3)
	print("amigue invisible wrapped 202x!",6,num_pos.y + 25,3)
end
function draw_slide_2()
	rectfill(0,0,128,128,12)
	draw_bands(80,0)
	draw_bands(110,84,-1)
	draw_bands(-2,-4,1)
	//wrapped
	draw_card(9)
	local x = (128-card.w)/2 + card.dx
	local y = (128-card.h)/2 + card.dy +14
	local scale = (card.w/card.max_w)
	sspr(80+8*anim.spr1,16,8,16,x+10,y+10,card.w/3,card.h/1.5)//knight
	sspr(72,16,8,8,x+12,y+6+wig_dx,card.w/3.3,card.h/3)//wig
	sspr(64,16,8,16,x+50*scale,y+30*scale,card.w/6,card.h/3)//knight
	if(txt.show) then 
		print(" veo que te gusta",29,num_pos.y+48,blues[ceil(txt.clr)])
		print(" hollow knight...",30,num_pos.y+58,blues[ceil(txt.clr)])
		print("2023 was a   year  ",30,num_pos.y+68,blues[ceil(txt.clr)])
		spr(57,72,num_pos.y+66) // clown emoji
	end
end
function draw_transition()
	for i =0,9 do
		rectfill(16*i+rec.x,16*i+rec.y,rec.x+rec.w,rec.y+rec.h,rec.col)
	end
end

function draw_bands(pos,yoffset,pallete)
	yoffset = yoffset or 0
	pallete = pallete or 0
	if(time()-flap.timer > 0.5) then
		local temp = flap.spr1
		flap.spr1 = flap.spr2
		flap.spr2 = temp
		flap.timer = time()
	end
	for c=1,3,2 do
		sspr(flap.spr1,16+pallete*8,8,8,pos+12-c*6,c*16-20+yoffset,16,16,false,false)
	   end
	for c=0,3,2 do
		sspr(flap.spr2,16+pallete*8,8,8,pos+12-c*6,c*16-20+yoffset,16,16,false,false)
	   end
   end

function draw_card(co)
	local x = (128-card.w)/2 + card.dx
	local y = (128-card.h)/2 + card.dy +10
	rectfill(x,y,x+card.w,y+card.w,co)
end

function draw_progress_bar()
	for i = 0,max_slides+1 do
		local size = 128/(max_slides+1) - 5
		local clr = 7
		if(i == slide) then 
			clr = 0
		end
		rectfill( 5*(i+1) +size*i,3,5*i +size*i+size,5,clr)
	end
end
__gfx__
00000000bbbbbbbbdddddddddddddddddddddddddddddddddddddddddddddddd000ddd0000ddd000dddddddddddddddddddddddddddddddddddddddddddddddd
00000000bbbbbbbbdddddddddddddddddddddddddddddddddddddddddddddddd000ddd0000ddd000dddddddddddddddddddddddddddddddddddddddddddddddd
00700700bbbbbbbbdddddddddddddddddddddddddddddddddddddddddddddddd000ddd0000ddd000dddddddddddddddddddddddddddddddddddddddddddddddd
00077000bbbbbbbbdddddddddddddddddddddddddddddddddddddddddddddddd000ddd0000ddd000dddddddddddddddd000dddddddd000dddddddddddddddddd
00077000bbbbbbbbddddd0000000ddddddddd000000dddddd0000dddddd0000d000ddd0000ddd000000dd000d000000d000d00000dd000d000000dddd000000d
00700700bbbbbbbbddd0000000000ddddddd00000000ddddd0000dddddd0000d0000d000000d0000000d0000000000000000000000d00000000000dd00000000
00000000bbbbbbbbdd000000000000ddddd0000000000dddd00000dddd00000d0000d000000d000000000000000000000000000000d00000000000d000000000
00000000bbbbbbbbdd000000000000dddd000000000000ddd00000dddd00000dd000d000000d000d00000000d00dd0000000ddd00000000dddd00000000dd000
dddee88cddde88ccd00000000000000ddd000000000000ddd00000dddd00000dd00000000000000d00000ddddddddd00000ddddd000000dddddd000000dddd00
dddee88cdeee88ccd00000ddd000000dd00000dddd00000dd000000dd000000dd000000dd000000d0000ddddddd00000000ddddd000000dddddd000000000000
ddeee88cdee888ccd0000ddddd00000dd0000dddddd0000ddd000000000000dddd00000dd00000dd000dddddd0000000000ddddd000000dddddd00000000000d
ddee888cee888ccdd0000ddddd00000dd0000dddddd0000dddd0000000000ddddd00000dd00000dd000ddddd000000000000dddd0000000ddddd0000000000dd
dee888ccee88cccdd0000ddddd00000dd0000dddddd0000ddddd00000000dddddd00000dd00000dd000ddddd000ddd0000000dd000000000ddd0000000dddddd
ee888ccce888ccddddddddddd000000dd0000dddddd0000ddddd00000000ddddddd000dddd000ddd000ddddd000dd0000000000000d00000000000d0000dd000
e888cccde88cccddddddddd0000000ddd0000dddddd0000ddddd00000000ddddddd000dddd000ddd000ddddd00000000000000000dd0000000000dd000000000
e88cccddee8cccdddddddd0000000dddd0000dddddd0000dddd0000000000dddddd000dddd000ddd000dddddd0000d00000d0000ddd000d00000dddd0000000d
ddd8899addd899aaddddd0000000ddddd0000dddddd0000ddd000000000000dddd6dd6ddd8eeabcddd7dd7dddddddddd000dddddddd000dddddddddddddddddd
ddd8899ad88899aadddd0000000dddddd0000dddddd0000ddd000000000000ddd67dd67d88eaabc2d67dd77dddd7d6dd000dddddddd000dddddddddddddddddd
dd88899ad88999aaddd0000000ddddddd00000dddd00000dd000000dd000000dd67dd67d8eeabbc2d6dddd7ddd67d77d000dddddddd000dddddddddddddddddd
dd88999a88999aaddd0000000ddddddddd00000dd00000ddd00000dddd00000dd677d67d8eeabcc2d677777dd66ddd7d000dddddddd000dddddddddddddddddd
d88999aa8899aaadd00000000000000ddd000000000000ddd00000dddd00000dd677777d88eabc22d600770dd677777d000dddddddd000dddddddddddddddddd
88999aaa8999aaddd00000000000000dddd0000000000dddd00000dddd00000dd677777dddddddddd600770dd600770d000dddddddd000dddddddddddddddddd
8999aaad899aaaddd00000000000000ddddd00000000ddddd0000dddddd0000dd600700dddddddddd6cc77cdd600770ddddddddddddddddddddddddddddddddd
899aaadd889aaaddd00000000000000dddddd000000dddddd0000dddddd0000dd600700ddddd8ddddd5c15ddd6cc77cddddddddddddddddddddddddddddddddd
ddd77aacddd7aaccdddddddddddddddddddddddddddddddddddddddddddddddddd67777d88777788d151515dddc151cddddddddddddddddddddddddddddddddd
ddd77aacd777aaccdddddddddddddddddddddddddddddddddddddddddddddddddd26772d8777777815100515d155551ddddddddddddddddddddddddddddddddd
dd777aacd77aaaccddddddddddddddddddddddddddddddddddddddddddddddddd882228d771771771510055115100551dddddddddddddddddddddddddddddddd
dd77aaac77aaaccddddddddddddddddddddddddddddddddddddddddddddddddd88288888ee7887ee5100015515100155dddddddddddddddddddddddddddddddd
d77aaacc77aacccddddddddddddddddddddddddddddddddddddddddddddddddd25588882ee7887ee5100501551100515dddddddddddddddddddddddddddddddd
77aaaccc7aaaccdddddddddddddddddddddddddddddddddddddddddddddddddd2552222277222277d10dd0d1115d0051dddddddddddddddddddddddddddddddd
7aaacccd7aacccdddddddddddddddddddddddddddddddddddddddddddddddddd5500d00dd772277ddddddddddddddddddddddddddddddddddddddddddddddddd
7aacccdd77acccdddddddddddddddddddddddddddddddddddddddddddddddddd5dd0d0dddd7777dddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
__map__
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
