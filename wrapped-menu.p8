pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
function _init()
	slide = 0
	max_slides = 7
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
	green_to_black = {3,2,1,0}
	debug = ""
	init_transition()
	init_slide_0()
	//init_slide_anime()
end

function _update()
	if btn(❎) and time() - timer > 0.5 then
		next_slide = true
	end
	if txt.show then
		upd_text_move()
	end
	update_current_slide()
	
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
	draw_current_slide()
	if(transition.active)then
		draw_transition()
	end
	draw_progress_bar()
	print(debug,68,0,12)
end
-->8
--reset
function go_next_slide()
		next_slide = false
		slide += 1
		timer = time()
		init_next_slide()
		init_transition()
		reset_anim()
		reset_text()
end
function go_prev_slide()
	next_slide = false
	slide -= 1
	timer = time()
	init_next_slide()
	init_transition()
	reset_anim()
	reset_text()
end

function reset_text()
	txt.timer = time()
	txt.show = false
	txt.clr = 0
end
function reset_anim()
	anim.timer1 = time()
	anim.spr1 = 0
	anim.timer2 = time()
	anim.spr2 = 0
end
-->8
--init
function init_next_slide()
	if(slide == 0)then
		init_slide_0()
	elseif(slide == 1)then
		init_slide_1()
	elseif slide == 2 then
		init_slide_kity()
	elseif slide == 3 then
		init_slide_hk()
	elseif slide == 4 then 
		init_slide_osu()
	elseif slide == 5 then 
		init_slide_celeste()
	elseif slide == 6 then
		init_slide_anime() 
	else
		init_slide_end()
	end
end
function init_slide_0()
		txt.show = true
		text_pos = { x = 42,y = 48,dy = 38, col = 4,colup = true}
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
		txt.delay = 1
		text_pos = { x = 42,y = 28,dy = 18, col = 4 }
		card.dy = 70
		flap_timer = 0
		flap = { 
			spr1 = 0,
		 	spr2 = 8,
			timer = 0
		}
		pal()
		palt(0,false)
		palt(13,true)
end
function init_slide_hk() 
		text_pos = { x = 42,y = 47,dy = 42, col = 4 }
		pal()
		palt(0,false)
		palt(13,true)
		wig_dx = 0
		txt.delay = 2
end
function init_slide_osu()
	text_pos = { x = 42,y = 47,dy = 42, col = 4 }
	pal()
	palt(0,false)
	palt(13,true)
	txt.delay = 2
end
function init_slide_kity()
	text_pos = { x = 42,y = 47,dy = 42, col = 4 }
	pal()
	palt(0,false)
	palt(13,true)
	txt.delay = 2
end
function init_slide_celeste()
	text_pos = { x = 42,y = 47,dy = 42, col = 4 }
	pal()
	palt(0,false)
	palt(11,true)
	txt.delay = 2
	straw = {dy = 0, max_dy = 15,up = true}
end
function init_slide_anime() 
	text_pos = { x = 42,y = 47,dy = 42, col = 4 }
	anya = {
		spr1 = 42,
		x = 40,
		y = 40		
	}
	pal()
	palt(0,true)
	txt.delay = 2
end
function init_slide_end()
	txt.delay = 0
	txt.show = true
	text_pos = { x = 42,y = 38,dy=24, col = 4 }
	flap_timer = 0
	flap = { 
		spr1 = 0,
		 spr2 = 8,
		timer = 0
	}
	sambe = {spr = 128}
	palt(0,false)
	palt(13,true)
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
function lerp(a,b,t)
	local result=a+t*(b-a)
	return result
end
-->8
--update
function update_current_slide()
	if slide == 0 then
		update_slide_0()
	elseif slide == 1 then
		update_slide_1()
	elseif slide == 2 then
		update_slide_kity()
	elseif slide == 3 then
		update_slide_hk()
	elseif slide == 4 then
		update_slide_osu()
	elseif slide == 5 then 
		update_slide_celeste()
	elseif slide == 6 then
		update_slide_anime()
	else
		update_slide_end()
	end
end
function update_slide_0()
	if(next_slide) then
		go_next_slide()
	end
end
function update_slide_1()
	if(next_slide) then
		transition.active = true
		next_slide = false
		rec.col = 11
	end
	anim_sprites(1,3)
	if transition.ended then
		go_next_slide()
	end
	upd_card()
end
function update_slide_hk()
	if(next_slide) then
		rec.col = 4
		go_next_slide()
	end
	anim_sprites(0.2)
	upd_card()
end
function update_slide_osu()
	if(next_slide) then
		rec.col = 4
		go_next_slide()
	end
	upd_card()
end
function update_slide_kity()
	if(next_slide) then
		rec.col = 4
		go_next_slide()
	end
	//anim_sprites(0.2)
	upd_card()
end
function update_slide_celeste()
	if(next_slide) then
		rec.col = 4
		go_next_slide()
	end
	anim_sprites(0.2,2,0.1,3)
	upd_card()
	if(straw.dy > straw.max_dy-straw.max_dy/3) then
		straw.up = false
	elseif(straw.dy < straw.max_dy/3)then
		straw.up = true
	end
	if(straw.up) then
		straw.dy = lerp(straw.dy,straw.max_dy,0.03)
	else
		straw.dy = lerp(straw.dy,0,0.03)
	end
end
function update_slide_anime()
	if(next_slide) then
		transition.active = true
		next_slide = false
		rec.col = 0
	end
	if transition.ended then
		go_next_slide()
	end
	anim_sprites(0.2)
	upd_card()
end
function update_slide_end()
	anim_sprites(0.2,4)
	if(next_slide) then
		rec.col = 4
		slide = -1
		go_next_slide()
	end
end
function update_txt()
	if(time() - txt.timer > txt.delay)then
		txt.show = true
	end
	if(txt.show) then 
		txt.clr = lerp(txt.clr,4,0.1)
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
function anim_sprites(tim1,--[[optional]] numa1,--[[optional]] tim2,--[[optional]]numa2)
	numa1 = numa1 or 2
	numa2 = numa1 or 2
	tim2 = tim2 or 999
	if time() - anim.timer1 > tim1 then
		anim.timer1 = time()
		if(anim.spr1 < numa1-1) then
			anim.spr1 += 1
			wig_dx = 3
		else
			anim.spr1 = 0
			wig_dx = 0
		end	
	end
	if time() - anim.timer2 > tim2 then
		anim.timer2 = time()
		if(anim.spr1 < numa2-1) then
			anim.spr2 += 1
			wig_dx = 3
		else
			anim.spr2 = 0
			wig_dx = 0
		end	
	end
end
function shutdown_transition()
	if time() - shutdown.timer > 0.2 then
		transition.ended = true
		shutdown.transition = false
	end
end
function upd_text_move()
	local text_dy = text_pos.dy
	local colup = text_pos.colup or false
	text_pos.y = lerp(text_pos.y,text_dy,0.08)
	
	tmpcol = lerp(text_pos.col,0,0.1)
	if colup == true then
		pal(ceil(text_pos.col),flr(tmpcol)-1,1)
	end
	text_pos.col = tmpcol
end

function upd_card()
	card.w = lerp(card.w,card.max_w,0.14)
	card.h = lerp(card.h,card.max_h,0.14)
	if(card.max_w -card.w < 0.5) then
		card.dy = lerp(card.dy,card.max_dy,0.14)
	end
end
-->8
--draw
function draw_current_slide()
	if slide == 0 then
		draw_slide_0()
	elseif slide == 1 then
		draw_slide_1()
	elseif slide == 2 then
		draw_slide_kity()
	elseif slide == 3 then
		draw_slide_hk()
	elseif slide == 4 then
		draw_slide_osu()
	elseif slide == 5 then 
		draw_slide_celeste()
	elseif slide == 6 then
		draw_slide_anime()
	else
		draw_slide_end()
	end
end
function draw_slide_0()
	rectfill(0,0,128,128,11)
	draw_bands(80,0)
	draw_bands(40,111)
	draw_bands(110,84,-1)
	draw_bands(-2,-4,1)
	//numbers
	spr(192,text_pos.x-16,text_pos.y-8,4,3.1)//Maus
	spr(2,text_pos.x,text_pos.y,2,3)//20
	spr(4,text_pos.x+14,text_pos.y,2,3)//0
	spr(2,text_pos.x+4*7,text_pos.y,2,3)//x
	spr(2+4,text_pos.x+6*7,text_pos.y,2,3)//x
	//wrapped
	spr(8,text_pos.x-16,text_pos.y+21,4,2)//wra
	spr(12,text_pos.x+16,text_pos.y+21,2,3)//pp
	spr(14,text_pos.x+32,text_pos.y+21,1,2)//half p
	spr(15,text_pos.x+40,text_pos.y+21,2,2)//e
	spr(12,text_pos.x+48,text_pos.y+17,1.4,3,true,true)//d
	print("amigue invisible edition",19,text_pos.y+48,0)
end
function draw_slide_1()
	rectfill(0,0,128,128,9)
	draw_bands(110,84,-1)
	draw_bands(-2,-4,1)
	local scale = (card.w/card.max_w)
	sspr(8*8,64,32,32,64-card.w/3,64-card.w/3,card.w/1.5,card.h/1.5)//osu
	if(anim.spr1 > 0) then
		sspr(12*8,80+(anim.spr1-1)*8,24,8,64-card.w/3,86-card.w/3+1,card.w/4*3/1.5,card.h/4.3/1.5)//osu
	end
	sspr(12*8,64+anim.spr1*2,8,2,72-card.w/4/1.5,64-card.w/3,card.w/4/1.5,card.h/10/1.5)//osu
	print("hola! bienvenide a tu" ,22,13,0)
	print("amigue invisible wrapped 2023!",6,25,0)
	if(txt.show) then 
		print("yo soy dario!" ,38,text_pos.y+74,green_to_black[ceil(txt.clr)])
		print("@totohitori",42,text_pos.y + 86,green_to_black[ceil(txt.clr)])
	end
end
function draw_slide_hk()
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
	sspr(64,16,8,16,x+50*scale,y+30*scale,card.w/6,card.h/3)//hornet
	if(txt.show) then 
		print(" veo que te gusta",29,text_pos.y+48,blues[ceil(txt.clr)])
		print(" hollow knight...",30,text_pos.y+58,blues[ceil(txt.clr)])
		print("2023 was a   year  ",30,text_pos.y+68,blues[ceil(txt.clr)])
		spr(57,72,text_pos.y+66) // clown emoji
	end
end
function draw_slide_osu()
	rectfill(0,0,128,128,10)
	//wrapped
	draw_polygons({14,0})

	local x = (128-card.w)/2 + card.dx
	local y = (128-card.h)/2 + card.dy +14
	local scale = (card.w/card.max_w)
	draw_card_poly(x,y,{13,0,13})
	sspr(14*8,16,16,16,x+11,y+10,card.w/1.5,card.h/1.5)//osu
	if(txt.show) then 
		print(" juegas a osu!",35,text_pos.y+48,blues[ceil(txt.clr)])
		print(" yo tambien!",39,text_pos.y+58,blues[ceil(txt.clr)])
		print("nos gusta sufrir jeje  ",22,text_pos.y+68,blues[ceil(txt.clr)])
	end
end
function draw_slide_kity()
	rectfill(0,0,128,128,11)
	//wrapped
	//draw_card(14)
	draw_polygons({10,0})
	local x = (128-card.w)/2 + card.dx
	local y = (128-card.h)/2 + card.dy +14
	local scale = (card.w/card.max_w)
	draw_card_poly(x,y,{10,0,14})
	sspr(0,32,32,32,x+11,y+10,card.w/1.5,card.h/1.5)//knight
	if(txt.show) then 
		print("probe kity builder",29,text_pos.y+48,blues[ceil(txt.clr)])
		print("en el idd y",43,text_pos.y+58,blues[ceil(txt.clr)])
		print("me gusta mucho jeje",27,text_pos.y+68,blues[ceil(txt.clr)])
	end
end
function draw_slide_celeste()
	rectfill(0,0,128,128,14)
	//wrapped
	draw_card(9)
	draw_polygons({9,2})
	local x = (128-card.w)/2 + card.dx
	local y = (128-card.h)/2 + card.dy +14
	local scale = (card.w/card.max_w)
	//draw_card_poly(x,y,{10,0,14})
	sspr(32,32+anim.spr1*16,16,16,x+1,y+31,card.w/2,card.h/2)//madeline
	sspr(48,48-anim.spr1*16,16,16,x+34,y+31,card.w/2,card.h/2)//lani
	sspr(64,32+anim.spr2*8,8,8,x+26,y+20-straw.dy,card.w/4,card.h/4)//lani
	if(txt.show) then 
		print("omg jugaste celeste 2!",(128-22*4)/2,text_pos.y+48,blues[ceil(txt.clr)])
		print("me encanta crear en pico8",(128-25*4)/2,text_pos.y+58,blues[ceil(txt.clr)])
		print("y celeste es mi juego fav :)",(128-27*4)/2,text_pos.y+68,blues[ceil(txt.clr)])
	end
end
function draw_slide_anime()
	rectfill(0,0,128,128,7)
	//wrapped
	draw_card(8)
	draw_polygons({8,12})
	local x = (128-card.w)/2 + card.dx
	local y = (128-card.h)/2 + card.dy +14
	local scale = (card.w/card.max_w)
	sspr(3*8,64+16,16,16,x+12,y+10,card.w/1.5,card.h/1.5)//anya
	if(txt.show) then 
		print("hice un excel (ayuda) con",14,text_pos.y+44,blues[ceil(txt.clr)])
		print("nuestros gustos en anime:",16,text_pos.y+54,blues[ceil(txt.clr)])
		print("los animes coinciden un 11%",12,text_pos.y+64,blues[ceil(txt.clr)])
		print("y las notas en un 88.6%!  ",17,text_pos.y+74,blues[ceil(txt.clr)])
	end
end
function draw_slide_end()
	rectfill(0,0,128,128,0)
	draw_bands(110,84,-1)
	draw_bands(-2,-4,1)
	//wrapped
	print("en fin, me ha resultado " ,22,text_pos.y+13,7)
	print("super guay ver que coincidimos ",5,text_pos.y + 25,7)
	print("en tantos gustos y me pareces",7,text_pos.y + 37,7)
	print("una persona super chula. ",18,text_pos.y + 49,7)
	print("que tengas un feliz 2024!",14,text_pos.y + 61,7)
	
	spr(sambe.spr+anim.spr1*2,56,106,2,2)
end
function draw_transition()
	for i =0,9 do
		rectfill(16*i+rec.x,16*i+rec.y,rec.x+rec.w,rec.y+rec.h,rec.col)
	end
end
function draw_polygons(color_scheme)
	render_poly({-30,-10,50,2,40,16,10,30},color_scheme[1])
	render_poly({-40,-10,30,12,2,10,10,40},color_scheme[2])
	local newy = 110
	local newx = 100
	render_poly({20+newx,-30+newy,50+newx,2+newy,40+newx,16+newy,10+newx,30+newy},color_scheme[1])
	render_poly({20+newx,-10+newy,30+newx,12+newy,2+newx,10+newy,10+newx,40+newy},color_scheme[2])
end
function draw_card_poly(x,y,color_scheme)
	render_poly({x+10,y+15,x+50,y+15,x+60,y+55,x+0,y+55},color_scheme[1])
	render_poly({x,y+15,x+50,y+25,x+70,y+35,x+16,y+65},color_scheme[2])
	render_poly({x,y+25,x+50,y+25,x+70,y+45,x+10,y+55},color_scheme[3])
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
			clr = 5
		end
		rectfill( 5*(i+1) +size*i,3,5*i +size*i+size,5,clr)
	end
end
-->8
--utils
-- draws a filled convex polygon
-- v is an array of vertices
-- {x1, y1, x2, y2} etc
function render_poly(v,col)
	col=col or 5
   
	-- initialize scan extents
	-- with ludicrous values
	local x1,x2={},{}
	for y=0,127 do
	 x1[y],x2[y]=128,-1
	end
	local y1,y2=128,-1
   
	-- scan convert each pair
	-- of vertices
	for i=1, #v/2 do
	 local next=i+1
	 if (next>#v/2) next=1
   
	 -- alias verts from array
	 local vx1=flr(v[i*2-1])
	 local vy1=flr(v[i*2])
	 local vx2=flr(v[next*2-1])
	 local vy2=flr(v[next*2])
   
	 if vy1>vy2 then
	  -- swap verts
	  local tempx,tempy=vx1,vy1
	  vx1,vy1=vx2,vy2
	  vx2,vy2=tempx,tempy
	 end 
   
	 -- skip horizontal edges and
	 -- offscreen polys
	 if vy1~=vy2 and vy1<128 and
	  vy2>=0 then
   
	  -- clip edge to screen bounds
	  if vy1<0 then
	   vx1=(0-vy1)*(vx2-vx1)/(vy2-vy1)+vx1
	   vy1=0
	  end
	  if vy2>127 then
	   vx2=(127-vy1)*(vx2-vx1)/(vy2-vy1)+vx1
	   vy2=127
	  end
   
	  -- iterate horizontal scans
	  for y=vy1,vy2 do
	   if (y<y1) y1=y
	   if (y>y2) y2=y
   
	   -- calculate the x coord for
	   -- this y coord using math!
	   x=(y-vy1)*(vx2-vx1)/(vy2-vy1)+vx1
   
	   if (x<x1[y]) x1[y]=x
	   if (x>x2[y]) x2[y]=x
	  end 
	 end
	end
   
	-- render scans
	for y=y1,y2 do
	 local sx1=flr(max(0,x1[y]))
	 local sx2=flr(min(127,x2[y]))
   
	 local c=col*16+col
	 local ofs1=flr((sx1+1)/2)
	 local ofs2=flr((sx2+1)/2)
	 memset(0x6000+(y*64)+ofs1,c,ofs2-ofs1)
	 pset(sx1,y,c)
	 pset(sx2,y,c)
	end 
   end
__gfx__
00000000bbbbbbbbdddddddddddddddddddddddddddddddddddddddddddddddd000ddd0000ddd000dddddddddddddddddddddddddddddddddddddddddddddddd
00000000bbbbbbbbdddddddddddddddddddddddddddddddddddddddddddddddd000ddd0000ddd000dddddddddddddddddddddddddddddddddddddddddddddddd
00700700bbbbbbbbdddddddddddddddddddddddddddddddddddddddddddddddd000ddd0000ddd000dddddddddddddddddddddddddddddddddddddddddddddddd
00077000bbbbbbbbdddddddddddddddddddddddddddddddddddddddddddddddd000ddd0000ddd000dddddddddddddddd000dddddddd000dddddddddddddddddd
00077000bbbbbbbbddddd0000000ddddddddd000000dddddddddd0000000dddd000ddd0000ddd000000dd000d000000d000d00000dd000d000000dddd000000d
00700700bbbbbbbbddd0000000000ddddddd00000000ddddddd0000000000ddd0000d000000d0000000d0000000000000000000000d00000000000dd00000000
00000000bbbbbbbbdd000000000000ddddd0000000000ddddd000000000000dd0000d000000d000000000000000000000000000000d00000000000d000000000
00000000bbbbbbbbdd000000000000dddd000000000000dddd000000000000ddd000d000000d000d00000000d00dd0000000ddd00000000dddd00000000dd000
dddee88cddde88ccd00000000000000ddd000000000000ddd00000000000000dd00000000000000d00000ddddddddd00000ddddd000000dddddd000000dddd00
dddee88cdeee88ccd00000ddd000000dd00000dddd00000dd00000ddd000000dd000000dd000000d0000ddddddd00000000ddddd000000dddddd000000000000
ddeee88cdee888ccd0000ddddd00000dd0000dddddd0000dd0000ddddd00000ddd00000dd00000dd000dddddd0000000000ddddd000000dddddd00000000000d
ddee888cee888ccdd0000ddddd00000dd0000dddddd0000ddddddddddd00000ddd00000dd00000dd000ddddd000000000000dddd0000000ddddd0000000000dd
dee888ccee88cccdd0000ddddd00000dd0000dddddd0000dddddddddd000000ddd00000dd00000dd000ddddd000ddd0000000dd000000000ddd0000000dddddd
ee888ccce888ccddddddddddd000000dd0000dddddd0000dddddddd0000000ddddd000dddd000ddd000ddddd000dd0000000000000d00000000000d0000dd000
e888cccde88cccddddddddd0000000ddd0000dddddd0000dddddddd00000000dddd000dddd000ddd000ddddd00000000000000000dd0000000000dd000000000
e88cccddee8cccdddddddd0000000dddd0000dddddd0000dddddddddd000000dddd000dddd000ddd000dddddd0000d00000d0000ddd000d00000dddd0000000d
ddd8899addd899aaddddd0000000ddddd0000dddddd0000ddddddddddd00000ddd6dd6ddd8eeabcddd7dd7dddddddddd000dddddddd000ddddddd777777ddddd
ddd8899ad88899aadddd0000000dddddd0000dddddd0000dd0000ddddd00000dd67dd67d88eaabc2d67dd77dddd7d6dd000dddddddd000ddddd77eeeeee77ddd
dd88899ad88999aaddd0000000ddddddd00000dddd00000dd00000ddd000000dd67dd67d8eeabbc2d6dddd7ddd67d77d000dddddddd000dddd7eeeeeeeeee7dd
dd88999a88999aaddd0000000ddddddddd00000dd00000ddd00000000000000dd677d67d8eeabcc2d677777dd66ddd7d000dddddddd000ddd7eeeeeeeeeeee7d
d88999aa8899aaadd00000000000000ddd000000000000dddd000000000000ddd677777d88eabc22d600770dd677777d000dddddddd000ddd7eeeeeeeeeeee7d
88999aaa8999aaddd00000000000000dddd0000000000ddddd000000000000ddd677777dddddddddd600770dd600770d000dddddddd000dd7e777e77e7e7e7e7
8999aaad899aaaddd00000000000000ddddd00000000ddddddd0000000000dddd600700dddddddddd6cc77cdd600770ddddddddddddddddd7e7e7e7ee7e7e7e7
899aaadd889aaaddd00000000000000dddddd000000dddddddddd0000000ddddd600700ddddd8ddddd5c15ddd6cc77cddddddddddddddddd7e7e7e77e7e7e7e7
ddd77aacddd7aaccdddddddddddddddddddddddddddddddddddddddddddddddddd67777d88777788d151515dddc151cddddddddddddddddd7e7e7ee7e7e7eee7
ddd77aacd777aaccdddddddddddddddddddddddddddddddddddddddddddddddddd26772d8777777815100515d155551ddddddddddddddddd7e777e77e777e7e7
dd777aacd77aaaccddddddddddddddddddddddddddddddddddddddddddddddddd882228d771771771510055115100551ddddddddddddddddd7eeeeeeeeeeee7d
dd77aaac77aaaccddddddddddddddddddddddddddddddddddddddddddddddddd88288888ee7887ee5100015515100155ddddddddddddddddd7eeeeeeeeeeee7d
d77aaacc77aacccddddddddddddddddddddddddddddddddddddddddddddddddd25588882ee7887ee5100501551100515dddddddddddddddddd7eeeeeeeeee7dd
77aaaccc7aaaccdddddddddddddddddddddddddddddddddddddddddddddddddd2552222277222277d10dd0d1115d0051ddddddddddddddddddd77eeeeee77ddd
7aaacccd7aacccdddddddddddddddddddddddddddddddddddddddddddddddddd5500d00dd772277dddddddddddddddddddddddddddddddddddddd777777ddddd
7aacccdd77acccdddddddddddddddddddddddddddddddddddddddddddddddddd5dd0d0dddd7777dddddddddddddddddddddddddddddddddddddddddddddddddd
dddddd00dddd0000000dddd00dddddddbbbbbb00000bbbbbbbbbb000000bbbbbbbb000bb00000000dddddddddddddddddddddddddddddddddddddddddddddddd
dddddd000000aaaaaaa000000dddddddbbbbb0288820bbbbbbbb01111110bbbbb000330b00000000dddd22dddddddddddddddddddddddddddddddddddddddddd
dddddd0200a9aaaaaaa9a0220dddddddbbbb088888820bbbbbb0111111100bbb0330303000000000dddd22dddddddddddddddddddddddddddddddddddddddddd
ddddd002200a9aaaaa9a022200ddddddbbb0288882880bbbbbb0111111110bbbb008020b00000000dd2222dddddddddddddddddddddddddddddddddddddddddd
dddd090222009aaaaa900222090dddddbbb0888882280bbbbbb0111411110bbbb02e820b00000000dd2222ddddddddddddddddddd0000dddddd0000ddddddddd
dddd090222209aaaaa902222090dddddbbb0882999900bbbbbbb044414100bbbb0822e0b00000000dddd22ddddddddddddddddddd0000dddddd0000ddddddddd
ddd0990222209aaaaa902222090dddddbbb0829ffff00bbbbbb0044444010bbbbb0880bb00000000dddd22ddddddddddddddddddd00000dddd00000ddddddddd
ddd0990221109aaaaa9021120990ddddbb00822fff020bbbbb011044440110bbbbb00bbb00000000ddddddddddddddddddddddddd00000dddd00000ddddddddd
ddd0990111aa9aaaaa9a11110990ddddb02220112200bbbbb0110aaaaaa100bbbb0000bb00000000dddddd8888dddd22ddccddddd00000dddd00000ddddddddd
ddd099911aa99aaaaa99a1119990ddddb02444ccc110bbbbbb000222aaaaaaabb030330b00000000dddddd8888dddd22ddccddddd000000dd000000ddddddddd
d00999999999aaaaaaa99999999900ddb044411cccc10bbbbbb0222222aaaaaa0303333000000000bbdddddd8888222222ccdddddd000000000000dddddddddd
d0aaaaaaaaaa9999999aaaaaaaaaa0dd0dd41f9cccc0f0bbbb0402222440bbbab008020b00000000bbdddddd8888222222ccddddddd0000000000ddddddddddd
d0aa999aaaaaaaaaaaaaaaaa999aa0dd0dd40f944440f0bbbb0402222440bbbbb028e80b00000000bbbbddaaaa99999911ccdddddddd00000000dddddddddddd
d0a999999aaaaaaaaaaaaaa99999a0dd0dd4022222200bbbbbb001111110bbbbb0e8220b00000000bbbbddaaaa99999911ccdddddddd00000000dddddddddddd
dd0900229999999999999992200900ddb00002200220bbbbbbbb01100110bbbbbb0880bb00000000ddbbddaaaa99111111ccdddddddd00000000dddddddddddd
ddd00222222222222222222222000dddbbbb04400440bbbbbbbb07700770bbbbbbb00bbb00000000ddbbddaaaa99111111ccddddddd0000000000ddddddddddd
dddd022220077222220077222220ddddbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0b00bbdddddddddddddddddddddddddddddddddd000000000000dddddddddd
dddd022220077222220077222220ddddbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb030030bdddddddddddddddddddddddddddddddddd000000000000dddddddddd
dddd022220077222220077222220ddddbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb03303330ddddddddddddddddddddddddddddddddd000000dd000000ddddddddd
dddd022220011222220011222220ddddbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb002080bddddddddddddddddddddddddddddddddd00000dddd00000ddddddddd
dddd011220000222220000221110ddddbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0828e0bddddddddddddddddddddddddddddddddd00000dddd00000ddddddddd
dddd022222222222222222222220ddddbbbbbb00000bbbbbbbbbb000000bbbbbb02e820bddddddddddddddddddddddddddddddddd00000dddd00000ddddddddd
ddddd0211222222222222221120dddddbbbbb0288820bbbbbbbb01111110bbbbbb0880bbddddddddddddddddddddddddddddddddd0000dddddd0000ddddddddd
dddddd02222222222222222220ddddddbbbb088882880bbbbbb0111111110bbbbbb00bbbddddddddddddddddddddddddddddddddd0000dddddd0000ddddddddd
ddddddd000011111111110000dddddddbbbb088882280bbbbbb0111411110bbbbb0b00bbbeeeeeebeeeeeeebeebbbbbbbeeeeeebeeeeeeebb666666bdddddddd
dddddddd0211111111111120ddddddddbbbb089999900bbbbbb0044414100bbbb030030beeeeeeeeeeeeeeeeeebbbbbbeeeeeeeeeeeeeeee66666666dddddddd
ddddddd022222222222222220dddddddbb00028fff020bbbbb011044440110bb03303330eebbbbeeeebbbbbbeebbbbbbeebbbbbbbbbeebbbbbbbb666dddddddd
dddddd02222222999922222220ddddddb02221ccc1110bbbbbb00aaaaaaa10bbb002080beebbbbeeeebbbbbbeebbbbbbeebbbbbbbbbeebbbbbb6666bdddddddd
dddddd02222229999992222220ddddddb0244f9ccc10f0bbbb04022224aaabbbb0828e0b22bbbbbb2222bbbb22bbbbbb22222222bbb22bbbbbddddbbdddddddd
ddddd022222229ffff922222220ddddd0dd41f9cccc0f0bbbb0402222440aabbb02e820b22bbbb2222bbbbbb22bbbbb2bbbbbbb2bbb22bbbbdddbbbbdddddddd
ddddd02210222ffffff22201220ddddd0dd4022222200bbbbbb001111110aabbbb0880bb222222222222222b2222222222222222bbb22bbbdddddddddddddddd
ddddd02210222ffffff22201220dddddb00004400440bbbbbbbb07700770abbbbbb00bbbb222222b2222222222222222b222222bbbb22bbbdddddddddddddddd
0900000000000000000000000000000000000000000000000000000000000000dddddddddddddddddddddddddddddddd000d000d000000000000000000000000
0990000000000000009000000000000000000000000000000000000000000000ddddddddddddddddddddddddddddddddd00000dd000000000000000000000000
9999009999999000099900000000000000990000000000000900000000000000dddddddd0000000000000000ddddddddd00d0000000000000000000000000000
9999099999999900099900999999900009990099999990009990009999999000ddddd000000000000000000000ddddddd000000d000000000000000000000000
9999999999999990999909999999990099990999999999009999099999999900dddd00000000000000000000000ddddddd00000d000000000000000000000000
9999999099099999999999909909999099999999999999909999999999999990ddd0000000000000000000000000ddddd00000dd000000000000000000000000
9998899900999999999989990099999999999990990999999999899099099999ddd0000000000000000000000000dddd00000ddd000000000000000000000000
9988888999999999999889999999999999998999009999999998899900999999ddd00000000000000000000000000dddd00000dd000000000000000000000000
9888888889999999998888899999999999998889999999999988888999999999ddd00000000000000000000000000ddd00000000000000000000000000000000
0888888888799990998888888999999999988888899999999988888889999999ddd000000fff00000000000000000ddd00000000000000000000000000000000
0888992977700000098888888879999009988888887999900988888888799990dd00000ffffff00f0000000000000ddd00000000000000000000000000000000
0099922977720000009888887772000000988888877000000098888877720000dd0000ffffffffff000000f0000000dd00000000000000000000000000000000
0000229977722000009888297772200000998888777200000098882977722000dd000ffffffffffff00000f0000000dd00000000000000000000000000000000
0002299977200000000022997770000000002888777220000000229977700000dd000f00000fffff0000000f000000dd00000000000000000000000000000000
0000022000200000000222297720000000022999772000000002222977200000dd0000000000fff00000000f000000dd00000000000000000000000000000000
0000220000200000000022000020000000002200002000000000220000200000dd0020000000fff00000000f000000dd00000000000000000000000000000000
00000000000001100444444411aaeeeeeeea1111000000000000000000000000dd2020000000fff0000000ff000220dddd2020000000fff0000000ff00000000
0000000000005611041444741aaeeeeeeeeaa111000000000000000000000000d2f55f55555fffff5555555ff52ff2ddd2f55f55555fffff5555555f00000000
0009900000666661011167771aeeeeeeeeeeaa11000000000000000000000000d2ff550000055ff55000000555f2f2ddd2ff55fffff55ff55ffffff500000000
0099990006666501041117741aeeeeeeeeeeea10000000000000000000000000d2ff20070000555f070000005ff2f2ddd2ff2f000000555f0000000000000000
0899998065666011041177740eee2eeee2eeeee0000000000000000000000000d2f2207700070ff077000070fff2f2ddd2f2207700070ff07700007000000000
998888991656001004617164eeeffefeefeeeee0000000000000000000000000d2f2ff766007ffff7760007ffffff2ddd2f2ff766007ffff7760007f00000000
999999991111011004476614eefffffeefffeeee000000000000000000000000dd22fff0000ffffff000000ffff220dddd22fff0000ffffff000000f00000000
009999000111110004444444eef111fff111feee000000000000000000000000dd02ffffffff2e2fffffffffff2200dddd02ffffffff2e2fffffffff00000000
000000000000000000000000ee17371f17371eee000000000000000000000000dd0288fffffff2fffffff8888f2000dddd2020000000fff0000000ff00000000
000000000000000000000000eefffffffffffeee000000000000000000000000dd02288fffffffffffff88888f2000ddd2f55f55555fffff5555555f00000000
000000000000000000000000eefff7fff7fffeee000000000000000000000000d000288fffff2fff2fff8888f22000ddd2ff55fffff55ff55ffffff500000000
000000000000000000000000eeefff777fffeeee000000000000000000000000d00002fffffff222ffffffff2200000dd2ff2ffffff0555ffffffff000000000
000000000000000000000000eeeefffffffeeee2000000000000000000000000d0000222fffffffffffff2222000000dd2f2200fffff0ff0ffffff0000000000
000000000000000000000000eeee2299922eee20000000000000000000000000d000000222222222222222000000000dd2f2ff000000ffff0000000f00000000
0000000000000000000000000eee26fff62ee220000000000000000000000000d00d000c162fffffffff2261c00d000ddd22fff0000ffffff000000f00000000
00000000000000000000000000ee176f671e2200000000000000000000000000dddd61cc1772222222227771cc16dddddd02ffffffff2e2fffffffff00000000
dddddddddddddddddddd00dddddddddd000000000000176f67100000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddddddddddddddd00dddddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00ddd00ddddddddddddd0ddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000d000dd000dd00d00ddd0000dddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000d00000d00d00dd00000dddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000d00d00d00d00dd000dddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000d00000d00d00ddd0000dddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00d0d00d00000d00d00ddddd00dddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00ddd00d00d00d00000dd00000dddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00ddd00d00d00dd000ddd0000ddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddddddddddddddddddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddddddddddddddddddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddddddddddddddddddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddddddddddddddddddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddddddddddddddddddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddddddddddddddddddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddddddddddddddddddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddddddddddddddddddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddddddddddddddddddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddddddddddddddddddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddddddddddddddddddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddddddddddddddddddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddddddddddddddddddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddddddddddddddddddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddddddddddddddddddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddddddddddddddddddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddddddddddddddddddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddddddddddddddddddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddddddddddddddddddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddddddddddddddddddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddddddddddddddddddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddddddddddddddddddddddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
