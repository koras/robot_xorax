-- scriptTest.lua (in your scripts directory)
local M = {}

local Labels = {};

local minute = '';
local hour = '';
 
local PicPathSell = getScriptPath()..'\\images\\myDeals_sell';
local PicPathBuy = getScriptPath()..'\\images\\myDeals_buy'; 
local PicPathEvent = getScriptPath()..'\\images\\myDeals_'; 
local PicPathSTOP = getScriptPath()..'\\images\\line_stop.jpeg'; 

 
local loger = dofile(getScriptPath() .. "\\modules\\loger.lua")
 
local function set(Operation, Price , datetime, count, textInfo)
  count = 1;
 loger.save(Operation.. 'Operation  ' .. '  Price '..  Price );
    

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
       

           local label_params = {};
           label_params['TEXT'] = '';       
           if Operation == "BUY" then             

              label_params['ALIGNMENT'] = 'BOTTOM';
           else 
              if NumberInTriangles == -1 then
        
              else
                label_params['IMAGE_PATH'] = PicPathSell
              end;
              label_params['ALIGNMENT'] = 'TOP'; 
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

          if Operation == 'stop'  then 
            label_params['IMAGE_PATH'] = PicPathSTOP; 
       
          end;   
          
          local day  = datetime.day ;
          if datetime.day < 10  then 
            day  = '0'..datetime.day ;
          end;   

          local month = datetime.month ;
          if datetime.month < 10  then 
            month  = '0'..datetime.month ;
          end;   

            
           label_params['YVALUE'] = Price; 
           label_params['DATE'] = datetime.year .. month ..  day; 
           label_params['TIME'] = hour ..   minute  .. '00';
           label_params['R'] = 255; 
           label_params['G'] = 255; 
           label_params['B'] = 0; 
           label_params['TRANSPARENCY'] = 0; 
           label_params['TRANSPARENT_BACKGROUND'] = 1; 
           label_params['FONT_FACE_NAME'] = "Webdings"; 
           label_params['FONT_HEIGHT'] = 14;
          label_params['HINT'] = 'Price ' .. Price .. " \n "..textInfo


        
      -- loger.save(Operation.. '  ' .. '  '..  Price .. " ������� ��� ������� ���� � ����� - "..     label_params['DATE'] ..'   '..label_params['TIME'].. '  '.. label_params['IMAGE_PATH'] )
       -- loger.save(  datetime.hour ..'   '..datetime.min.. '  '.. '00' )
       return   AddLabel(setting.tag, label_params);
end

  
local function delete(text)
      
	  
end

local function init(tag)
    loger.save( tag..'   tag ')
end

 

M.set = set
M.delete = delete
M.init = init
 
return M