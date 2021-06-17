local type = type;
local next = next;

local function Copy(tt, lt)
	local copy = {}
	if lt then
		if type(tt) == "table" then
			for k,v in next, tt do
				copy[k] = Copy(k, v)
			end
		else
			copy = lt
		end
		return copy
	end
	if type(tt) != "table" then
		copy = tt
	else
		for k,v in next, tt do
			copy[k] = Copy(k, v)
		end
	end
	return copy
end

local surface = Copy(surface);
local vgui = Copy(vgui);
local input = Copy(input);
local Color = Color;
local ScrW, ScrH = ScrW, ScrH;
local gui = Copy(gui);
local math = Copy(math);
local file = Copy(file);
local util = Copy(util);

surface.CreateFont("memeyou", {
	font = "Console",
	size = 13,
	weight = 900,
	shadow = true,
	antialias = false,
});

surface.CreateFont("memeyou2", {
	font = "Console",
	size = 13,
	weight = 900,
	shadow = false,
	antialias = false,
});

local options = {
	["Ragebot"] = {
		{
			{"Aimbot", 20, 20, 350, 240, 120},
			{"Enabled", "Checkbox", false, 0},
			{"Silent", "Checkbox", false, 0},
			{"Autofire", "Checkbox", false, 0},
			{"Autosnap", "Checkbox", false, 0},
			{"Auto Pistol", "Checkbox", false, 0},
			{"Non-Sticky", "Checkbox", false, 0},
			{"Bullettime", "Checkbox", false, 0},
		},
		{
			{"Target", 20, 280, 350, 180, 120},
			{"Selection", "Selection", "Distance", {"Distance", "Health", "Nextshot"}, 150 },
			{"Bodyaim", "Checkbox", false, 0},
			{"Ignore Bots", "Checkbox", false, 0},
			{"Ignore Team", "Checkbox", false, 0},
			{"Ignore Friends", "Checkbox", false, 0},
			{"Snapline", "Checkbox", false, 0},
		},
		{
			{"Accuracy", 380, 20, 350, 190, 120},
			{"Anti Spread", "Checkbox", false, 0},
			{"Anti Recoil", "Checkbox", false, 0},
		},
		{
			{"Anti-Aim", 380, 230, 350, 230, 140},
			{"Enabled", "Checkbox", false, 0},
			{"X", "Selection", "Emotion", {"Up", "Down", "Jitter", "Emotion"}, 150},
			{"Y", "Selection", "Emotion", {"Forward", "Backwards", "Jitter", "TJitter", "Sideways", "Emotion", "Static", "Towards Players"}, 150},
			{"Max Y", "Slider", 50, 360, 150},
			{"Min Y", "Slider", 0, 360, 150},
			{"Emotion Randomcoin X", "Slider", 50, 100, 150},
			{"Emotion Randomcoin Y", "Slider", 20, 100, 150},
		},
	},
	["Visuals"] = {
		{
			{"ESP", 20, 20, 350, 240, 220},
			{"Enabled", "Checkbox", false, 54},
			{"Box", "Checkbox", false, 54},
			{"Box Type", "Selection", "2D Box", {"2D Box", "3D Box"}, 68},
			{"Name", "Checkbox", false, 54},
			{"Health", "Checkbox", false, 54},
			{"Weapon", "Checkbox", false, 54},
			{"XQZ", "Checkbox", false, 54},
			{"Chams", "Checkbox", false, 54},
			{"Skeleton", "Checkbox", false, 54},
		},
		{
			{"Filter", 20, 280, 350, 180, 220},
			{"Enemies only", "Checkbox", false, 54},
			{"Distance", "Checkbox", false, 54},
			{"Max Distance", "Slider", 0, 10000, 68},
		},
		{
			{"Misc", 380, 20, 350, 190, 220},
			{"Thirdperson", "Checkbox", false, 54},
		},
	},
	["Colors"] = {
		{
			{"Box - Team", 20, 20, 250, 175, 130},
			{"R", "Slider", 255, 255, 88},
			{"G", "Slider", 255, 255, 88},
			{"B", "Slider", 0, 255, 88},
		},
		{
			{"Box - Enemy", 20, 205, 250, 175, 130},
			{"R", "Slider", 180, 255, 88},
			{"G", "Slider", 120, 255, 88},
			{"B", "Slider", 0, 255, 88},
		},
		{
			{"Chams - Team", 290, 20, 250, 175, 130},
			{"Visible R", "Slider", 0, 255, 88},
			{"Visible G", "Slider", 255, 255, 88},
			{"Visible B", "Slider", 0, 255, 88},
			{"Not Visible R", "Slider", 0, 255, 88},
			{"Not Visible G", "Slider", 0, 255, 88},
			{"Not Visible B", "Slider", 255, 255, 88},
		},
		
		{
			{"Chams - Enemy", 290, 205, 250, 175, 130},
			{"Visible R", "Slider", 255, 255, 88},
			{"Visible G", "Slider", 0, 255, 88},
			{"Visible B", "Slider", 0, 255, 88},
			{"Not Visible R", "Slider", 180, 255, 88},
			{"Not Visible G", "Slider", 120, 255, 88},
			{"Not Visible B", "Slider", 0, 255, 88},
		},
	},
};

local order = {
	"Ragebot",
	"Visuals",
	"Colors",
};

local function updatevar( men, sub, lookup, new )
	for aa,aaa in next, options[men] do
		for key, val in next, aaa do
			if(aaa[1][1] != sub) then continue; end
			if(val[1] == lookup) then
				val[3] = new;
			end
		end
	end
end

local function loadconfig()
	if(!file.Exists("memeware.txt", "DATA")) then return; end
	local tab = util.JSONToTable( file.Read("memeware.txt", "DATA") );
	local cursub;
	for k,v in next, tab do
		if(!options[k]) then continue; end
		for men, subtab in next, v do
			for key, val in next, subtab do
				if(key == 1) then cursub = val[1]; continue; end
				updatevar(k, cursub, val[1], val[3]);
			end
		end
	end
end

local function gBool(men, sub, lookup)
	if(!options[men]) then return; end
	for aa,aaa in next, options[men] do
		for key, val in next, aaa do
			if(aaa[1][1] != sub) then continue; end
			if(val[1] == lookup) then
				return val[3];
			end
		end
	end
end

local function gOption(men, sub, lookup)
	if(!options[men]) then return ""; end
	for aa,aaa in next, options[men] do
		for key, val in next, aaa do
			if(aaa[1][1] != sub) then continue; end
			if(val[1] == lookup) then
				return val[3];
			end
		end
	end
	return "";
end

local function gInt(men, sub, lookup)
	if(!options[men]) then return 0; end
	for aa,aaa in next, options[men] do
		for key, val in next, aaa do
			if(aaa[1][1] != sub) then continue; end
			if(val[1] == lookup) then
				return val[3];
			end
		end
	end
	return 0;
end

local function saveconfig()
	file.Write("memeware.txt", util.TableToJSON(options));
end

local mousedown;
local candoslider;
local drawlast;

local visible = {};

for k,v in next, order do
	visible[v] = false;
end

local function DrawBackground(w, h)
	surface.SetDrawColor(255, 255, 255);
	surface.DrawRect(0, 0, w, h);
	
	local curcol = Color(182, 0, 0);
	
	for i = 0, 30 do
		surface.SetDrawColor(curcol);
		curcol.r = curcol.r - 1;
		surface.DrawLine(0, i, w, i);
	end
	
	surface.SetDrawColor(curcol);
	
	surface.SetFont("memeyou");
	
	local tw, th = surface.GetTextSize("Memeware");
	
	surface.SetTextPos(5, 15 - th / 2);
	
	surface.SetTextColor(255, 255, 255);
	
	surface.DrawText("Memeware");
	
	surface.DrawRect(0, 31, 5, h - 31);
	surface.DrawRect(0, h - 5, w, h);
	surface.DrawRect(w - 5, 31, 5, h);
end

local function MouseInArea(minx, miny, maxx, maxy)
	local mousex, mousey = gui.MousePos();
	return(mousex < maxx && mousex > minx && mousey < maxy && mousey > miny);
end

local function DrawOptions(self, w, h)
	local mx, my = self:GetPos();
	
	local sizeper = (w - 10) / #order;
	
	local maxx = 0;
	
	for k,v in next, order do
		local bMouse = MouseInArea(mx + 5 + maxx, my + 31, mx + 5 + maxx + sizeper, my + 31 + 30);
		if(visible[v]) then
			local curcol = Color(0, 0, 0);
			for i = 0, 30 do
				surface.SetDrawColor(curcol);
				curcol.r, curcol.g, curcol.b = curcol.r + 3, curcol.g + 3, curcol.b + 3;
				surface.DrawLine( 5 + maxx, 31 + i, 5 + maxx + sizeper, 31 + i);
			end
		elseif(bMouse) then
			local curcol = Color(124, 124, 124);
			for i = 0, 30 do
				surface.SetDrawColor(curcol);
				curcol.r, curcol.g, curcol.b = curcol.r - 1.7, curcol.g - 1.7, curcol.b - 1.7;
				surface.DrawLine( 5 + maxx, 31 + i, 5 + maxx + sizeper, 31 + i);
			end
		else
			local curcol = Color(51, 51, 51);
			for i = 0, 30 do
				surface.SetDrawColor(curcol);
				curcol.r, curcol.g, curcol.b = curcol.r - 1.7, curcol.g - 1.7, curcol.b - 1.7;
				surface.DrawLine( 5 + maxx, 31 + i, 5 + maxx + sizeper, 31 + i);
			end
		end
		if(bMouse && input.IsMouseDown(MOUSE_LEFT) && !mousedown && !visible[v]) then
			local nb = visible[v];
			for key,val in next, visible do
				visible[key] = false;
			end
			visible[v] = !nb;
		end
		surface.SetFont("memeyou2");
		surface.SetTextColor(255, 255, 255);
		local tw, th = surface.GetTextSize(v);
		surface.SetTextPos( 5 + maxx + sizeper / 2 - tw / 2, 31 + 15 - th / 2 );
		surface.DrawText(v);
		maxx = maxx + sizeper;
	end
end

local function DrawCheckbox(self, w, h, var, maxy, posx, posy, dist)
	surface.SetFont("memeyou2");
	surface.SetTextColor(0, 0, 0);
	surface.SetTextPos( 5 + posx + 15 + 5, 61 + posy + maxy );
	local tw, th = surface.GetTextSize(var[1]);
	surface.DrawText(var[1]);
	
	surface.SetDrawColor(163, 163, 163);
	
	surface.DrawOutlinedRect( 5 + posx + 15 + 5 + dist + var[4], 61 + posy + maxy + 2, 14, 14);
	
	local mx, my = self:GetPos();
	
	local bMouse = MouseInArea(mx + 5 + posx + 15 + 5, my + 61 + posy + maxy, mx + 5 + posx + 15 + 5 + dist + 14 + var[4], my + 61 + posy + maxy + 16);
	
	if(bMouse) then
		surface.DrawRect( 5 + posx + 15 + 5 + dist + 2 + var[4], 61 + posy + maxy + 4, 10, 10);
	end
	
	if(var[3]) then
		surface.SetDrawColor(184, 0, 0);
		surface.DrawRect( 5 + posx + 15 + 5 + dist + 2 + var[4], 61 + posy + maxy + 4, 10, 10);
		surface.SetDrawColor(93, 0, 0);
		surface.DrawOutlinedRect( 5 + posx + 15 + 5 + dist + 2 + var[4], 61 + posy + maxy + 4, 10, 10);
	end
	
	if(bMouse && input.IsMouseDown(MOUSE_LEFT) && !mousedown && !drawlast) then
		var[3] = !var[3];
	end
end

local function DrawSlider(self, w, h, var, maxy, posx, posy, dist)
	local curnum = var[3];
	local max = var[4];
	local size = var[5];
	surface.SetFont("memeyou2");
	surface.SetTextColor(0, 0, 0);
	surface.SetTextPos( 5 + posx + 15 + 5, 61 + posy + maxy );
	surface.DrawText(var[1]);
	
	local tw, th = surface.GetTextSize(var[1]);
	
	surface.SetDrawColor(163, 163, 163);
	
	surface.DrawRect( 5 + posx + 15 + 5 + dist, 61 + posy + maxy + 9, size, 2);
	
	local ww = math.ceil(curnum * size / max);
	
	surface.SetDrawColor(184, 0, 0);
	
	surface.DrawRect( 3 + posx + 15 + 5 + dist + ww, 61 + posy + maxy + 9 - 5, 4, 12);
	
	surface.SetDrawColor(93, 0, 0);
	
	local tw, th = surface.GetTextSize(curnum..".00");
	
	surface.DrawOutlinedRect( 3 + posx + 15 + 5 + dist + ww, 61 + posy + maxy + 4, 4, 12);
	
	surface.SetTextPos( 5 + posx + 15 + 5 + dist + (size / 2) - tw / 2, 61 + posy + maxy + 16);
	
	surface.DrawText(curnum..".00");
	
	local mx, my = self:GetPos();
	
	local bMouse = MouseInArea(5 + posx + 15 + 5 + dist + mx, 61 + posy + maxy + 9 - 5 + my, 5 + posx + 15 + 5 + dist + mx + size, 61 + posy + maxy + 9 - 5 + my + 12);
	
	if(bMouse && input.IsMouseDown(MOUSE_LEFT) && !drawlast && !candoslider) then
		local mw, mh = gui.MousePos();
	
		local new = math.ceil( ((mw - (mx + posx + 25 + dist - size)) - (size + 1)) / (size - 2) * max);
		var[3] = new;
	end
end

local notyetselected;

local function DrawSelect(self, w, h, var, maxy, posx, posy, dist)

	local size = var[5];
	local curopt = var[3];
	
	surface.SetFont("memeyou2");
	surface.SetTextColor(0, 0, 0);
	surface.SetTextPos( 5 + posx + 15 + 5, 61 + posy + maxy );
	local tw, th = surface.GetTextSize(var[1]);
	surface.DrawText(var[1]);
	
	surface.SetDrawColor(163, 163, 163);
	
	surface.DrawOutlinedRect( 25 + posx + dist, 61 + posy + maxy, size, 16);
	
	local mx, my = self:GetPos();
	
	local bMouse = MouseInArea( mx + 25 + posx + dist, my + 61 + posy + maxy, mx + 25 + posx + dist + size, my + 61 + posy + maxy + 16)
	
	local check = dist..posy..posx..w..h..maxy;
	
	if(bMouse || notyetselected == check) then
		
		surface.DrawRect(25 + posx + dist + 2, 61 + posy + maxy + 2, size - 4, 12);
		
	end
	
	local tw, th = surface.GetTextSize(curopt);
	
	surface.SetTextPos( 25 + posx + dist + 5, 61 + posy + maxy + 6 - th / 2 + 2);
	
	surface.DrawText(curopt);
	
	if(bMouse && input.IsMouseDown(MOUSE_LEFT) && !drawlast && !mousedown || notyetselected == check) then
		notyetselected = check;
		drawlast = function()
			local maxy2 = 16;
			for k,v in next, var[4] do
				surface.SetDrawColor(163, 163, 163);
				surface.DrawRect( 25 + posx + dist, 61 + posy + maxy + maxy2, size, 16);
				local bMouse2 = MouseInArea( mx + 25 + posx + dist, my + 61 + posy + maxy + maxy2, mx + 25 + posx + dist + size, my + 61 + posy + maxy + 16 + maxy2)
				if(bMouse2) then
					surface.SetDrawColor(200, 200, 200);
					surface.DrawRect( 25 + posx + dist, 61 + posy + maxy + maxy2, size, 16);
				end
				local tw, th = surface.GetTextSize(v);
				surface.SetTextPos( 25 + posx + dist + 5, 61 + posy + maxy + 6 - th / 2 + 2 + maxy2);
				surface.DrawText(v);
				maxy2 = maxy2 + 16;
				if(bMouse2 && input.IsMouseDown(MOUSE_LEFT) && !mousedown) then
					var[3] = v;
					notyetselected = nil;
					drawlast = nil;
					return;
				end
			end
			local bbMouse = MouseInArea( mx + 25 + posx + dist, my + 61 + posy + maxy, mx + 25 + posx + dist + size, my + 61 + posy + maxy + maxy2);
			if(!bbMouse && input.IsMouseDown(MOUSE_LEFT) && !mousedown) then
				 notyetselected = nil;
				 drawlast = nil;
				 return;
			end
		end
	end
	
	
end

local function DrawSubSub(self, w, h, k, var)
	local opt, posx, posy, sizex, sizey, dist = var[1][1], var[1][2], var[1][3], var[1][4], var[1][5], var[1][6];
	
	surface.SetDrawColor(163, 163, 163);
	
	local startpos = 61 + posy;
	
	surface.SetTextColor(0, 0, 0);
	
	surface.SetFont("memeyou2");
	
	local tw, th = surface.GetTextSize(opt);
	
	surface.DrawLine( 5 + posx, startpos, 5 + posx + 15, startpos);
	
	surface.SetTextPos( 5 + posx + 15 + 5, startpos - th / 2 );
	
	surface.DrawLine( 5 + posx + 15 + 5 + tw + 5, startpos, 5 + posx + sizex, startpos);
	
	surface.DrawLine( 5 + posx, startpos, 5 + posx, startpos + sizey);
	
	surface.DrawLine(5 + posx, startpos + sizey, 5 + posx + sizex, startpos + sizey );
	
	surface.DrawLine( 5 + posx + sizex, startpos, 5 + posx + sizex, startpos + sizey);
	
	surface.DrawText(opt);
	
	local maxy = 15;
	
	for k,v in next, var do
		if(k == 1) then continue; end
		if(v[2] == "Checkbox") then
			DrawCheckbox(self, w, h, v, maxy, posx, posy, dist);
		elseif(v[2] == "Slider") then
			DrawSlider(self, w, h, v, maxy, posx, posy, dist);
		elseif(v[2] == "Selection") then
			DrawSelect(self, w, h, v, maxy, posx, posy, dist);
		end
		maxy = maxy + 25;
	end
end

local function DrawSub(self, w, h)
	for k, v in next, visible do 
		if(!v) then continue; end
		for _, var in next, options[k] do
			DrawSubSub(self, w, h, k, var);
		end
	end
end

local function DrawSaveButton(self, w, h)
	local curcol = Color(235, 235, 235);
	local mx, my = self:GetPos();
	local bMouse = MouseInArea(mx + 30, my + h - 50, mx + 30 + 200, my + h - 50 + 30);
	if(bMouse) then
		curcol = Color(200, 200, 200);
	end
	for i = 0, 30 do
		surface.SetDrawColor(curcol);
		surface.DrawLine( 30, h - 50 + i, 30 + 200, h - 50 + i );
		for k,v in next, curcol do
			curcol[k] = curcol[k] - 2;
		end
	end
	surface.SetFont("memeyou2");
	surface.SetTextColor(0, 0, 0);
	local tw, th = surface.GetTextSize("Save Configuration");
	surface.SetTextPos( 30 + 100 - tw / 2, h - 50 + 15 - th / 2 );
	surface.DrawText("Save Configuration");
	if(bMouse && input.IsMouseDown(MOUSE_LEFT)) then
		saveconfig();
	end
end

local function DrawLoadButton(self, w, h)
	local curcol = Color(235, 235, 235);
	local mx, my = self:GetPos();
	local bMouse = MouseInArea(mx + 250, my + h - 50, mx + 250 + 200, my + h - 50 + 30);
	if(bMouse) then
		curcol = Color(200, 200, 200);
	end
	for i = 0, 30 do
		surface.SetDrawColor(curcol);
		surface.DrawLine( 250, h - 50 + i, 250 + 200, h - 50 + i );
		for k,v in next, curcol do
			curcol[k] = curcol[k] - 2;
		end
	end
	surface.SetFont("memeyou2");
	surface.SetTextColor(0, 0, 0);
	local tw, th = surface.GetTextSize("Load Configuration");
	surface.SetTextPos( 250 + 100 - tw / 2, h - 50 + 15 - th / 2 );
	surface.DrawText("Load Configuration");
	if(bMouse && input.IsMouseDown(MOUSE_LEFT)) then
		loadconfig();
	end
end

loadconfig();

local insertdown2, insertdown, menuopen;

local function menu()
	local frame = vgui.Create("DFrame");
	frame:SetSize(800, 600);
	frame:Center();
	frame:SetTitle("");
	frame:MakePopup();
	frame:ShowCloseButton(false);
	
	frame.Paint = function(self, w, h)
		if(candoslider && !mousedown && !drawlast && !input.IsMouseDown(MOUSE_LEFT)) then
			candoslider = false;
		end
		DrawBackground(w, h);
		DrawOptions(self, w, h);
		DrawSub(self, w, h);
		DrawSaveButton(self, w, h);
		DrawLoadButton(self, w, h);
		if(drawlast) then
			drawlast();
			candoslider = true;
		end
		mousedown = input.IsMouseDown(MOUSE_LEFT);
	end
	
	frame.Think = function()
		if (input.IsKeyDown(KEY_INSERT) && !insertdown2) then
			frame:Remove();
			menuopen = false;
			candoslider = false;
			drawlast = nil;
		end
	end
end

local function Think()
	if (input.IsKeyDown(KEY_INSERT) && !menuopen && !insertdown) then
		menuopen = true;
		insertdown = true;
		menu();
	elseif (!input.IsKeyDown(KEY_INSERT) && !menuopen) then
		insertdown = false;
	end
	if (input.IsKeyDown(KEY_INSERT) && insertdown && menuopen) then
		insertdown2 = true;
	else
		insertdown2 = false;
	end
end

hook.Add("Think", "", Think);

--[[
Actual codens
]]

local FindMetaTable = FindMetaTable;

local em = FindMetaTable"Entity";
local pm = FindMetaTable"Player";
local cm = FindMetaTable"CUserCmd";
local wm = FindMetaTable"Weapon";
local am = FindMetaTable"Angle";
local vm = FindMetaTable"Vector";

local Vector = Vector;
local player = Copy(player);
local Angle = Angle;
local me = LocalPlayer();
local render = Copy(render);
local cma = Copy(cam);
local Material = Material;
local CreateMaterial = CreateMaterial;

--[[
esp
]]

local function Filter(v)
	local enemy = gBool("Visuals", "Filter", "Enemies only");
	local dist = gBool("Visuals", "Filter", "Distance")
	if(enemy) then
		if(pm.Team(v) == pm.Team(me)) then return false; end
	end
	if(dist) then
		local maxdist = gBool("Visuals", "Filter", "Max Distance");
		if( vm.Distance( em.GetPos(v), em.GetPos(me) ) > (maxdist * 5) ) then return false; end
	end
	return true;
end


local chamsmat = CreateMaterial("a", "VertexLitGeneric", {
	["$ignorez"] = 1,
	["$model"] = 1,
	["$basetexture"] = "models/debug/debugwhite",
});

local chamsmat2 = CreateMaterial("@", "vertexlitgeneric", {
	["$ignorez"] = 0,
	["$model"] = 1,
	["$basetexture"] = "models/debug/debugwhite",
});

local function GetChamsColor(v, vis)
	local pre = "Chams - Enemy";
	if(pm.Team(v) == pm.Team(me)) then
		pre = "Chams - Team";
	end
	if(vis) then
		local r = gInt("Colors", pre, "Visible R") / 255;
		local g = gInt("Colors", pre, "Visible G") / 255;
		local b = gInt("Colors", pre, "Visible B") / 255;
		return r,g,b;
	end
	local r = gInt("Colors", pre, "Not Visible R") / 255;
	local g = gInt("Colors", pre, "Not Visible G") / 255;
	local b = gInt("Colors", pre, "Not Visible B") / 255;
	return r,g,b;
end

local function Chams(v)
	if(gBool("Visuals", "ESP", "XQZ")) then
		cam.Start3D();
			cam.IgnoreZ(true);
			em.DrawModel(v);
			cam.IgnoreZ(false);
		cam.End3D();
	end
	if(gBool("Visuals", "ESP", "Chams")) then
		cam.Start3D();
			
			render.MaterialOverride(chamsmat);
			render.SetColorModulation(GetChamsColor(v));
				
			em.DrawModel(v);
				
			render.SetColorModulation(GetChamsColor(v, true));
			render.MaterialOverride(chamsmat2);
				
			em.DrawModel(v);
			
		cam.End3D();
	end
end

local function GetColor(v)
	if(pm.Team(v) == pm.Team(me)) then
		local r = gInt("Colors", "Box - Team", "R");
		local g = gInt("Colors", "Box - Team", "G");
		local b = gInt("Colors", "Box - Team", "B");
		return(Color(r, g, b, 220));
	end
	local r = gInt("Colors", "Box - Enemy", "R");
	local g = gInt("Colors", "Box - Enemy", "G");
	local b = gInt("Colors", "Box - Enemy", "B");
	return(Color(r, g, b, 220));
end

local function ESP(v)
	local pos = em.GetPos(v);
	local pos, pos2 = vm.ToScreen(pos - Vector(0, 0, 5)), vm.ToScreen( pos + Vector(0, 0, 70 ) );
	local h = pos.y - pos2.y;
	local w = h / 2.2;
	if(gBool("Visuals", "ESP", "Box") && gOption("Visuals", "ESP", "Box Type") == "2D Box") then	
		
		surface.SetDrawColor(GetColor(v));
		surface.DrawOutlinedRect( pos.x - w / 2, pos.y - h, w, h);
		surface.SetDrawColor(0, 0, 0, 220);
		surface.DrawOutlinedRect( pos.x - w / 2 - 1, pos.y - h - 1, w + 2, h + 2);
		surface.DrawOutlinedRect( pos.x - w / 2 + 1, pos.y - h + 1, w - 2, h - 2);
		
	end
	
	if(gBool("Visuals", "ESP", "Health")) then
		local hp = em.Health(v) * h / 100;
		if(hp > h) then hp = h; end
		local diff = h - hp;
		surface.SetDrawColor(0, 0, 0, 255);
		surface.DrawRect(pos.x - w / 2 - 5, pos.y - h - 1, 3, h + 2);
		surface.SetDrawColor( ( 100 - em.Health(v) ) * 2.55, em.Health(v) * 2.55, 0, 255);
		surface.DrawRect(pos.x - w / 2 - 4, pos.y - h + diff, 1, hp);
	end

		
	surface.SetFont("BudgetLabel");
	
	surface.SetTextColor(255, 255, 255);
	
	if(gBool("Visuals", "ESP", "Name")) then
	
		local tw, th = surface.GetTextSize(pm.Name(v));
		
		surface.SetTextPos( pos.x - tw / 2, pos.y - h + 2 - th );
		
		surface.DrawText(pm.Name(v));
		
	end
	
	if(gBool("Visuals", "ESP", "Weapon")) then
		
		local w = pm.GetActiveWeapon(v);
		if(w && em.IsValid(w)) then
			local tw,  th = surface.GetTextSize(em.GetClass(w));
			surface.SetTextPos( pos.x - tw / 2, pos.y - th / 2 + 5 );
			surface.DrawText(em.GetClass(w)); 
		end
		
	end
	
	if(gBool("Visuals", "ESP", "Skeleton")) then
		local origin = em.GetPos(v);
		for i = 1, em.GetBoneCount(v) do
			local parent = em.GetBoneParent(v, i);
			if(!parent) then continue; end
			local bonepos, parentpos = em.GetBonePosition(v, i), em.GetBonePosition(v, parent);
			if(!bonepos || !parentpos || bonepos == origin) then continue; end
			local bs, ps = vm.ToScreen(bonepos), vm.ToScreen(parentpos);
			surface.SetDrawColor(255, 255, 255);
			surface.DrawLine(bs.x, bs.y, ps.x, ps.y);
		end
	end
	
end

local aimtarget;


hook.Add("HUDPaint", "", function()
	if(aimtarget && gBool("Ragebot", "Target", "Snapline")) then
		local pos = vm.ToScreen(em.LocalToWorld(aimtarget, em.OBBCenter(aimtarget)));
		surface.SetDrawColor(255, 255, 255);
		surface.DrawLine(ScrW() / 2, ScrH() / 2, pos.x, pos.y);
	end
	if(!gBool("Visuals", "ESP", "Enabled")) then return; end
	for k,v in next, player.GetAll() do
		if(!em.IsValid(v) || em.Health(v) < 1 || v == me || em.IsDormant(v)) then continue; end
		if(!Filter(v)) then continue; end
		ESP(v);
	end
end);

hook.Add("RenderScreenspaceEffects", "", function()
	if(!gBool("Visuals", "ESP", "Enabled")) then return; end
	for k,v in next, player.GetAll() do
		if(!em.IsValid(v) || em.Health(v) < 1 || v == me || em.IsDormant(v)) then continue; end
		if(!Filter(v)) then continue; end
		Chams(v);
	end
end);

saveconfig();

--[[
memes
]]

local fa;
local aa;

local function FixMovement(ucmd, aaaaa)
	--local move = Vector(cm.GetForwardMove(ucmd), cm.GetSideMove(ucmd), 0);
	--local move = am.Forward( vm.Angle(move) + ( cm.GetViewAngles(ucmd) - fa ) ) * vm.Length(move);
	local move = Vector(cm.GetForwardMove(ucmd), cm.GetSideMove(ucmd), cm.GetUpMove(ucmd));
	local speed = math.sqrt(move.x * move.x + move.y * move.y);
	local ang = vm.Angle(move);
	local yaw = math.rad(cm.GetViewAngles(ucmd).y - fa.y + ang.y);
	cm.SetForwardMove(ucmd, (math.cos(yaw) * speed) * ( aaaaa && -1 || 1 ));
	cm.SetSideMove(ucmd, math.sin(yaw) * speed);
	--cm.SetForwardMove(ucmd, move.x);
	--cm.SetSideMove(ucmd, (aaaaa && move.y * -1 || move.y));
end

local function Clamp(val, min, max)
	if(val < min) then
		return min;
	elseif(val > max) then
		return max;
	end
	return val;
end

local function NormalizeAngle(ang)
	ang.x = math.NormalizeAngle(ang.x);
	ang.p = math.Clamp(ang.p, -89, 89);
end

--[[
aimer
]]

local table = Copy(table);
local dists = {};

local function GetPos(v)

	if(gBool("Ragebot", "Target", "Bodyaim")) then return( em.LocalToWorld(v, em.OBBCenter(v)) ); end

	local eyes = em.LookupAttachment(v, "eyes");
	
	if(!eyes) then return( em.LocalToWorld(v, em.OBBCenter(v)) ); end
	
	local pos = em.GetAttachment(v, eyes);
	
	if(!pos) then return( em.LocalToWorld(v, em.OBBCenter(v)) ); end
	
	return(pos.Pos);
end

local aimignore;

local function Valid(v)
	if(!v || !em.IsValid(v) || v == me || em.Health(v) < 1 || em.IsDormant(v) || pm.Team(v) == 1002 || (v == aimignore && gOption("Ragebot", "Target", "Selection") == "Nextshot")) then return false; end
	if(gBool("Ragebot", "Target", "Ignore Bots")) then
		if(pm.IsBot(v)) then return false; end
	end
	if(gBool("Ragebot", "Target", "Ignore Team")) then
		if(pm.Team(v) == pm.Team(me)) then return false; end
	end
	if(gBool("Ragebot", "Target", "Ignore Friends")) then
		if(pm.GetFriendStatus(v) == "friend") then return false; end
	end
	local tr = {
		start = em.EyePos(me),
		endpos = GetPos(v),
		mask = MASK_SHOT,
		filter = {me, v},
	};
	return(util.TraceLine(tr).Fraction == 1);
end

local function gettarget()

	local opt = gOption("Ragebot", "Target", "Selection");
	
	local sticky = gOption("Ragebot", "Aimbot", "Non-Sticky");
	
	if(opt == "Distance") then

		if( !sticky && Valid(aimtarget) ) then return; end

		dists = {};
		
		for k,v in next, player.GetAll() do
			if(!Valid(v)) then continue; end
			dists[#dists + 1] = { vm.Distance( em.GetPos(v), em.GetPos(me) ), v };
		end
		
		table.sort(dists, function(a, b)
			return(a[1] < b[1]);
		end);
		
		aimtarget = dists[1] && dists[1][2] || nil;
		
	elseif(opt == "Health") then
		
		if( !sticky && Valid(aimtarget) ) then return; end

		dists = {};
		
		for k,v in next, player.GetAll() do
			if(!Valid(v)) then continue; end
			dists[#dists + 1] = { em.Health(v), v };
		end
		
		table.sort(dists, function(a, b)
			return(a[1] < b[1]);
		end);
		
		aimtarget = dists[1] && dists[1][2] || nil;
		
	elseif(opt == "Nextshot") then
		if( !sticky && Valid(aimtarget) ) then return; end
		aimtarget = nil;
		local allplys = player.GetAll();
		local avaib = {};
		for k,v in next,allplys do
			avaib[math.random(100)] = v;
		end
		
		for k,v in next, avaib do
			if(Valid(v)) then
				aimtarget = v;
			end
		end
	end
		
end


local cones = {};

local pcall = pcall;
local require = require;

local nullvec = Vector() * -1;

local IsFirstTimePredicted = IsFirstTimePredicted;
local CurTime = CurTime;
local servertime=0;
local bit = Copy(bit);
pcall(require, "dickwrap");

hook.Add("Move", "", function()
	if(!IsFirstTimePredicted()) then return; end
	servertime = CurTime();
end);


GAMEMODE["EntityFireBullets"] = function(self, p, data)
	aimignore = aimtarget;
	local w = pm.GetActiveWeapon(me);
	local Spread = data.Spread * -1;
	if(!w || !em.IsValid(w) || cones[em.GetClass(w)] == Spread || Spread == nullvec) then return; end
	cones[em.GetClass(w)] = Spread;
end

local function PredictSpread(ucmd, ang)
	local w = pm.GetActiveWeapon(me);
	if(!w || !em.IsValid(w) || !cones[em.GetClass(w)] || !gBool("Ragebot", "Accuracy", "Anti Spread")) then return am.Forward(ang); end
	return(dickwrap.Predict(ucmd, am.Forward(ang), cones[em.GetClass(w)]));
end

local function Autofire(ucmd)
	if(pm.KeyDown(me, 1) && gBool("Ragebot", "Aimbot", "Auto Pistol")) then
		cm.SetButtons(ucmd, bit.band( cm.GetButtons(ucmd), bit.bnot( 1 ) ) );
	else
		cm.SetButtons(ucmd, bit.bor( cm.GetButtons(ucmd), 1 ) );
	end
end

local function WeaponCanFire()
	local w = pm.GetActiveWeapon(me);
	if(!w || !em.IsValid(w) || !gBool("Ragebot", "Aimbot", "Bullettime")) then return true; end
	return( servertime >= wm.GetNextPrimaryFire(w) );
end

local function WeaponShootable()
    local wep = pm.GetActiveWeapon(me);
    if( em.IsValid(wep) ) then // I would never get lazy..
	     local n = string.lower(wep:GetPrintName())
	     if( wep:Clip1() <= 0 ) then
		    return false;
		 end
		 
		 
		 
		 if( string.find(n,"knife") or string.find(n,"grenade") or string.find(n,"sword") or string.find(n,"bomb") or string.find(n,"ied") or string.find(n,"c4") or string.find(n,"slam") or string.find(n,"climb") or string.find(n,"hand") or string.find(n,"fist") ) then
		    return false;
		 end
		  
		  
		  return true;
	end
end

local function PredictPos(pos)
local myvel = LocalPlayer():GetVelocity()
local pos = pos - (myvel * engine.TickInterval()); 
return pos;
end


local function aimer(ucmd)
	if(cm.CommandNumber(ucmd) == 0 || !gBool("Ragebot", "Aimbot", "Enabled")) then return; end
	gettarget();
	aa = false;
	if(aimtarget && (input.IsKeyDown(KEY_LALT) || gBool("Ragebot", "Aimbot", "Autosnap")) && WeaponCanFire() && WeaponShootable() ) then
		aa = true;
		local pos = GetPos(aimtarget) - em.EyePos(me);
		PredictPos(pos);
		local ang = vm.Angle( PredictSpread(ucmd, vm.Angle(pos)));
		NormalizeAngle(ang);
		cm.SetViewAngles(ucmd, ang);
		if(gBool("Ragebot", "Aimbot", "Autofire")) then
			Autofire(ucmd);
		end
		if(gBool("Ragebot", "Aimbot", "Silent")) then
			FixMovement(ucmd);
		else
			fa = ang;
		end
	end
end

--[[
antiaimer
]]



local ox=-181;
local oy=0;

local function RandCoin()
	local randcoin = math.random(0,1);
	if(randcoin == 1) then return 1; else return -1; end
end

local function GetX()
	local opt = gOption("Ragebot", "Anti-Aim", "X");
	if(opt == "Emotion") then
		local randcoin = gInt("Ragebot", "Anti-Aim", "Emotion Randomcoin X");
		if( math.random(100) < randcoin ) then
			ox = RandCoin() * 181;
		end
	elseif( opt == "Up" ) then
		ox = -181;
	elseif( opt == "Down" ) then
		ox = 181;
	elseif(opt == "Jitter") then
		ox = ox * -1;
	end
end

local function GetClosest()
	local ddists = {};
	
	local closest;
		
	for k,v in next, player.GetAll() do
	if(!Valid(v)) then continue; end
		ddists[#ddists + 1] = { vm.Distance( em.GetPos(v), em.GetPos(me) ), v };
	end
		
	table.sort(ddists, function(a, b)
		return(a[1] < b[1]);
	end);
		
	closest = ddists[1] && ddists[1][2] || nil;
	
	if(!closest) then return fa.y; end
	
	local pos = em.GetPos(closest);
	
	local pos = vm.Angle(pos - em.EyePos(me));
	
	return( pos.y );
end

local function GetY()
	local opt = gOption("Ragebot", "Anti-Aim", "Y");
	if(opt == "Emotion") then
		local randcoin = gInt("Ragebot", "Anti-Aim", "Emotion Randomcoin Y");
		if( math.random(100) < randcoin ) then
			oy = fa.y + math.random(-180, 180);
		end
	elseif( opt == "Eye Angles" ) then
		oy = fa.y;
	elseif( opt == "Sideways" ) then
		oy = fa.y - 90;
	elseif(opt == "Jitter") then
		oy = fa.y + math.random(-90, 90);
	elseif(opt == "TJitter") then
		oy = fa.y - 180 + math.random(-90, 90);
	elseif(opt == "Static") then
		oy = 0;
	elseif(opt == "Forward") then
		oy = fa.y;
	elseif(opt == "Backwards") then
		oy = fa.y - 180;
	elseif(opt == "Towards Players") then
		oy = GetClosest();
	end
end

local function walldetect()
	local eye = em.EyePos(me);
	local tr = util.TraceLine({
		start = eye,
		endpos = (eye + (am.Forward(fa) * 10)),
		mask = MASK_ALL,
	});
	if(tr.Hit) then
		ox = -181;
		oy = -90;
	end
end

local function antiaimer(ucmd)
	if( (cm.CommandNumber(ucmd) == 0 && !gBool("Visuals", "Misc", "Thirdperson")) || cm.KeyDown(ucmd, 1) || cm.KeyDown(ucmd, 32) || aa || !gBool("Ragebot", "Anti-Aim", "Enabled")) then return; end
	GetX();
	GetY();
	walldetect();
	local aaang = Angle(ox, oy, 0);
	cm.SetViewAngles(ucmd, aaang);
	FixMovement(ucmd, true);
end

local function GetAngle(ang)
	if(!gBool("Ragebot", "Accuracy", "Anti Recoil")) then return ang + pm.GetPunchAngle(me); end
	return ang;
end

local function rapidfire(ucmd)
	if(pm.KeyDown(me, 1) && gBool("Ragebot", "Aimbot", "Auto Pistol")) then
		cm.SetButtons(ucmd, bit.band( cm.GetButtons(ucmd), bit.bnot( 1 ) ) );
	end
end

local function meme(ucmd)
	if(!fa) then fa = cm.GetViewAngles(ucmd); end
	fa = fa + Angle(cm.GetMouseY(ucmd) * .023, cm.GetMouseX(ucmd) * -.023, 0);
	NormalizeAngle(fa);
	if(cm.CommandNumber(ucmd) == 0) then
		cm.SetViewAngles(ucmd, GetAngle(fa));
		return;
	end
	if(cm.KeyDown(ucmd, 1)) then
		local ang = GetAngle(vm.Angle( PredictSpread(ucmd, fa ) ) );
		NormalizeAngle(ang);
		cm.SetViewAngles(ucmd, ang);
	end
	if(cm.KeyDown(ucmd, 2) && !em.IsOnGround(me)) then
		cm.SetButtons(ucmd, bit.band( cm.GetButtons(ucmd), bit.bnot( 2 ) ) );
	end
end


hook.Add("CreateMove", "", function(ucmd)
	meme(ucmd);
	aimer(ucmd);
	antiaimer(ucmd);
end);

hook.Add("CalcView", "", function(p, o, a, f)
	return({
		angles = GetAngle(fa),
		origin = (gBool("Visuals", "Misc", "Thirdperson") && o + am.Forward(fa) * -150 || o),
		fov = f,
	});
end);

hook.Add("ShouldDrawLocalPlayer", "", function()
	return(gBool("Visuals", "Misc", "Thirdperson"));
end);

-- vk.com/urbanichka