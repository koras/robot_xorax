-- scriptTest.lua (in your scripts directory)
local M = {}
  

 


local function create()
  -- https://smart-lab.ru/blog/500526.php
  	-- Получает доступный id для создания
	t_id = AllocTable();	
	-- Добавляет 5 колонок
	  AddColumn(t_id, 0, "1", true, QTABLE_INT_TYPE, 15);
	  AddColumn(t_id, 1, "2", true, QTABLE_INT_TYPE, 15);
 --    AddColumn(t_id, 2, "3", true, QTABLE_INT_TYPE, 15);
 --   AddColumn(t_id, 3, "4", true, QTABLE_INT_TYPE, 15);
 --   AddColumn(t_id, 4, "5", true, QTABLE_INT_TYPE, 15);
	-- Создаем
	t = CreateWindow(t_id);
	-- Даем заголовок	
	SetWindowCaption(t_id, "Баланс покупок/продаж");
   -- Добавляет строку
	InsertRow(t_id, -1);
end; 
 


local function show(bid)
      -- https://smart-lab.ru/blog/500526.php
      
      -- row = InsertRow(t_id, -1)
      -- SetCell(t_id, row, 0, arr[j]["short_name"])
      -- price = arr[j]["price"]
      -- SetCell(t_id, row, 1, string.format("%.2f", price), price)
      
      
      if  #bid > 0  then 
        for j=1,  #bid  do 
          SetCell(t_id, 1, j, tostring(bid[j]));
         end;  
     end; 
end; 
     
 

M.show = show

return M