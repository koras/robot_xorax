-- scriptTest.lua (in your scripts directory)
local M = {}

local Labels = {};
local Settings = {
    tag="my_br"
};
local minute = '';
local hour = '';
 
local PicPathSell = getScriptPath()..'\\images\\myDeals_sell';
local PicPathBuy = getScriptPath()..'\\images\\myDeals_buy'; 
local PicPathEvent = getScriptPath()..'\\images\\myDeals_'; 
local loger = dofile(getScriptPath() .. "\\loger.lua")
 
local function set(Operation, Price , datetime, count, textInfo)
  count = 1;

  if(textInfo == nul)then 
    textInfo = '';
  end;
    
     
  hour = datetime.hour;

  if datetime.hour < 10 then 
    hour = '0' .. datetime.hour
 end;


  minute = datetime.min;

    if datetime.min < 10 then 
      minute = '0' .. datetime.min
   end;

       
    --  label.Yvalue=Price;
    --  label.datetime=datetime;

   -- if #TradesTmp > 0 then
        -- ������ ����� ������
     --   for j=1,#TradesTmp,1 do
           local label_params = {};
           label_params['TEXT'] = ''; -- STRING ������� ����� (���� ������� �� ���������, �� ������ ������)         
           if Operation == "BUY" then             
           --   if NumberInTriangles == -1 then
          --       label_params['IMAGE_PATH'] = PicPathBuy; -- STRING ���� � ��������, ������� ����� ������������ � �������� ����� (������ ������, ���� �������� �� ���������)  
          --    else
                -- local PicPath = getScriptPath()..'\\images\\���������_buy'..NumberInTriangles..'.bmp';
                -- label_params['IMAGE_PATH'] = PicPathBuy;
            --  end;
              label_params['ALIGNMENT'] = 'BOTTOM'; -- STRING ������������ �������� ������������ ������ (�������� 4 ��������: LEFT, RIGHT, TOP, BOTTOM)  
           else 
              if NumberInTriangles == -1 then
          --       label_params['IMAGE_PATH'] = PicPathBuy; -- STRING ���� � ��������, ������� ����� ������������ � �������� ����� (������ ������, ���� �������� �� ���������)  
              else
                -- local PicPath = getScriptPath()..'\\�����������\\���������_sell'..NumberInTriangles..'.bmp';
             --    label_params['IMAGE_PATH'] = PicPath;
             label_params['IMAGE_PATH'] = PicPathSell
              end;
              label_params['ALIGNMENT'] = 'TOP'; -- STRING ������������ �������� ������������ ������ (�������� 4 ��������: LEFT, RIGHT, TOP, BOTTOM)  
           end;         
 
      
           label_params['ALIGNMENT'] = 'BOTTOM'; 
           
           if Operation == 'BUY' then 
            label_params['IMAGE_PATH'] = PicPathBuy..count..'.bmp'; 
          else   
            label_params['IMAGE_PATH'] = PicPathSell..count..'.bmp'; 
          end;   

           
          if Operation == 'red' or Operation == 'green'  then 
            label_params['IMAGE_PATH'] = PicPathEvent..Operation..'.bmp'; 
          else   
        --    label_params['IMAGE_PATH'] = PicPathSell..count..'.bmp'; 
          end;   
          
          local day  = datetime.day ;
          if datetime.day < 10  then 
            day  = '0'..datetime.day ;
          end;   

          local month = datetime.month ;
          if datetime.month < 10  then 
            month  = '0'..datetime.month ;
          end;   

            
           label_params['YVALUE'] = Price; -- DOUBLE �������� ��������� �� ��� Y, � �������� ����� ��������� �����  
           label_params['DATE'] = datetime.year .. month ..  day; -- DOUBLE ���� � ������� ��������Ļ, � ������� ��������� �����  
          
          
           label_params['TIME'] = hour ..   minute  .. '00'; -- DOUBLE ����� � ������� ������ѻ, � �������� ����� ��������� �����  
        
        
           label_params['R'] = 255; -- DOUBLE ������� ���������� ����� � ������� RGB. ����� � ��������� [0;255]  
           label_params['G'] = 255; -- DOUBLE ������� ���������� ����� � ������� RGB. ����� � ��������� [0;255]  
           label_params['B'] = 0; -- DOUBLE ����� ���������� ����� � ������� RGB. ����� � ��������� [0;255]  
           label_params['TRANSPARENCY'] = 0; -- DOUBLE ������������ ����� � ���������. �������� ������ ���� � ���������� [0; 100]  
           label_params['TRANSPARENT_BACKGROUND'] = 1; -- DOUBLE ������������ �����. ��������� ��������: �0� � ������������ ���������, �1� � ������������ ��������  
           label_params['FONT_FACE_NAME'] = "Webdings"; -- 'Verdana'; -- STRING �������� ������ (�������� �Arial�)  
           label_params['FONT_HEIGHT'] = 14; -- DOUBLE ������ ������  
           --   label_params['HINT'] = TradesTmp[j].Hint:gsub("_", "\n"); -- STRING ����� ���������
          label_params['HINT'] = 'Price ' .. Price .. " \n "..textInfo


        --os.date("%Y%m%d",os.time())
        
      -- loger.save(Operation.. '  '.. Settings['tag'].. '  '..  Price .. " ������� ��� ������� ���� � ����� - "..     label_params['DATE'] ..'   '..label_params['TIME'].. '  '.. label_params['IMAGE_PATH'] )
       -- loger.save(  datetime.hour ..'   '..datetime.min.. '  '.. '00' )

          AddLabel(Settings['tag'], label_params);
 

           --local LabelID = AddLabel(Settings['tag'], label_params);
         --  if LabelID ~= nil then Labels[#Labels+1] = LabelID; end;
     --   end;
   --  end;
	 
	  
end

  
local function delete(text)
      
	 
	  
end

  
local function init(tag)
    loger.save( tag..'   tag ')

    Settings['tag'] = tag;
	  
end

 

M.set = set
M.delete = delete
M.init = init
 
return M