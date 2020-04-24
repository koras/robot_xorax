-- scriptTest.lua (in your scripts directory)
local M = {}
local log = getScriptPath().."\\log\\TakeprofitLog.txt";
local function save(text)
        -- Пытается открыть файл в режиме "чтения/записи"
           f = io.open(log,"a");
           if f == nil then 
             f = io.open(log,"w"); 
            f:close();
            f = io.open(log,"a");
          end; 
             f:write(text .. "\n")
             -- Закрывает файл
            f:close(); 
end
M.save = save
return M