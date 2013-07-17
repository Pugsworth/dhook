--[[

  						dhook

		Small wrapper library for easy developing with hooks

		by Pugsworth under GPLv2

--]]

dhook = dhook or {stored = {}};

local function isvalidhook(name, unique)

	if not dhook.stored[name] or not dhook.stored[name][unique] then
		error("dhook error: hook " .. tostring(name) .. ": " .. tostring(unique) .. " doesn't exist", 2);
	end

end

-- helper function to quickly loop over all hooks and run a function on them
local function loophooks(func)

	for name, tab in pairs(dhook.stored) do
		for unique, extra in pairs(tab) do

			func(name, unique, extra);

		end
	end

end


function dhook.add(name, unique, func)

	if type(unique) ~= "string" then
		error("dhook error: bad argument #2 (string expected, got " .. type(unique) .. ")"); -- TODO: Better error handling
	end

	if type(func) ~= "function" then
		error("dhook error: bad argument #3 (function expected, got " .. type(func) .. ")");
	end

	if not dhook.stored[name] then
		dhook.stored[name] = {};
	end

	hook.Add(name, unique, func);
	dhook.stored[name][unique] = {func = func, enabled = true, inserttime = CurTime()};
	print("dhook: added hook" .. name .. ": " .. unique);

end

function dhook.remove(name, unique)

	if type(unique) ~= "string" then
		error("dhook error: bad argument #2 (string expected, got " .. type(unique) .. ")");
	end

	isvalidhook(name, unique);

	hook.Remove(name, unique);
	dhook.stored[name][unique] = nil;

	-- TODO: remove empty name tables

	print("dhook: removed hook " .. name .. "-" .. unique); 

end

function dhook.disable(name, unique)

	isvalidhook(name, unique);

	if not dhook.stored[name][unique].enabled then return end

	hook.Remove(name, unique);
	dhook.stored[name][unique].enabled = false;
	print("dhook: disabled hook " .. name .. "-" .. unique);

end

function dhook.enable(name, unique)
	
	isvalidhook(name, unique);

	if dhook.stored[name][unique].enabled then return end

	hook.Add(name, unique, dhook.stored[name][unique].func);
	dhook.stored[name][unique].enabled = true;
	print("dhook: enabled hook " .. name .. "-" .. unique);

end

-- 3 functions require the same general code with a different end function call
-- so let's localize the general function and accept that function as an argument
local function performspecific(func, ply, cmd, args, str) -- TODO: better name
	-- purpose:     remove named hooks
	-- arguments:   <name or unique> [unique] [toggleexpression]

	local sname;
	local sunique;
	local btogexp = false;

	if #args == 1 then
		sunique = args[1];

	elseif #args == 2 then
		if args[2] == "1" then
			sunique = args[1];
			btogexp = true;
		else
			sname = args[1];
			sunique = args[2];
		end

	elseif #args == 3 then
		sname = args[1];
		sunique = args[2];
		btogexp = args[3] == "1" and true or false;

	end

	if not sname and sunique then
		loophooks(function(_name, _unique)

			if btogexp then
				if _unique:find(sunique) then
					func(_name, _unique);
				end

			else
				if _unique == sunique then
					func(_name, _unique);
				end
			end

		end);

	else
		func(sname, sunique);
	end

end

local function performlast(func, ply, cmd, args, str) -- TODO: better name, I'm awful at these

	local last = {name = "", unique = "", time = 0};

	loophooks(function(name, unique, extra)

		if extra.inserttime > last.time then -- time counts upwards, so we get the highest one to signify the latest
			last = {name = name, unique = unique, time = extra.inserttime};
		end

	end);

	if last.name ~= "" then
		print("dhook: " .. last.name .. "-" .. last.unique);
		func(last.name, last.unique);
	end

end

-- table for the functions of each state.
-- needed due to each state needing a separeate concommand, but using the same code
local confuncs = {
	--                                  due to how varargs work, you can only forward them at the end of the arguments
	["remove"]      =   function(...)   performspecific(dhook.remove, ...); end,
	["remove_all"]  =   function()      loophooks(dhook.remove); end,
	["remove_last"] =   function(...)   performlast(dhook.remove, ...); end,

	["enable"]      =   function(...)   performspecific(dhook.enable, ...); end,
	["enable_all"]  =   function()      loophooks(dhook.enable); end,
	["enable_last"] =   function(...)   performlast(dhook.enable, ...); end,
	
	["disable"]     =   function(...)   performspecific(dhook.disable, ...); end,
	["disable_all"] =   function()      loophooks(dhook.disable); end,
	["disable_last"]=   function(...)   performlast(dhook.disable, ...); end
};

-- generate the needed console command for each state
for com, func in pairs(confuncs) do

	concommand.Add("dhook_" .. (SERVER and "sv_" or "") .. com, func);

end
