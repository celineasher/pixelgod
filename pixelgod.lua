-- PIXEL GOD :: cheat menu for Pixel Basketball
-- auto green (perfect release) + auto dribble + optional auto shot

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

local Rules = require(RS.Shared.Hoops.Rules)
local Floor = require(RS.Shared.Hoops.Floor)
local meter = Rules.meter

local existing = LP.PlayerGui:FindFirstChild("PixelGodMenu")
if existing then existing:Destroy() end
if _G.__pixelGod then
	pcall(function() _G.__pixelGod.destroy() end)
end

local state = {
	autoGreen = true,
	autoDribble = true,
	autoShoot = false,
	timing = 0.042,
	visible = true,
}

local C = {
	ink = Color3.fromRGB(8, 11, 18),
	panel = Color3.fromRGB(16, 22, 34),
	row = Color3.fromRGB(22, 30, 46),
	rowOn = Color3.fromRGB(26, 48, 34),
	stroke = Color3.fromRGB(58, 78, 60),
	green = Color3.fromRGB(124, 255, 107),
	greenD = Color3.fromRGB(46, 125, 50),
	gold = Color3.fromRGB(255, 201, 74),
	red = Color3.fromRGB(255, 92, 92),
	text = Color3.fromRGB(226, 240, 220),
	dim = Color3.fromRGB(120, 138, 120),
}

local function new(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props or {}) do
		o[k] = v
	end
	if parent then o.Parent = parent end
	return o
end

local holder = gethui and gethui() or LP.PlayerGui
local gui = new("ScreenGui", {
	Name = "PixelGodMenu",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	DisplayOrder = 1000,
}, holder)

local shadow = new("Frame", {
	Size = UDim2.fromOffset(318, 404),
	Position = UDim2.fromOffset(27, 27),
	BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	BackgroundTransparency = 0.55,
	BorderSizePixel = 0,
	ZIndex = 1,
}, gui)
new("UICorner", { CornerRadius = UDim.new(0, 7) }, shadow)

local panel = new("Frame", {
	Size = UDim2.fromOffset(318, 404),
	Position = UDim2.fromOffset(22, 22),
	BackgroundColor3 = C.panel,
	BorderSizePixel = 0,
	ZIndex = 2,
}, gui)
new("UICorner", { CornerRadius = UDim.new(0, 7) }, panel)
new("UIStroke", { Color = C.stroke, Thickness = 2 }, panel)

local accent = new("Frame", {
	Size = UDim2.new(1, 0, 0, 4),
	BackgroundColor3 = C.green,
	BorderSizePixel = 0,
	ZIndex = 3,
}, panel)
new("UICorner", { CornerRadius = UDim.new(0, 3) }, accent)

local header = new("Frame", {
	Size = UDim2.new(1, 0, 0, 58),
	BackgroundTransparency = 1,
	ZIndex = 4,
}, panel)

local title = new("TextLabel", {
	Text = "PIXEL GOD",
	Font = Enum.Font.Arcade,
	TextSize = 25,
	TextColor3 = C.green,
	TextXAlignment = Enum.TextXAlignment.Left,
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(14, 8),
	Size = UDim2.fromOffset(200, 26),
	ZIndex = 5,
}, header)

local subtitle = new("TextLabel", {
	Text = "TRAINING WHEELS OFF",
	Font = Enum.Font.Code,
	TextSize = 11,
	TextColor3 = C.dim,
	TextXAlignment = Enum.TextXAlignment.Left,
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(15, 34),
	Size = UDim2.fromOffset(220, 14),
	ZIndex = 5,
}, header)

local keyHint = new("TextLabel", {
	Text = "[RShift]",
	Font = Enum.Font.Code,
	TextSize = 11,
	TextColor3 = C.gold,
	TextXAlignment = Enum.TextXAlignment.Right,
	BackgroundTransparency = 1,
	Position = UDim2.new(1, -108, 0, 10),
	Size = UDim2.fromOffset(94, 14),
	ZIndex = 5,
}, header)

local closeBtn = new("TextButton", {
	Text = "X",
	Font = Enum.Font.Arcade,
	TextSize = 14,
	TextColor3 = C.dim,
	BackgroundColor3 = C.row,
	AutoButtonColor = false,
	Position = UDim2.new(1, -30, 0, 10),
	Size = UDim2.fromOffset(20, 20),
	ZIndex = 6,
}, header)
new("UICorner", { CornerRadius = UDim.new(0, 4) }, closeBtn)

local list = new("Frame", {
	Position = UDim2.fromOffset(12, 66),
	Size = UDim2.new(1, -24, 0, 300),
	BackgroundTransparency = 1,
	ZIndex = 4,
}, panel)
new("UIListLayout", {
	Padding = UDim.new(0, 7),
	SortOrder = Enum.SortOrder.LayoutOrder,
}, list)

local function label(text, color, size, font)
	return new("TextLabel", {
		Text = text,
		Font = font or Enum.Font.Arcade,
		TextSize = size or 12,
		TextColor3 = color or C.text,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 16),
		ZIndex = 5,
	})
end

local painters = {}

local sectionA = label("  AIM", C.gold, 11, Enum.Font.Arcade)
sectionA.LayoutOrder = 1
sectionA.Parent = list

local function makeToggle(order, key, name, desc, initial)
	local row = new("TextButton", {
		Text = "",
		AutoButtonColor = false,
		BackgroundColor3 = initial and C.rowOn or C.row,
		Size = UDim2.new(1, 0, 0, 46),
		BorderSizePixel = 0,
		LayoutOrder = order,
		ZIndex = 5,
	})
	new("UICorner", { CornerRadius = UDim.new(0, 5) }, row)
	local stroke = new("UIStroke", { Color = initial and C.greenD or C.stroke, Thickness = 1.5 }, row)

	local n = new("TextLabel", {
		Text = name,
		Font = Enum.Font.Arcade,
		TextSize = 14,
		TextColor3 = initial and C.green or C.text,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(12, 7),
		Size = UDim2.new(1, -90, 0, 18),
		ZIndex = 6,
	}, row)
	local d = new("TextLabel", {
		Text = desc,
		Font = Enum.Font.Code,
		TextSize = 10,
		TextColor3 = C.dim,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(12, 26),
		Size = UDim2.new(1, -90, 0, 12),
		ZIndex = 6,
	}, row)

	local track = new("Frame", {
		Position = UDim2.new(1, -62, 0.5, -10),
		Size = UDim2.fromOffset(48, 20),
		BackgroundColor3 = initial and C.greenD or Color3.fromRGB(40, 50, 66),
		BorderSizePixel = 0,
		ZIndex = 6,
	}, row)
	new("UICorner", { CornerRadius = UDim.new(0, 4) }, track)
	local knob = new("Frame", {
		Size = UDim2.fromOffset(18, 16),
		Position = UDim2.fromOffset(initial and 28 or 2, 2),
		BackgroundColor3 = initial and C.green or C.dim,
		BorderSizePixel = 0,
		ZIndex = 7,
	}, track)
	new("UICorner", { CornerRadius = UDim.new(0, 3) }, knob)

	local function paint()
		local on = state[key]
		row.BackgroundColor3 = on and C.rowOn or C.row
		stroke.Color = on and C.greenD or C.stroke
		n.TextColor3 = on and C.green or C.text
		track.BackgroundColor3 = on and C.greenD or Color3.fromRGB(40, 50, 66)
		knob.BackgroundColor3 = on and C.green or C.dim
		knob.Position = UDim2.fromOffset(on and 28 or 2, 2)
	end

	row.MouseEnter:Connect(function()
		if not state[key] then row.BackgroundColor3 = Color3.fromRGB(28, 37, 55) end
	end)
	row.MouseLeave:Connect(function()
		row.BackgroundColor3 = state[key] and C.rowOn or C.row
	end)
	row.Activated:Connect(function()
		state[key] = not state[key]
		paint()
	end)
	painters[key] = paint
	row.Parent = list
	return row
end

makeToggle(2, "autoGreen", "AUTO GREEN", "perfect meter release", state.autoGreen)
makeToggle(3, "autoDribble", "AUTO DRIBBLE", "crossover on cooldown", state.autoDribble)
makeToggle(4, "autoShoot", "AUTO SHOOT", "pull when open, close range", state.autoShoot)

local sectionB = label("  TIMING", C.gold, 11, Enum.Font.Arcade)
sectionB.LayoutOrder = 5
sectionB.Parent = list

local timingRow = new("Frame", {
	BackgroundColor3 = C.row,
	Size = UDim2.new(1, 0, 0, 38),
	BorderSizePixel = 0,
	LayoutOrder = 6,
	ZIndex = 5,
}, list)
new("UICorner", { CornerRadius = UDim.new(0, 5) }, timingRow)

local timingName = new("TextLabel", {
	Text = "GREEN BIAS",
	Font = Enum.Font.Arcade,
	TextSize = 12,
	TextColor3 = C.text,
	TextXAlignment = Enum.TextXAlignment.Left,
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(12, 11),
	Size = UDim2.fromOffset(110, 16),
	ZIndex = 6,
}, timingRow)
local timingVal = new("TextLabel", {
	Text = string.format("%.3f", state.timing),
	Font = Enum.Font.Code,
	TextSize = 13,
	TextColor3 = C.green,
	BackgroundTransparency = 1,
	Position = UDim2.new(1, -96, 0, 11),
	Size = UDim2.fromOffset(40, 16),
	ZIndex = 6,
}, timingRow)

local function stepBtn(text, x, delta)
	local b = new("TextButton", {
		Text = text,
		Font = Enum.Font.Arcade,
		TextSize = 14,
		TextColor3 = C.text,
		BackgroundColor3 = Color3.fromRGB(34, 44, 62),
		AutoButtonColor = false,
		Position = UDim2.new(1, x, 0.5, -10),
		Size = UDim2.fromOffset(22, 20),
		ZIndex = 6,
	}, timingRow)
	new("UICorner", { CornerRadius = UDim.new(0, 4) }, b)
	b.Activated:Connect(function()
		state.timing = math.clamp(state.timing + delta, 0.015, 0.085)
		timingVal.Text = string.format("%.3f", state.timing)
	end)
	return b
end
stepBtn("-", -86, -0.005)
stepBtn("+", -58, 0.005)

local statusRow = new("Frame", {
	BackgroundColor3 = Color3.fromRGB(12, 17, 26),
	Size = UDim2.new(1, 0, 0, 44),
	BorderSizePixel = 0,
	LayoutOrder = 7,
	ZIndex = 5,
}, list)
new("UICorner", { CornerRadius = UDim.new(0, 5) }, statusRow)
new("UIStroke", { Color = Color3.fromRGB(38, 52, 42), Thickness = 1 }, statusRow)
local statusL1 = new("TextLabel", {
	Text = "BALL: -   GAS: -",
	Font = Enum.Font.Code,
	TextSize = 11,
	TextColor3 = C.text,
	TextXAlignment = Enum.TextXAlignment.Left,
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(10, 7),
	Size = UDim2.fromOffset(270, 13),
	ZIndex = 6,
}, statusRow)
local statusL2 = new("TextLabel", {
	Text = "METER: -   VERDICT: -",
	Font = Enum.Font.Code,
	TextSize = 11,
	TextColor3 = C.dim,
	TextXAlignment = Enum.TextXAlignment.Left,
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(10, 22),
	Size = UDim2.fromOffset(270, 13),
	ZIndex = 6,
}, statusRow)

local killBtn = new("TextButton", {
	Text = "ALL OFF",
	Font = Enum.Font.Arcade,
	TextSize = 12,
	TextColor3 = C.red,
	BackgroundColor3 = Color3.fromRGB(38, 22, 26),
	AutoButtonColor = false,
	Size = UDim2.new(1, 0, 0, 26),
	BorderSizePixel = 0,
	LayoutOrder = 8,
	ZIndex = 5,
}, list)
new("UICorner", { CornerRadius = UDim.new(0, 5) }, killBtn)
new("UIStroke", { Color = Color3.fromRGB(90, 40, 44), Thickness = 1 }, killBtn)

-- drag
local conns = {}
local dragging, dragStart, startPos = false, nil, nil
local function beginDrag(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = panel.Position
	end
end
header.InputBegan:Connect(beginDrag)
accent.InputBegan:Connect(beginDrag)
title.InputBegan:Connect(beginDrag)
subtitle.InputBegan:Connect(beginDrag)
table.insert(conns, UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local d = input.Position - dragStart
		panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		shadow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X + 5, startPos.Y.Scale, startPos.Y.Offset + d.Y + 5)
	end
end))
table.insert(conns, UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end))

-- session discovery
local session
local lastScan = 0
local nextDribble = 0
local nextShoot = 0
local function validSession(s)
	return type(s) == "table"
		and rawget(s, "shotMeter") ~= nil
		and rawget(s, "input") ~= nil
		and rawget(s, "latest") ~= nil
		and s.latest ~= nil
		and s.input.enabled ~= false
end
local function getSession(now)
	if validSession(session) then
		return session
	end
	if now - lastScan < 0.75 then return nil end
	lastScan = now
	local ok, gc = pcall(getgc, true)
	if not ok then return nil end
	for i = 1, #gc do
		local v = gc[i]
		if type(v) == "table" and rawget(v, "shotMeter") ~= nil and rawget(v, "input") ~= nil and rawget(v, "latest") ~= nil then
			local good = pcall(function()
				return v.latest ~= nil and v.input.enabled ~= false
			end)
			if good and validSession(v) then
				if v ~= session then
					nextDribble = 0
					nextShoot = 0
				end
				session = v
				return v
			end
		end
	end
	return nil
end

local function dribblesLeft(s)
	local ok, res = pcall(function()
		return Rules.dribblesLeft(s.predict:shownGas(), s.predict.dribbleMax)
	end)
	return ok and res or 0
end

local nextDribble = 0
local nextShoot = 0
local lastVerdict = "-"
local scanCount = 0

local function tick()
	local now = os.clock()
	local s = getSession(now)
	if s then
		local latest = s.latest
		local lslot = s.localSlot
		local sm = s.shotMeter
		local shot = sm and sm.shot or nil

		if state.autoGreen and shot and shot.released == nil and shot.lift then
			local drop = shot.drop or 0
			local target = shot.lift + (meter.peak - drop - state.timing) * meter.span
			if now >= target - 0.004 then
				pcall(function() s.input:_button("Shoot", false) end)
			end
		end

		if state.autoDribble and latest and latest.holder == lslot and latest.phase == 3 and now >= nextDribble then
			local act = s.actions and s.actions.act
			local shooting = shot and shot.released == nil
			if not act and not shooting and dribblesLeft(s) > 0 then
				pcall(function()
					s.input:_button("Hands", true)
					s.input:_button("Hands", false)
				end)
				nextDribble = now + 0.44 + math.random() * 0.05
			end
		end

		if state.autoShoot and latest and latest.holder == lslot and latest.phase == 3 and now >= nextShoot then
			local shooting = shot and shot.released == nil
			local act = s.actions and s.actions.act
			local open = (latest.contest or 0) == 0 and (latest.heavy or 0) == 0
			if not shooting and not act and open and s.localShown then
				local atk = s:attackOf(lslot) or 1
				local dx = atk * Floor.rimX - s.localShown.x
				local dy = -s.localShown.y
				local dist = math.sqrt(dx * dx + dy * dy)
				if dist <= 6.8 then
					pcall(function() s.input:_button("Shoot", true) end)
					nextShoot = now + 1.1
				end
			end
		end

		if shot and shot.verdict then
			lastVerdict = tostring(shot.verdict)
		end
	end
end

local acc = 0
table.insert(conns, RunService.RenderStepped:Connect(function(dt)
	acc = acc + dt
	-- release timing runs every frame, other ticks throttled
	local ok, err = pcall(tick)
	if not ok then
		-- keep silent, never break the game
	end
	if acc >= 0.12 then
		acc = 0
		scanCount = scanCount + 1
		local s = session
		if s and rawget(s, "latest") then
			local latest = s.latest
			local lslot = s.localSlot
			local gas = "-"
			local okg, g = pcall(function() return Rules.dribblesLeft(s.predict:shownGas(), s.predict.dribbleMax) end)
			if okg then gas = tostring(g) .. "/" .. tostring(s.predict.dribbleMax or Rules.dribble.max) end
			local ball = (latest and latest.holder == lslot) and "YOU" or "AWAY"
			statusL1.Text = string.format("BALL: %s   GAS: %s", ball, gas)
			local mv = "-"
			if s.shotMeter and s.shotMeter.shot and s.shotMeter.shot.value then
				mv = string.format("%.3f", s.shotMeter.shot.value)
			end
			statusL2.Text = string.format("METER: %s   VERDICT: %s", mv, lastVerdict)
		end
	end
end))

local function destroy()
	for _, c in ipairs(conns) do
		pcall(function() c:Disconnect() end)
	end
	table.clear(conns)
	pcall(function() gui:Destroy() end)
	_G.__pixelGod = nil
end

killBtn.Activated:Connect(function()
	state.autoGreen = false
	state.autoDribble = false
	state.autoShoot = false
	for _, paint in pairs(painters) do
		paint()
	end
end)

closeBtn.Activated:Connect(function()
	state.visible = false
	panel.Visible = false
	shadow.Visible = false
end)

table.insert(conns, UIS.InputBegan:Connect(function(input, gp)
	if input.KeyCode == Enum.KeyCode.RightShift then
		state.visible = not state.visible
		panel.Visible = state.visible
		shadow.Visible = state.visible
	end
end))

-- expose for manual control
_G.__pixelGod = {
	state = state,
	destroy = destroy,
	session = function() return getSession(os.clock()) end,
}

return "PIXEL GOD loaded"
