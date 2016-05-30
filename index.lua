
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
