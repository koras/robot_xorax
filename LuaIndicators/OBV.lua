Settings = {
Name = "*OBV (On Balance Volume)", 
VType = "Close", --Open, High, Low, Close, Volume, Median, Typical, Weighted, Difference
line = {{
		Name = "Horizontal line",
		Type = TYPE_LINE, 
		Color = RGB(140, 140, 140)
		},
		{
		Name = "OBV", 
		Type = TYPE_LINE, 
		Color = RGB(221, 44, 44)
		}
		},
Round = "off",
Multiply = 1,
Horizontal_line="off"
}

function Init()
	func = OBV()
	return #Settings.line
end

function OnCalculate(Index) 
	return tonumber(Settings.Horizontal_line), ConvertValue(Settings, func(Index, Settings))
end

function OBV() --On Balance "Volume" ("OBV")
	local tmp = {pp=nil, p=nil}
	local it = {pp=0, p=0, l=0}
return function (I, Fsettings, ds)
local Out = nil
local Fsettings=(Fsettings or {})
local VT = (Fsettings.VType or CLOSE)
	if I == 1 then
		tmp = {pp=nil, p=nil}
		it = {pp=0, p=0, l=0}
	end
	if CandleExist(I,ds) then
		if I~=it.p then 
			it={pp=it.p, p=I, l=it.l+1}
			tmp.pp = tmp.p
		end
		if it.l == 2 then
			tmp.p=0
		end
		if it.l > 2 then
			local P1 = GetValueEX(it.p,VT,ds)
			local P2 = GetValueEX(it.pp,VT,ds)
			if P1 > P2 then
				tmp.p = tmp.pp + GetValueEX(it.p,VOLUME,ds)
			end
			if P1 < P2 then
				tmp.p = tmp.pp - GetValueEX(it.p,VOLUME,ds)
			end
			if P1 == P2 then
				tmp.p = tmp.pp
			end
		end
		return tmp.p
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
