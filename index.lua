local white = Color.new(255,255,255)
local hourlyUrl = "http://astronautlevel2.github.io/Luma3DS/latest.zip"
local stableUrl = "http://astronautlevel2.github.io/Luma3DS/release.zip"
local a9lh_path = "/arm9loaderhax.bin" --max length 38 characters including the first slash. if bigger, the path inside the .bin wont be changed
local zip_path = "/Luma3DS.zip"
local backup_path = a9lh_path..".bak"

 
function readConfig(fileName)
    if (System.doesFileExist(fileName)) then
        local file = io.open(fileName, FREAD)
        a9lh_path = io.read(file, 0, io.size(file))
        backup_path = a9lh_path..".bak"
    end
end

function unicodify(str)
    local new_str = ""
    for i = 1, #str,1 do
        new_str = new_str..string.sub(str,i,i)..string.char(00)
    end
    return new_str
end
 
function path_changer()
    local file = io.open(a9lh_path, FREAD)
    local a9lh_data = io.read(file, 0, io.size(file))
    io.close(file)
    local offset = string.find(a9lh_data, "%"..unicodify("arm9loaderhax.bin"))
    local new_path = unicodify(string.sub(a9lh_path,2,-1))
    if #new_path < 74 then
        for i = 1,74-#new_path,1 do
            new_path = new_path..string.char(00)
        end
        local file = io.open(a9lh_path, FWRITE)
        io.write(file, offset-1, new_path, 74)
        io.close(file)
    end
end

function update(site)
    Screen.refresh()
    Screen.clear(TOP_SCREEN)
    Screen.waitVblankStart()
    Screen.flip()
    if Network.isWifiEnabled() then
        Screen.debugPrint(5,5, "Update path: "..a9lh_path, white, TOP_SCREEN)
        Network.downloadFile(site, zip_path)
        Screen.debugPrint(5,20, "File downloaded!", white, TOP_SCREEN)
        Screen.debugPrint(5,35, "Backing up arm9loaderhax.bin...", white, TOP_SCREEN)
        if (System.doesFileExist(backup_path)) then
            System.deleteFile(backup_path)
        end
        System.renameFile(a9lh_path, backup_path)
        System.extractFromZIP(zip_path, "out/arm9loaderhax.bin", a9lh_path)
        Screen.debugPrint(5,50, "Moving to payload location...", white, TOP_SCREEN)
        System.deleteFile(zip_path)
        Screen.debugPrint(5,65, "Changing path for reboot patch", white, TOP_SCREEN)
        path_changer()
        Screen.debugPrint(5,80, "Done!", white, TOP_SCREEN)
        Screen.debugPrint(5,95, "Press START to go back to HBL/Home menu", white, TOP_SCREEN)
        while true do
            pad = Controls.read()
            if Controls.check(pad,KEY_START) then
                Screen.waitVblankStart()
                Screen.flip()
                System.exit()
            end
        end
        
    else
        Screen.debugPrint(5,5, "WiFi is off! Please turn it on and retry!", white, TOP_SCREEN)
        Screen.debugPrint(5,20, "Press START to go back to HBL/Home menu", white, TOP_SCREEN)
        while true do
            pad = Controls.read()
            if Controls.check(pad,KEY_START) then
                Screen.waitVblankStart()
                Screen.flip()
                System.exit()
            end
        end
    end
end
 
function main()
    Screen.refresh()
    readConfig("/luma/update.cfg")
    Screen.debugPrint(5,5, "Welcome to the Luma3DS updater!", white, TOP_SCREEN)
    Screen.debugPrint(5,20, "Press A to update stable Luma3DS", white, TOP_SCREEN)
    Screen.debugPrint(5,35, "Press X to update unstable Luma3DS", white, TOP_SCREEN)
    Screen.debugPrint(5,50, "Press B to restore a Luma3DS backup", white, TOP_SCREEN)
    Screen.debugPrint(5,65, "Press START to go back to HBL/Home menu", white, TOP_SCREEN)
    Screen.debugPrint(5,140, "Thanks to:", white, TOP_SCREEN)
    Screen.debugPrint(5,155, "astro and ericchu for the builds", white, TOP_SCREEN)
    Screen.debugPrint(5,170, "Aurora Wright for her amazing CFW", white, TOP_SCREEN)
    Screen.debugPrint(5,185, "Rinnegatamante for lpp-3ds", white, TOP_SCREEN)
    Screen.debugPrint(5,200, "Hamcha for the idea", white, TOP_SCREEN)
    Screen.waitVblankStart()
    Screen.flip()
    while true do
        pad = Controls.read()
        if Controls.check(pad,KEY_START) then
            Screen.waitVblankStart()
            Screen.flip()
            System.exit()
        elseif Controls.check(pad,KEY_A) then
            update(stableUrl)
        elseif Controls.check(pad,KEY_X) then
            update(hourlyUrl)
        elseif Controls.check(pad,KEY_B) then
            Screen.refresh()
            Screen.clear(TOP_SCREEN)
            Screen.waitVblankStart()
            Screen.flip()
            if System.doesFileExist(backup_path) then
                Screen.debugPrint(5,5, "Deleting new arm9loaderhax.bin...", white, TOP_SCREEN)
                System.deleteFile(a9lh_path)
                Screen.debugPrint(5,20, "Renaming backup to arm9loaderhax.bin...", white, TOP_SCREEN)
                System.renameFile(backup_path, a9lh_path)
                Screen.debugPrint(5,35, "Press START to go back to HBL/Home menu", white, TOP_SCREEN)
                while true do
                    pad = Controls.read()
                        if Controls.check(pad,KEY_START) then
                            Screen.waitVblankStart()
                            Screen.flip()
                            System.exit()
                    end
                end
            else
                Screen.debugPrint(5,5, "Backup path: "..backup_path, white, TOP_SCREEN)
                Screen.debugPrint(5,20, "Press START to go back to HBL/Home menu", white, TOP_SCREEN)
                while true do
                    pad = Controls.read()
                    if Controls.check(pad,KEY_START) then
                        Screen.waitVblankStart()
                        Screen.flip()
                        System.exit()
                    end
                end
            end
        end
    end
end
 
main()