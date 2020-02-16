--[[------------------------------------------------------------------------
__  ___       _ __ _          ____                 __           __ 
\ \/ (_)___ _(_) /( )_____   / __ \_________  ____/ /_  _______/ /_
 \  / / __ `/ / __/// ___/  / /_/ / ___/ __ \/ __  / / / / ___/ __/
 / / / /_/ / / /_  (__  )  / ____/ /  / /_/ / /_/ / /_/ / /__/ /_  
/_/_/\__, /_/\__/ /____/  /_/   /_/   \____/\__,_/\__,_/\___/\__/  
    /____/  
----------------------------------------------------------------------------
  Places you can change:
  
Line 40: Write your map's name
Line 41:  Write the coordinate of the places you want it to be	
Line 70: Write your staff usergroups name
Line 109: Write your server's name here
Line 140: Write your server's name here
Line 140+: You can add what ever you want
Line 129-135: Translate to your language
And that's it, enjoy!

 Colors
 
Line 131: left header color
Line 152: background2 color
Line 156: background color
Line 168: clock color 
Line 169: time color 

Default Background(85,88,90)
Default Background 2(5,5,45,50)

Color(242,108,79) = Orange
Color(66, 139, 202) = Blue
Color(215, 85, 80) = Red
Color(26, 188, 156)	= Turquoise
Color(92, 184, 92)	= Green
Color(91, 192, 222)	= Light blue

 
 (If you have any questions, you can contact me via the gmod store.)
---------------------------------------------------------------------------]]

surface.CreateFont("tabelabig", {
	font = "Bebas Neue", 
	extended = true,
	size = 128,
	weight = 700,
})

surface.CreateFont("tabelaufak", {
	font = "Bebas Neue", 
	extended = true,
	size = 56,
	weight = 500,
})

local wid, tall

local function WorldToScreen(vWorldPos,vPos,vScale,aRot)
    local vWorldPos=vWorldPos-vPos

    vWorldPos:Rotate(Angle(0,-aRot.y,0))
    vWorldPos:Rotate(Angle(-aRot.p,0,0))
    vWorldPos:Rotate(Angle(0,0,-aRot.r))

    return vWorldPos.x/vScale,(-vWorldPos.y)/vScale
end

local tabl = {
	["rp_downtown_tits_v2"] = {
		{Vector(-2768, -4345, 177.6), Angle(0,0,90)},
		{Vector(-2796.5, -788, 157.1), Angle(0,0,90)},
		{Vector(69.9, -621, 110.1), Angle(0,0,90)},
		{Vector(4612.9, 4059.5, 157.3), Angle(0,270,90)},
		{Vector(-04.9, 413.1, 129.3), Angle(0,180,90)}
	}
}

local function pingorthesapla()
	local pingort = 0
	for k,v in pairs(player.GetHumans()) do 
		pingort = pingort + v:Ping()
	end
	pingort = pingort/#player.GetHumans()
	pingort = math.floor(pingort)

	return pingort
end

local function yetkilihesapla()
	local yetkili = 0 
	local yetkililer = {"admin","helper","helper+","basadmin","moderator","moderator+","superadmin"} --staffs
	for k,v in pairs(player.GetAll()) do
		if table.HasValue(yetkililer,v:GetUserGroup()) then
			yetkili = yetkili + 1
		end
	end
	return yetkili
end

local function oyuncuhesapla()
	return #player.GetAll().."/"..game.MaxPlayers()
end

local next_fps = CurTime()+0.1
local last_fps = math.Round(1/FrameTime())

local function fpshesapla()
	if next_fps<=CurTime() then
		last_fps = math.Round(1/FrameTime())
		next_fps = CurTime()+0.5
	end

	return last_fps
end

local infos = {}

local function drawinfo(value,text)
	if not infos[value] then
		local toinsert = {}
		toinsert.txt = text
		toinsert.val = value 
		toinsert.ypos = table.Count(infos)*50
		toinsert.index = table.Count(infos)+1
		infos[value] = toinsert
	end
end

local function drawinfos()
	for k,v in pairs(infos) do 
		draw.RoundedBox(0,0,v.ypos,wid,50,v.index%2==0 and Color(5,5,45,50) or Color(85,88,90,60)) --background 2
		draw.SimpleText(v.val,"tabelaufak",10,v.ypos,Color(242,108,79),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP) --leftheaders
		draw.SimpleText(isfunction(v.txt) and v.txt() or v.txt,"tabelaufak",wid/2,v.ypos,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)	
	end
end

hook.Add("PostDrawOpaqueRenderables", "polo3d2d", function()
	wid, tall = 740, 386
	local textwid, texttall

	surface.SetFont("tabelaufak")
	textwid, texttall = surface.GetTextSize("FakePoloRolePlay")

	local renk = Vector(math.abs((math.sin(CurTime()*0.5))*255)-100, (math.abs(math.sin(CurTime()*0.3))*255)-100, (math.abs(math.sin(CurTime()*0.2))*255)-100)

	if tabl[game.GetMap()] then
		for k,v in pairs(tabl[game.GetMap()]) do 
			local pos, ang = v[1], v[2]
			
			local hitpos = LocalPlayer():GetEyeTrace().HitPos
			local mousex, mousey = WorldToScreen(hitpos,pos,0.3,ang)

			if (LocalPlayer():GetPos():DistToSqr(pos)<=1562500) then
			cam.Start3D2D(pos,ang,0.3)
			
				draw.RoundedBox(0,0,0,wid,tall,Color(85,88,90)) --background


				if mousex>0 and mousex<wid and mousey>0 and mousey<tall then 

					drawinfo("CITY:",game.GetMap())
					drawinfo("PLAYER:",oyuncuhesapla)
					drawinfo("STAFF:",yetkilihesapla)
					drawinfo("PING:",pingorthesapla) 
					drawinfo("FPS:",fpshesapla)

					drawinfos()

					draw.RoundedBox(32,mousex-2.5,mousey-2.5,5,5,color_white)
				else
				draw.RoundedBox(0,0,tall/2-texttall,wid,texttall*2,Color(45,45,45,50))
				draw.SimpleTextOutlined("YOUR SERVER","tabelabig",wid/2,tall/2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,renk) --server name
				
				draw.SimpleText(os.date("%H:%M"),"tabelaufak",wid/2,7,Color(242,108,79),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP) --clock
				draw.SimpleText(os.date("%d.%m.%Y"),"tabelaufak",wid/2,tall-7,Color(242,108,79),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM) --time
				end
			--	end
			cam.End3D2D()
			end
		end
	end
end)

hook.Remove("HUDPaint","polopaint")