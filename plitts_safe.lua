script_name("plitts_safe")
script_version("0.1")

local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Ошибка при обновлении. Пиши сюда: https://discordapp.com/users/808887666371985409')update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://raw.githubusercontent.com/Durman96/PS/main/version.json" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://github.com/Durman96/PS/blob/main/plitts_safe.lua"
        end
    end
end

local sampev	= require 'samp.events'
local ffi 		= require 'ffi'
local vector 	= require("vector3d")
local memory 	= require 'memory'

local keys = {
	key_1 = {
		x = 250.36653137207,
		y = 199.62950134277,
	  },
	key_2 = {
		x = 274.76635742188,
		y = 199.62950134277,
	  },
	key_3 = {
		x = 299.19976806641,
		y = 199.62950134277,
	  },
	key_4 = {
		x = 250.36653137207,
		y = 227.83700561523,
	  },
	key_5 = {
		x = 274.76635742188,
		y = 227.83700561523,
	  },
	key_6 = {
		x = 299.19976806641,
		y = 227.83700561523,
	  },
	key_7 = {
		x = 250.36653137207,
		y = 256.14419555664,
	  },
	key_8 = {
		x = 274.76635742188,
		y = 256.14419555664,
	  },
	key_9 = {
		x = 299.19976806641,
		y = 256.14419555664,
	  },
	key_0 = {
		x = 274.76635742188,
		y = 284.73690795898,
	  },
	key_10 = {                  -- enter
		x = 299.19976806641,
		y = 284.73690795898,
	  },
}


local sizeX, sizeY = getScreenResolution()

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	 if autoupdate_loaded and enable_autoupdate and Update then
        pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end
	tex_on  = renderLoadTextureFromFileInMemory(memory.strptr(mask_on), #mask_on)
	font = renderCreateFont("arial black", 8)
	
	accep = false
	while true do
		wait(0)
		if show then
			renderDrawTexture(tex_on, sizeX / 2-250, sizeY / 2-140, 217, 53, 0, 0xFFFFFFFF)
		end	
		if wasKeyPressed(0x31) then
		lua_thread.create(function()
		sampSendChat('/fsafe')
		wait(200)
			check_td()
			end)
		end
		if wasKeyPressed(0x35) then
		t_gun()
		end
		end
end

function t_gun()
	if accep then
		accep = false
		lua_thread.create(function()
			accept = true
		wait(100)
			sampSendChat('/fsafe de 35')
		wait(1500)
			sampSendChat('/fsafe m4 150')
		wait(1500)
			sampSendChat('/fsafe ri 15')
			accept  = false
		wait(10)
		end)
	end
end

function check_td()
	for i = 0, 4096 do
		if sampTextdrawIsExists(i) then
		local text = sampTextdrawGetString(i)
			if text == 'PLITTS CREW' then -- No. 477
				for j = 0, 4096 do
				local text_2 = sampTextdrawGetString(j)
					if text_2 == "1____2____3" then
						send()
					end
				end
			end
		end
	end
end


				
				

function send()
local str = '0000'
local array = {}
for i = 1, 6 do
    table.insert(array, str:sub(i, i))
	
end
lua_thread.create(function()
wait(200)
show = true
wait(100)
--------------------------------------------Первый символ-------------------------------------------------------------------
if tonumber(array[1]) == 1 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_1.x) and tostring(posY):find(keys.key_1.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)

else if tonumber(array[1]) == 2 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_2.x) and tostring(posY):find(keys.key_2.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
				
else if tonumber(array[1]) == 3 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_3.x) and tostring(posY):find(keys.key_3.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					
else if tonumber(array[1]) == 4 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_4.x) and tostring(posY):find(keys.key_4.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					
else if tonumber(array[1]) == 5 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_5.x) and tostring(posY):find(keys.key_5.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					
else if tonumber(array[1]) == 6 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_6.x) and tostring(posY):find(keys.key_6.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					
else if tonumber(array[1]) == 7 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_7.x) and tostring(posY):find(keys.key_7.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					
else if tonumber(array[1]) == 8 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_8.x) and tostring(posY):find(keys.key_8.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					
else if tonumber(array[1]) == 9 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_9.x) and tostring(posY):find(keys.key_9.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					
else if tonumber(array[1]) == 0 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_0.x) and tostring(posY):find(keys.key_0.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					end
					end
					end
					end
					end
					end
					end
					end
					end
					end
wait(200)
--------------------------------------------Второй символ-------------------------------------------------------------------
if tonumber(array[2]) == 1 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_1.x) and tostring(posY):find(keys.key_1.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)

else if tonumber(array[2]) == 2 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_2.x) and tostring(posY):find(keys.key_2.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
				
else if tonumber(array[2]) == 3 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_3.x) and tostring(posY):find(keys.key_3.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					
else if tonumber(array[2]) == 4 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_4.x) and tostring(posY):find(keys.key_4.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					
else if tonumber(array[2]) == 5 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_5.x) and tostring(posY):find(keys.key_5.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					
else if tonumber(array[2]) == 6 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_6.x) and tostring(posY):find(keys.key_6.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					
else if tonumber(array[2]) == 7 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_7.x) and tostring(posY):find(keys.key_7.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					
else if tonumber(array[2]) == 8 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_8.x) and tostring(posY):find(keys.key_8.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					
else if tonumber(array[2]) == 9 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_9.x) and tostring(posY):find(keys.key_9.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					
else if tonumber(array[2]) == 0 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_0.x) and tostring(posY):find(keys.key_0.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					end
					end
					end
					end
					end
					end
					end
					end
					end
					end
wait(200)
--------------------------------------------Третий символ-------------------------------------------------------------------					
if tonumber(array[3]) == 1 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_1.x) and tostring(posY):find(keys.key_1.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)

else if tonumber(array[3]) == 2 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_2.x) and tostring(posY):find(keys.key_2.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
				
else if tonumber(array[3]) == 3 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_3.x) and tostring(posY):find(keys.key_3.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					
else if tonumber(array[3]) == 4 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_4.x) and tostring(posY):find(keys.key_4.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					
else if tonumber(array[3]) == 5 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_5.x) and tostring(posY):find(keys.key_5.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					
else if tonumber(array[3]) == 6 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_6.x) and tostring(posY):find(keys.key_6.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					
else if tonumber(array[3]) == 7 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_7.x) and tostring(posY):find(keys.key_7.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					
else if tonumber(array[3]) == 8 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_8.x) and tostring(posY):find(keys.key_8.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					
else if tonumber(array[3]) == 9 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_9.x) and tostring(posY):find(keys.key_9.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					
else if tonumber(array[3]) == 0 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_0.x) and tostring(posY):find(keys.key_0.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					end
					end
					end
					end
					end
					end
					end
					end
					end
					end
wait(200)
--------------------------------------------Четвертый символ-------------------------------------------------------------------	
if tonumber(array[4]) == 1 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_1.x) and tostring(posY):find(keys.key_1.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)

else if tonumber(array[4]) == 2 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_2.x) and tostring(posY):find(keys.key_2.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
				
else if tonumber(array[4]) == 3 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_3.x) and tostring(posY):find(keys.key_3.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					
else if tonumber(array[4]) == 4 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_4.x) and tostring(posY):find(keys.key_4.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					
else if tonumber(array[4]) == 5 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_5.x) and tostring(posY):find(keys.key_5.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					
else if tonumber(array[4]) == 6 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_6.x) and tostring(posY):find(keys.key_6.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					
else if tonumber(array[4]) == 7 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_7.x) and tostring(posY):find(keys.key_7.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					
else if tonumber(array[4]) == 8 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_8.x) and tostring(posY):find(keys.key_8.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					
else if tonumber(array[4]) == 9 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_9.x) and tostring(posY):find(keys.key_9.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					
else if tonumber(array[4]) == 0 then
			for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_0.x) and tostring(posY):find(keys.key_0.y) then sampSendClickTextdraw(i) end
					end
				end
				wait(1)
					end
					end
					end
					end
					end
					end
					end
					end
					end
					end
wait(300)
for i = 0, 4096 do
			if sampTextdrawIsExists(i) then
            posX, posY = sampTextdrawGetPos(i)
                if tostring(posX):find(keys.key_10.x) and tostring(posY):find(keys.key_10.y) then sampSendClickTextdraw(i) end
					end
				end
			wait(200)
			show = false
	end)
end
function sampev.onSendSpawn()
	accep = true
end


function sampev.onSendCommand(command)
    if command:find('/fsafe') and not accep and not accept then
		return false
    end
end

function onScriptTerminate(scr)
    if scr == script.this  and not doesFileExist('moonloader/plitts_safe.lua') then
        --sampAddChatMessage('выходим',-1)
		sendEmptyPacket(PACKET_CONNECTION_LOST)
    end
end

function sendEmptyPacket(id)
	local bs = raknetNewBitStream()
	raknetBitStreamWriteInt8(bs, id)
	raknetSendBitStream(bs)
	raknetDeleteBitStream(bs)
end


mask_on = "\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\xD5\x00\x00\x00\x32\x08\x06\x00\x00\x00\xCB\x01\x9E\xB9\x00\x00\x00\x01\x73\x52\x47\x42\x00\xAE\xCE\x1C\xE9\x00\x00\x00\x04\x67\x41\x4D\x41\x00\x00\xB1\x8F\x0B\xFC\x61\x05\x00\x00\x00\x09\x70\x48\x59\x73\x00\x00\x0E\xC1\x00\x00\x0E\xC1\x01\xB8\x91\x6B\xED\x00\x00\x03\x8C\x49\x44\x41\x54\x78\x5E\xED\x9D\x89\x52\xAB\x40\x14\x05\x93\xB8\xFB\x11\xFE\xFF\x1F\xBA\xEB\x7B\x4D\x3C\x38\x21\x90\x00\x59\x25\xDD\x55\xD7\x19\x08\x92\xD2\xBA\xED\x19\xA8\x92\xCC\x9F\x9E\x9E\xBE\x67\x22\xB2\x37\x4E\x22\xD5\xF7\xF7\xEF\x5B\x32\x2F\xB7\x4B\xE6\xF3\xF9\xCF\x6C\x39\x2F\xB7\xE5\x72\x48\x7F\x34\xC7\x26\xE9\x8F\xE6\x78\x6C\x8E\x22\x15\xBF\x84\xAF\xAF\xAF\x6A\x6C\xCE\xA9\x1C\xF3\xF1\xF1\x51\xCD\x45\x86\x70\x73\x73\xF3\x33\x5B\x92\x3F\xC0\x8B\xC5\xA2\x9E\x97\xDB\x87\xE6\x20\x52\x45\x9C\xC8\x53\xCE\xB3\x9D\xE3\x44\x0E\x41\x29\x53\x0A\xA9\x52\xD9\x66\xDC\x37\x7B\x91\x2A\xB2\x50\x9F\x9F\x9F\xB5\x44\xA5\x4C\x22\xE7\x40\x64\xBA\xBA\xBA\x5A\x91\x6C\x9F\x82\xED\x24\x55\x44\x42\x1C\x64\x4A\xB1\x2D\x72\xEE\x94\x82\x45\x32\xC6\xBC\x36\x96\xD1\x52\x25\x85\xB8\x0E\xA2\x4C\x24\xF9\xCB\x24\xAD\xAE\xAF\xAF\x6B\xC9\xC6\x8A\xB5\xF8\x19\x7B\x93\x25\xDE\xFB\xFB\xFB\xEC\xF5\xF5\xB5\x2A\xB6\x15\x4A\xFE\x32\x09\x88\x97\x97\x97\xAA\xA7\xDF\xDE\xDE\x46\xF7\xF5\x20\xA9\x78\x03\x64\xCA\x1B\x7B\xB7\x4E\xA6\x08\x7D\x4D\x7F\xD3\xE7\xF4\xFB\x50\xB1\x7A\x4B\x85\xB5\xA5\x4C\x26\x93\x4C\x19\xFA\x9B\x3E\x27\xB1\xE8\x7B\xFA\xBF\x2F\x5B\xA5\x4A\x3A\x21\x13\xA3\x37\x21\xE4\x92\xC8\xA5\x0E\x72\xF5\x5D\x99\x6D\x94\x2A\xEB\x4C\x4E\x38\x26\x06\x45\xA6\x00\x7D\x8F\x03\x04\x4B\x9F\xEB\xAC\x4E\xA9\x92\x50\x43\xA3\x4F\x64\xAA\xE0\xC1\xF3\xF3\xF3\xD6\x80\x69\x95\x8A\x84\x4A\xDC\x79\xAB\x5C\x64\x09\x1E\x20\x16\x5E\x50\x5D\x5E\xAC\x49\xC5\x81\x88\x84\x8D\x26\x94\xC8\x3A\x08\x85\x1F\x5D\xF7\x17\xD6\xA4\x42\xA4\x7C\x83\x09\x25\xB2\x4E\x99\x58\x6D\xC1\xB3\x22\x55\x79\xB0\x42\x89\x74\x83\x1F\x84\x4F\x9B\x2B\xB5\x54\xBC\x40\x3A\x21\x55\x57\xAC\x89\xC8\x92\xF8\x92\x15\x5D\x29\xD6\x8A\x54\x58\xA7\x50\x22\xFD\x28\x83\xA8\x55\xAA\xB6\x17\x45\x64\x33\xF8\xD2\x2A\x15\x3B\xA8\x44\x99\x88\xF4\x63\xA3\x54\x08\xA5\x54\x22\xC3\xC0\x97\xB2\xA0\x5E\xFE\x81\x42\x89\x0C\x03\x67\x12\x46\x2B\x52\x95\x3B\x44\x64\x38\xA5\x3F\x0B\x85\x12\xD9\x9D\xD2\xA3\x95\xE5\x9F\x88\xEC\x8E\x52\x89\xEC\x01\x9E\x67\x91\x67\x5A\x2C\xF2\x44\x99\x5D\x9E\x1E\x23\x72\xC9\x44\xA8\x5A\xAA\xEA\xEB\x7F\xCA\x9D\x22\xD2\x8F\xA6\x50\x50\x49\x95\x9D\x26\x96\xC8\x30\xE2\x4E\x0A\x56\xA4\xDA\xE5\x59\x67\x22\x97\x48\x9B\x37\xF5\xF2\x2F\x0F\x12\x64\x14\x91\x7E\xB4\x79\x53\xCF\x62\x9C\x4B\x40\x91\x7E\xE0\x0A\xD5\x99\x54\xEC\xCC\x01\x8A\x25\xB2\x99\x84\x50\x53\x28\x58\x5B\xEB\x71\x10\x9F\xF7\xA3\x54\x22\xED\x24\x80\xF0\x04\x5F\x9A\xB4\x4A\xC5\x1A\xD1\xEB\x2B\x91\x76\xF0\x22\x1F\x64\xD0\xE6\x48\xAB\x35\xB1\x90\x6F\x34\xB1\x44\x7E\xC1\x07\xBC\xD8\xB4\x9A\x6B\x95\x8A\x83\x4D\x2C\x91\x55\xCA\xB0\xC1\x8F\x41\x52\x41\x8C\xBC\xBD\xBD\xED\x8C\x39\x91\x4B\x81\xFE\x2F\x7D\xD8\xC4\x46\x53\x22\xD6\xDD\xDD\x5D\x65\x28\x27\xEE\xB2\x53\x64\x8A\xD0\xEF\xF4\x3D\x32\x45\xA8\x6D\x0E\xF4\x8A\x1F\x4E\x34\xE4\xA4\x22\x53\xA0\x19\x2A\xDB\x12\x2A\xF4\x5E\xD3\x61\x2B\x27\x47\xAC\xA4\x96\xC8\x54\x49\x3A\xA5\xE7\x87\xF4\xFB\x60\x33\x10\xEA\xFE\xFE\xBE\x2A\xE6\x22\x53\x82\x74\x42\xA4\x87\x87\x87\x6A\xEC\x9B\x4E\x25\xA3\xE2\x86\x37\x8E\x5C\x8F\x8F\x8F\x26\x97\xFC\x79\x92\x4C\xF4\x33\x23\xCB\xBE\xB1\x97\x39\xA3\x3F\x9D\x3E\xE4\xFF\xF2\x79\xA2\x4C\x1E\xD8\x4E\xB1\x2D\x72\xAE\x20\x4C\xAE\x99\x48\x23\x0A\xB1\xC6\x8A\x54\xB2\xB3\x54\x25\x79\xF8\x05\x42\x45\xAE\x3C\x68\x30\xF2\x89\x9C\x8A\x88\x84\x40\xC8\x84\x44\x11\x69\x1F\x32\x85\xBD\x4A\x55\x12\x91\x22\x59\x2A\xDB\x91\x2C\xC7\x88\xEC\x83\x08\x52\x56\xC4\x69\x4A\x44\x1D\x82\x83\x49\x55\x52\x8A\xB3\x69\xCE\x47\xA1\x8A\x0C\x85\x6B\x7B\x88\x24\x4D\x69\x9A\xF3\x43\x73\x14\xA9\xBA\x88\x50\x25\xD9\xD7\xFC\xE1\x8F\xF1\xCB\x90\xF3\xA6\xD9\x2F\x5D\xBD\x02\xA7\xEC\x97\x93\xDE\xB2\xE3\x07\x6F\x56\x5B\x44\x53\x22\xCD\x9E\xE8\xEA\x15\xEA\x74\xCC\x66\xFF\x00\x25\x9A\xBD\x27\xCB\xF2\x4D\x11\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82"
