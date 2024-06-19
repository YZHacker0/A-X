(function()
	if type(explorer) == 'table' then return end;
	local file = io.open(gg.EXT_FILES_DIR..'/Il2CppExplorer.lua', 'r')
	if file == nil then
		res = gg.makeRequest("https://github.com/HTCheater/Il2CppExplorer/releases/latest/download/Il2CppExplorer.lua")
		if res.code ~= 200 then return os.exit() end;
		file = io.open(gg.EXT_FILES_DIR .. '/Il2CppExplorer.lua', 'w')
        file:write(res.content)
	end
	file:close()
	
	loadfile(gg.EXT_FILES_DIR.."/Il2CppExplorer.lua")()
end)()

--[[
	Better Il2CppExplorer by YZHacker0
	Il2CppExplorer by HTCheater
]]

local function field(parent, offset, vtype)
	local this = {};
	function this:Read()
		return explorer.readValue(parent.address + offset, vtype);
	end
	function this:Write(value)
		this.oldValue = this:Read()
		local j = {}
		j.address = parent.address + offset;
		j.flags  = vtype;
		j.value = value;
		gg.setValues({j})
	end
	function this:Revert()
		if this.oldValue ~= nil then
			local j = {}
		j.address = parent.address + offset;
		j.flags  = vtype;
		j.value = this.oldValue;
		this.oldValue = nil;
		gg.setValues({j})
		end
	end
	return this;
end


local function method(parent, name)
	local this = {};
	this.address = explorer.getFunction(parent, name);
	function this:Edit(value)
		explorer.editFunction(parent,name,value,value)
	end
	return this;
end

local function class(name)
	local this = {};
	this.instances = explorer.getInstances(name);
	function this:Instance(index)
		if #this.instances > 0 then 
			return {}
		end
		return index and this.instances[index] or this.instances;
	end
	function this:Update()
		this.instances = explorer.getInstances(name);
	end
	return this;
end