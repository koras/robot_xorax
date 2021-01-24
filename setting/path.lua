local lua51path = "C:\\Program Files (x86)\\Lua\\5.1\\" -- путь, куда установлен дистрибутив Lua 5.1 for Windows

package.cpath = "./?.dll;./?51.dll;" .. lua51path .. "?.dll;" .. lua51path ..
                    "?51.dll;" .. lua51path .. "clibs/?.dll;" .. lua51path ..
                    "clibs/?51.dll;" .. lua51path .. "loadall.dll;" .. lua51path ..
                    "clibs/loadall.dll;" .. package.cpath
package.path = package.path .. ";./?.lua;" .. lua51path .. "lua/?.lua;" ..
                   lua51path .. "lua/?/init.lua;" .. lua51path .. "?.lua;" ..
                   lua51path .. "?/init.lua;" .. lua51path .. "lua/?.luac;"

require("table")

 
