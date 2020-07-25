-- https://www.lua.org/ftp/
-- Бесплатный робот торгующий в боковике "robot XoraX"
-- https://t.me/robots_xorax
-- https://smart-lab.ru/blog/621155.php
local lua51path = "C:\\Program Files (x86)\\Lua\\5.1\\" -- путь, куда установлен дистрибутив Lua 5.1 for Windows

package.cpath = "./?.dll;./?51.dll;" .. lua51path .. "?.dll;" .. lua51path ..
                    "?51.dll;" .. lua51path .. "clibs/?.dll;" .. lua51path ..
                    "clibs/?51.dll;" .. lua51path .. "loadall.dll;" .. lua51path ..
                    "clibs/loadall.dll;" .. package.cpath
package.path = package.path .. ";./?.lua;" .. lua51path .. "lua/?.lua;" ..
                   lua51path .. "lua/?/init.lua;" .. lua51path .. "?.lua;" ..
                   lua51path .. "?/init.lua;" .. lua51path .. "lua/?.luac;"

require("table")

Run = true;

function init() end

function OnInit() end

-- https://user.su/lua/index.php?id=33
function main()
    -- тангенс угла x (аргумент - в радианах)
    local x = 0.4;
    local res = math.tan(x);

    message(tostring(res));
    -- переводит угол, заданный в радианах (x)в градусы
    local res2 = math.deg(x)

    message("res = " .. tostring(res2));

    -- конвертирует угол x, заданный в градусах, в радианы
    local rad2 = math.rad(x)

    message("math.rad(x) = " .. tostring(rad2));

    while Run do end
end

function OnStop() Run = false; end
