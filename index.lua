--StarUpdater by astronautlevel (Alex Taber) and TurtleP
--This project is copyright 2016
--Licensed under MIT license

local Colors =
{
	white = Color.new(209, 213, 216, 255),
	green = Color.new(65, 168, 95, 255),
	red = Color.new(184, 49, 47, 255),
	blue = Color.new(97, 202, 187, 255),
	black = Color.new(117, 112, 107, 186),
	darkBlue = Color.new(41, 105, 176, 255),
	darkGreen = Color.new(25, 53, 49, 255)
}

local background = Graphics.loadImage("/assets/background.png")
local modeFont = Font.load("/assets/HeyGorgeous.ttf")
local updateFont = Font.load("/assets/HeyGorgeous.ttf")
Font.setPixelSizes(updateFont, 18)
Font.setPixelSizes(updateFont, 12)

local isDev = false
local isMenuhax = false
local isStable = true

local lumaUpdaterText =
{
	status = "No update is available",
	color = Colors.red
}

local lumaVersion = "Luma3DS "

local function keyIsDown(button)
	return Controls.check(Controls.read(), button)
end

local getLumaVersion()
	if System.doesFileExist("/arm9loaderhax.bin") then
		local file = io.open("/arm9loaderhax.bin", FREAD)

		local info = file:read(0, file:size())

		file:close()

		if info:find("Developer") then
			isDeveloper = true
		end
		
		


function toUnicode(str)
	local newString = ""
	for i=1,#str,1 do
		newString = newString.sub(str,i,i)..string.char(00)
	end
	return newString
end

function pathChanger()
	local file = io.open(payloadPath, FREAD)
	local fileData = io.read(file, 0, io.size(file))
	io.close(file)
	local offset = string.find(fileData, "%"..toUnicode("arm9loaderhax.bin"))
	local newPath = toUnicode(payloadPath:sub(2,-1))
	if #newPath < 74 then
		for i = 1,74-#newPath,1 do
			newPath = newPath..string.char(00)
		end
		local file = io.open(payloadPath, FWRITE)
		io.write(file, offset-1, newPath, 74)
		io.close(file)
	end
end

function update(url, menuhax)
	local zipPath = "/Luma3DS.zip"
	Screen.clear(TOP_SCREEN)
	Screen.waitVblankStar()
	Screen.flip()
	if not Network.isWifiEnabled() then
		System.exit()
	else
		Network.downloadFile(url, zipPath)
		if not menuhax then
			System.extractFromZIP(zipPath, "out/arm9loaderhax.bin", payloadPath)
			System.deleteFile(zipPath)
			pathChanger()
		else
			System.extractFromZIP(zipPath, "out/Luma3DS.dat", "/Luma3DS.dat")
			System.deleteFile(zipPath)
		System.reboot()
	end
end
