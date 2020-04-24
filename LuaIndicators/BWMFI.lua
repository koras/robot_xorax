Settings = {
Name = "*BWMFI (Bill Williams Market Facilitation Index)", 
line = {{
		Name = "Horizontal line",
		Type = TYPE_LINE, 
		Color = RGB(140, 140, 140)
		},
		{
		Width = 3,
		Name = "BWMFI_Green", 
		Type = TYPE_HISTOGRAM, 
		Color = RGB(0, 206, 0)
		},
		{
		Width = 3,
		Name = "BWMFI_Fade", 
		Type = TYPE_HISTOGRAM, 
		Color = RGB(128, 64, 0)
		},
		{
		Width = 3,
		Name = "BWMFI_Fake", 
		Type = TYPE_HISTOGRAM, 
		Color = RGB(0, 255, 255)
		},
		{
		Width = 3,
		Name = "BWMFI_Squat", 
		Type = TYPE_HISTOGRAM, 
		Color = RGB(255, 0, 255)
		}
		},
Round = "off",
Multiply = 1,
Horizontal_line="0"
}

function Init()
	func = BWMFI()
	return #Settings.line
end

function OnCalculate(Index)
local Out = ConvertValue(Settings, func(Index, Settings))
local HL = tonumber(Settings.Horizontal_line)
	if Out then
		local prev = GetValue(Index-1, 2) or GetValue(Index-1, 3) or GetValue(Index-1, 4) or GetValue(Index-1, 5) or 0
		local prev_v = V(Index-1) or 0
		if (Out > prev) and (V(Index) > prev_v) then
			return HL,Out,nil,nil,nil
		elseif (Out <= prev) and (V(Index) <= prev_v) then
			return HL,nil,Out,nil,nil
		elseif (Out > prev) and (V(Index) <= prev_v) then
			return HL,nil,nil,Out,nil
		elseif (Out <= prev) and (V(Index) > prev_v) then
			return HL,nil,nil,nil,Out
		end
	else
		return HL,nil,nil,nil,nil
	end
end

function BWMFI() --Bill Williams Market Facilitation I ("BWMFI")
	local it = {p=0, l=0}
return function (I, Fsettings, ds)
	if I == 1 then
		it = {p=0, l=0}
	end
	if CandleExist(I,ds) then
		if I~=it.p then it={p=I, l=it.l+1} end
		return GetValueEX(it.p, DIFFERENCE, ds) / GetValueEX(it.p, VOLUME, ds)
	end
return nil
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