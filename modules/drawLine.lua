-- scriptTest.lua (in your scripts directory)
local M = {}

local Labels = {};

local minute = '';
local hour = '';
 
local purchase_height = getScriptPath() .. '\\images\\purchase_height.bmp';

local PicPathSell = getScriptPath() .. '\\images\\myDeals_sell';
local PicPathBuy = getScriptPath() .. '\\images\\myDeals_buy';
local PicPathEvent = getScriptPath() .. '\\images\\myDeals_';
local loger = dofile(getScriptPath() .. "\\modules\\loger.lua")

local function set(Price, count, textInfo)

    Price = 36.5;

    count = 1;

    if (textInfo == nul) then textInfo = ''; end
    local label_params = {};
    label_params['TEXT'] = '';
    if Operation == "BUY" then

        label_params['ALIGNMENT'] = 'BOTTOM';
    else
        if NumberInTriangles == -1 then

        else
            label_params['IMAGE_PATH'] = PicPathSell
        end
        label_params['ALIGNMENT'] = 'TOP';
    end

    label_params['ALIGNMENT'] = 'BOTTOM';

    label_params['YVALUE'] = Price;
    --     label_params['DATE'] = datetime.year .. month ..  day; 

    label_params['R'] = 255;
    label_params['G'] = 255;
    label_params['B'] = 0;
    label_params['TRANSPARENCY'] = 0;
    label_params['TRANSPARENT_BACKGROUND'] = 1;
    label_params['FONT_FACE_NAME'] = "Webdings";
    label_params['FONT_HEIGHT'] = 14;
    label_params['HINT'] = 'Price ' .. Price .. " \n " .. textInfo;

    label_params.Type = TYPE_LINE;
    label_params.Color = RGB(255, 0, 0);
    label_params.Width = 3;

    return AddLabel('test', label_params);
end

local function delete(text) end

local function init(tag) loger.save(tag .. '   tag ') end

M.set = set
M.delete = delete
M.init = init

return M
