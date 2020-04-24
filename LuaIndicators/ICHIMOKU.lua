Settings = {
Name = "*ICHIMOKU (Ichimoku Kinko Hyo)", 
Tenkan = 9, 
Kijun = 26, 
Senkou = 52, 
Chinkou = 26, 
Shift = 26,
line = {{
		Name = "Horizontal line",
		Type = TYPE_LINE, 
		Color = RGB(140, 140, 140)
		},
		{
		Name = "ICHIMOKU - Tenkan", 
		Type = TYPE_LINE, 
		Color = RGB(255, 0, 255)
		},
		{
		Name = "ICHIMOKU - Kijun", 
		Type = TYPE_LINE, 
		Color = RGB(221, 44, 44)
		},
		{
		Name = "ICHIMOKU - Senkou Span1", 
		Type = TYPE_LINE, 
		Color = RGB(0, 255, 255)
		},
		{
		Name = "ICHIMOKU - Senkou Span2", 
		Type = TYPE_LINE, 
		Color = RGB(0, 206, 0)
		},
		{
		Name = "ICHIMOKU - Chinkou", 
		Type = TYPE_LINE, 
		Color = RGB(128, 0, 0)
		}
		},
Round = "off",
Multiply = 1,
Horizontal_line="off"
}
			
function Init()
	func = ICHIMOKU()
	return #Settings.line
end

function OnCalculate(Index) 
local Out1,Out2,Out3,Out4,Out5 = func(Index, Settings)
	SetValue(Out5, 6, ConvertValue(Settings,C(Index)))
	return tonumber(Settings.Horizontal_line),ConvertValue(Settings,Out1,Out2,Out3,Out4,nil)
end

function ICHIMOKU() --Ichimoku ("ICHIMOKU")
	local OutSenkou1 = {}
	local OutSenkou2 = {}
	local H_tmp={}
	local L_tmp={}
	local it = {p=0, l=0}
return function (I, Fsettings, ds)
local Fsettings=(Fsettings or {})
local Tenkan = (Fsettings.Tenkan or 9)
local Kijun = (Fsettings.Kijun or 26)
local Senkou = (Fsettings.Senkou or 52)
local Chinkou = (Fsettings.Chinkou or 26)
local Shift = (Fsettings.Shift or 26)
local function sen(H_t,L_t,Ind,Per)
	if Ind >= Per then
		return (math.max(unpack(H_t,Ind-Per+1,Ind)) + math.min(unpack(L_t,Ind-Per+1,Ind)))/2
	else return nil	end
end
if (Tenkan>0) and (Kijun>0) and (Senkou>0) and (Chinkou>0) then
	if I == 1 then
		OutSenkou1 = {}
		OutSenkou2 = {}
		H_tmp={}
		L_tmp={}
		it = {p=0, l=0}
	end
	if CandleExist(I,ds) then
		if I~=it.p then it={p=I, l=it.l+1} end
		H_tmp[it.l] = GetValueEX(it.p,HIGH,ds)
		L_tmp[it.l] = GetValueEX(it.p,LOW,ds)
		local OutTenkan = sen(H_tmp, L_tmp, it.l, Tenkan)
		local OutKijun = sen(H_tmp, L_tmp, it.l, Kijun)
		if it.l >= math.max(Tenkan, Kijun) then
			OutSenkou1[Squeeze(it.l,Senkou)] = (OutTenkan + OutKijun)/2
		else
			OutSenkou1[Squeeze(it.l,Senkou)] = nil
		end
		OutSenkou2[Squeeze(it.l,Senkou)] = sen(H_tmp, L_tmp, it.l, Senkou)
		return OutTenkan,
			OutKijun,
			OutSenkou1[Squeeze(it.l-Shift,Senkou)],
			OutSenkou2[Squeeze(it.l-Shift,Senkou)],
			it.p - Chinkou
	end
end
return nil,nil,nil,nil,nil
end
end


SMA,MMA,EMA,WMA,SMMA,VMA = "SMA","MMA","EMA","WMA","SMMA","VMA"
OPEN,HIGH,LOW,CLOSE,VOLUME,MEDIAN,TYPICAL,WEIGHTED,DIFFERENCE,ANY = "O","H","L","C","V","M","T","W","D","A"

function CandleExist(I,ds)
return (type(C)=="function" and C(I)~=nil) or
	(type(ds)=="table" and (ds[I]~=nil or (type(ds.Size)=="function" and (I>0) and (I<=ds:Size()))))
end

function Squeeze(I,P)
	return math.fmod(I-1,P+1)
end

function ConvertValue(T,...)
local function r(V, R) 
	if R and string.upper(R)== "ON" then R=0 end
	if V and tonumber(R) then
		if V >= 0 then return math.floor(V * 10^R + 0.5) / 10^R
		else return math.ceil(V * 10^R - 0.5) / 10^R end
	else return V end
end
local arg = {...}
arg.n = select('#', ...)
	if arg.n > 0 then
		for i = 1, arg.n do
			arg[i]=arg[i] and r(arg[i] * ((T and T.Multiply) or 1), (T and T.Round) or "off")
		end
		return unpack(arg)
	else return nil end
end

function GetValueEX(I,VT,ds) 
VT=(VT and string.upper(string.sub(VT,1,1))) or ANY
	if VT == OPEN then			--Open
		return (O and O(I)) or (ds and ds:O(I))
	elseif VT == HIGH then 		--High
		return (H and H(I)) or (ds and ds:H(I))
	elseif VT == LOW then		--Low
		return (L and L(I)) or (ds and ds:L(I))
	elseif VT == CLOSE then		--Close
		return (C and C(I)) or (ds and ds:C(I))
	elseif VT == VOLUME then		--Volume
		return (V and V(I)) or (ds and ds:V(I)) 
	elseif VT == MEDIAN then		--Median
		return ((GetValueEX(I,HIGH,ds) + GetValueEX(I,LOW,ds)) / 2)
	elseif VT == TYPICAL then	--Typical
		return ((GetValueEX(I,MEDIAN,ds) * 2 + GetValueEX(I,CLOSE,ds))/3)
	elseif VT == WEIGHTED then	--Weighted
		return ((GetValueEX(I,TYPICAL,ds) * 3 + GetValueEX(I,OPEN,ds))/4) 
	elseif VT == DIFFERENCE then	--Difference
		return (GetValueEX(I,HIGH,ds) - GetValueEX(I,LOW,ds))
	else							--Any
		return (ds and ds[I])
	end
return nil
end