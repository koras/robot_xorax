-- scriptTest.lua (in your scripts directory)
local M = {}
local log = getScriptPath().."\\log\\dataLog.txt";
local logSignal = getScriptPath().."\\log\\EventLog.txt";

  -- Пытается открыть файл в режиме "чтения/записи"
local function save(text) 
    --  f = io.open(log,"a");
    --  if f == nil then 
    --    f = io.open(log,"w"); 
    --   f:close();
    --   f = io.open(log,"a");
    -- end; 
    --    f:write(text .. "\n")
    --    -- Закрывает файл
    --   f:close(); 
end

        -- Пытается открыть файл в режиме "чтения/записи"
local function saveSignal(text) 
          --  f = io.open(logSignal,"a");
          --  if f == nil then 
          --    f = io.open(logSignal,"w"); 
          --   f:close();
          --   f = io.open(logSignal,"a");
          -- end; 
          --    f:write(text .. "\n")
          --    -- Закрывает файл
          --   f:close(); 
end

 

M.save = save
M.saveSignal = saveSignal
return M