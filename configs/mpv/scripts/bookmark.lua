--bookmark light version
--record your playing history for each folder
--and you can choose resume to play next time
local mp = require 'mp'
local utils = require 'mp.utils'
local options = require 'mp.options'

local M = {}

local o = {
    save_period = 30
}
options.read_options(o)

local cwd_root = utils.getcwd()

local pl_root
local pl_name
local pl_path
local pl_percent
local pl_list = {}

local pl_idx = 1
local c_idx = 1

local mk_name = ".mpv.bookmark"
local mk_path

local wait_msg

function M.show(msg, mllion)
    mp.commandv("show-text", msg, mllion)
end

function M.compare(s1, s2)
    local l1 = #s1
    local l2 = #s2
    local len = l2
    if l1 < l2 then
        local len = l1
    end
    for i = 1, len do
        if s1:sub(i,i) < s2:sub(i,i) then
            return -1, i-1
        elseif s1:sub(i,i) > s2:sub(i,i) then
            return 1, i-1
        end
    end
    return 0, len
end

function M.get_file_num(idx)
    if idx > #pl_list then
        return ""
    end
    local onm = pl_list[idx]:match("/([^/]+)$")
    local k = 1
    if(idx > 1) then
        local name = pl_list[idx-1]:match("/([^/]+)$")
        local _, tk = M.compare(onm, name)
        if k < tk then
            k = tk
        end
    end
    if(idx < #pl_list) then
        local name = pl_list[idx+1]:match("/([^/]+)$")
        local _, tk = M.compare(onm, name)
        if k < tk then
            k = tk
        end
    end
    while k > 1 do
        if onm:match("^[0-9]+", k-1) == nil then
            break
        end
        k = k - 1
    end
    return  onm:match("[0-9]+", k) or ""
end

function M.ld_mark()
    local file = io.open(mk_path, "r")
    if file == nil then
        print("can not open bookmark file")
        return false
    end
    pl_name = file:read()
    if pl_name == nil then
        print("can not get file's name of last play")
        file:close()
        return false
    else
        pl_path = pl_root.."/"..pl_name
    end
    pl_percent = file:read("*n")
    if pl_percent == nil then
        print("can not get play percent of last play")
        file:close()
        return false
    end
    if(pl_percent >= 100) then
        pl_percent = 99
    end
    print("last paly:\n", pl_name, "\n", pl_percent, "%")
    file:close()
    return true
end

function M.save_mark()
    local name = mp.get_property("filename")
    local percent = mp.get_property("percent-pos", 0)
    if not(name == nil or percent == 0) then
        local file = io.open(mk_path, "w")
        file:write(name.."\n")
        file:write(percent)
        file:close()
    end
end

function M.pause(name, paused)
    if paused then
        M.save_period_timer:stop()
        M.save_mark()
    else
        M.save_period_timer:resume()
    end
end

local timeout = 15 
function M.wait_jump()
    timeout = timeout - 1
    if(timeout < 1) then
        M.wait_jump_timer:kill()
        M.unbind_key()
    end
    local msg = ""
    if timeout < 10 then
        msg = "0"
    end
    msg = wait_msg.."--"..(math.modf(pl_percent*10)/10).."%--continue?"..msg..timeout.."[y/N]"
    M.show(msg, 1000)
end

function M.bind_key()
    mp.add_key_binding('y', 'resume_yes', M.key_jump)
    mp.add_key_binding('n', 'resume_not', function()
        M.unbind_key()
        M.wait_jump_timer:kill()
    end)
end

function M.unbind_key()
    mp.remove_key_binding('y')
    mp.remove_key_binding('n')
end

function M.key_jump()
    M.unbind_key()
    M.wait_jump_timer:kill()
    c_idx = pl_idx
    mp.register_event("file-loaded", M.jump_resume)
    mp.commandv("loadfile", pl_path)
end

function M.jump_resume()
    mp.unregister_event(M.jump_resume)
    mp.set_property("percent-pos", pl_percent)
    M.show("resume ok", 1500)
end

function M.exe()
    mp.unregister_event(M.exe)
    local c_file = mp.get_property("filename")
    local c_path = mp.get_property("path")
    if(c_file == nil) then
        M.show('no file is playing', 1500)
        return
    end
    pl_root = c_path:match("(.+)/")
    mk_path = pl_root.."/"..mk_name
    if(not M.ld_mark()) then
        pl_name = ""
        pl_path = ""
        pl_percent = 0
    end
    local c_type = c_file:match("%.([^.]+)$")
    print("palying type:", c_type)
    local pl_exist = false
    if c_type ~= nil then
        local temp_list = utils.readdir(pl_root.."/", "files")
        table.sort(temp_list)
        for i = 1, #temp_list do
            local name = temp_list[i]
            if name:match("%."..c_type.."$") ~= nil then
                local path = pl_root.."/"..name
                table.insert(pl_list, path)
                if(pl_name == name) then
                    pl_exist = true
                    pl_idx = #pl_list
                end
                if(c_file == name) then
                    c_idx = #pl_list
                end
            end
        end
    end
    if(not pl_exist) then
        pl_path = c_path
        pl_name = c_file
        pl_idx = c_idx
    end
    if(c_idx == pl_idx) then
        mp.set_property("percent-pos", pl_percent)
        M.show("resume ok", 1500)
    else
        wait_msg = M.get_file_num(pl_idx)
        M.wait_jump_timer = mp.add_periodic_timer(1, M.wait_jump)
        M.bind_key()
    end
    M.save_period_timer = mp.add_periodic_timer(o.save_period, M.save_mark)
    mp.add_hook("on_unload", 50, M.save_mark)
    mp.observe_property("pause", "bool", M.pause)
end
mp.register_event("file-loaded", M.exe)
