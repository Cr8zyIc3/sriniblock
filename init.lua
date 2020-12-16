--[[
Copyright 2020 Samarth Ramesh & wsor4035 & JustJay

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

local storage = minetest.get_mod_storage()
minetest.deserialize(storage:get_string("blocked_names"))
blocked_names=minetest.deserialize(storage:get_string("blocked_names")) or {"sex","fuck","damn","drug","suicid","lover","shit","idiot","butt","penis"}

print("[sriniblock] loaded")
minetest.register_on_prejoinplayer(function(name)
    for k,v in pairs(blocked_names) do
        if string.find(string.lower(name),string.lower(v)) then
            --logging
            print("[sriniblock] user: " .. name .. " Attempted to join with DISALLOWED WORD: " .. v)
            return "Your UserName Contains: " .. v .. " - and is NOT ALLOWED here, please come back with a Kid Friendly and positive UserName we can call you."
        end
    end
end)

minetest.register_chatcommand("add_name", {
    params = "<string>",
    privs = {server= true},
    description = "Adds a username to blocklist\nCAUTION adding a single letter can be catastrophic. Always be careful when adding characters for username blocking.",
    func = function(name,param)
        if param ~= "" then
            table.insert(blocked_names,tostring(param))
            print(tostring(param))
            minetest.chat_send_all("added "..param.." to the list of blocked username words")
            local serial_table = minetest.serialize(blocked_names)
            storage:set_string("blocked_names", serial_table)    
        
        else 
            minetest.chat_send_player(name, "Captain Useless, tells us that expecting to add a new blocked word without specifying it is senseless")
        end
    
    end
})

minetest.register_chatcommand("list_names", {
    description = "lists all the blocked usernames",
    privs = {server= true},
    func= function(name)
       for k,v in pairs(blocked_names) do
            minetest.chat_send_player(name, blocked_names[k])
       end
    end
})

minetest.register_chatcommand("rm_name",{
    description = "removes a username from the block list",
    params = "<name>",
    privs = {server=true},
    func = function(name, param)
        if param ~="" then    
            for k in pairs(blocked_names) do
                if param == blocked_names[k] then
                    table.remove(blocked_names,k)
                end   
            end
            storage:set_string("blocked_names", minetest.serialize(blocked_names))
        end
    end

})
