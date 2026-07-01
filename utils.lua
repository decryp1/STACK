local utils = {}
function utils.createstackfiles()
	isfolder = isfolder or is_folder or checkfolder or check_folder or nil;
	makefolder = makefolder or make_folder or folder or nil;
	writefile = writefile or write_file or nil;
	if not isfolder("STACK/globals") then
		makefolder("STACK/globals");
		writefile("STACK/globals/executions.txt", "1");
		writefile("STACK/globals/invited.txt", "false");
	end
    if not isfolder("STACK/images") then
        makefolder("STACK/images");
	end

end

function utils.ensureimages()
    if not isfolder("STACK") or not isfolder("STACK/globals") or not isfolder("STACK/images") then
        utils.createstackfiles()
    end
    if #listfiles("STACK/images") > 0 then
        for i, v in listfiles("STACK/images") do
            if not string.find(tostring(getcustomasset(v)), 'rbxasset') then
                local name = v:match("([^/\\]+)$")
                --print(v, name)
                writefile(v, game:HttpGet("https://raw.githubusercontent.com/decryp1/STACK/main/images/", v))
            end
        end
    else
        writefile("STACK/images/stacklogo.png", game:HttpGet("https://raw.githubusercontent.com/decryp1/STACK/main/images/stacklogo.png"));
        writefile("STACK/images/stackA.png", game:HttpGet("https://raw.githubusercontent.com/decryp1/STACK/main/images/stackA.png"));
        writefile("STACK/images/stackAcollapsed.png", game:HttpGet("https://raw.githubusercontent.com/decryp1/STACK/main/images/stackAcollapsed.png"));
    end
end


function utils.getobsidian()
	local icon, iconholder
	for i,v in game:WaitForChild("CoreGui"):GetDescendants() do
		if v:IsA("ImageButton") and v.Image:lower():find("stack") then
			icon = v;
			iconholder = v.Parent;
		end
	end
	return icon, iconholder;
end

function utils.addexecution()
	local num=tonumber(readfile("STACK/globals/executions.txt"))
	if num and num < 0 then
        num = num * 1
    elseif num and num >= 0 then
		writefile("STACK/globals/executions.txt",tostring(num + 1))
	elseif not num then
        utils.createstackfiles()
    end
end

function utils.getdevice()
	local const gui = game:GetService("GuiService")
	local const uip = game:GetService("UserInputService")
	if gui:IsTenFootInterface() then
		return "xbox"
	elseif uip.KeyboardEnabled and uip.MouseEnabled then
		return "pc"
	elseif uip.TouchEnabled then
		return "mobile"
	end
end

function utils.invitetodiscord()
	if readfile("STACK/globals/invited.txt") == ("false" or nil) then
		setclipboard("https://discord.gg/js4xbKc3t")
		--[[request({
			Url = "http://127.0.0.1:6463/rpc?v=1", Method = "POST",
			Headers = {["Content-Type"] = "application/json", ["Origin"] = "https://discord.com"},
			Body = game:GetService("HttpService"):JSONEncode({cmd = "INVITE_BROWSER", args = {code = "js4xbKc3t"}, nonce = game:GetService("HttpService"):GenerateGUID(false)})
		})]]
		writefile("STACK/globals/invited.txt", "true")
	end
end

function utils.getglobals(which: string): string
	return which == "executions" and readfile("STACK/globals/executions.txt") or readfile("STACK/globals/invited.txt")
end

function utils.removestackfiles(shouldwipeconfigs: boolean)
	for i,v in listfiles("") do
		if tostring(v):lower():find("stack") then
			if shouldwipeconfigs then
				if isfolder(v) then
					delfolder(v)
				elseif isfile(v) then
					delfile(v)
				end
				print("wiped configs")
			end 
			if tostring(v) == "STACK/globals" and isfolder(v) then
				print("removed STACK/globals")
				delfolder(v)
			end
		end
	end
end

--[[function utils.hook(oldref: string, tohook: function, isCnative: boolean, printvarargs: boolean, toreturn: any)
	if not oldref then oldref = o; end
	if not tohook then return end;
	if isCnative then newfunc = newcclosure(function(...)) else newfunc = function(...) end
	local oldref; oldref = hookfunction(tohook, newfunc
		local args = ...
		local packedargs = table.pack(args)
		if printvarargs then
			print(args)
		end
		return toreturn or oldref(args);
	end)
]]
return utils
--[[print(getglobals("executions"), getglobals("invited"))
utils.invitetodiscord()
utils.addexecution()
utils.removestackfiles(false)
]]
