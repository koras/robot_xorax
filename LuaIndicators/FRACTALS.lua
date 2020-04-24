Settings = {
Name = "*FRACTALS (Fractals)", 
Period = 5,
line = {{
		Name = "Horizontal line",
		Type = TYPE_LINE, 
		Color = RGB(140, 140, 140)
		},
		{
		Name = "FRACTALS - Up", 
		Type = TYPE_TRIANGLE_UP, 
		Color = RGB(0, 206, 0)
		},
		{
		Name = "FRACTALS - Down", 
		Type = TYPE_TRIANGLE_DOWN, 
		Color = RGB(221, 44, 44)
		}
		},
Round = "off",
Multiply = 1,
Horizontal_line="off"
}
			
function Init()
	func = FRACTALS()
	return #Settings.line
end

function OnCalculate(Index)
local Out1,Out2 = func(Index, Settings)
	SetValue(Out1, 2, ConvertValue(Settings,H(Out1)))
	SetValue(Out2, 3, ConvertValue(Settings,L(Out2)))
	return tonumber(Settings.Horizontal_line),nil,nil
end

function FRACTALS() --Fractals ("FRACTALS")
	local H_tmp={}
	local L_tmp={}
	local it = {[1]=0, l=0}
return function (I, Fsettings, ds)
local Fsettings=(Fsettings or {})
local P = (Fsettings.Period or 5)
if (P>0) then
	if I == 1 then
		H_tmp={}
		L_tmp={}
		it = {[1]=0, l=0}
	end
	if CandleExist(I,ds) then
		if I~=it[Squeeze(it.l,P)] then
			it.l = it.l + 1
			it[Squeeze(it.l,P)] = I
		end
		local Ip,Ipppp = Squeeze(it.l,P),Squeeze(it.l,P-1)+1
		local nP = math.floor(P/2)*2+1
		H_tmp[Ipppp] = GetValueEX(it[Ip],HIGH,ds)
		L_tmp[Ipppp] = GetValueEX(it[Ip],LOW,ds)
		if it.l >= nP then
			local S = it[Squeeze(it.l-nP+1+math.floor(nP/2),P)]
			local val_h=math.max(unpack(H_tmp))
			local val_l=math.min(unpack(L_tmp))
			local L = GetValueEX(S,LOW,ds)
			local H = GetValueEX(S,HIGH,ds)
			if (val_h == H) and (val_h >0) 
				and (val_l == L) and (val_l > 0) then
					return S,S
			else
				if (val_h == H) and (val_h > 0) then
					return S,nil
				end
				if (val_l == L) and (val_l > 0) then
					return nil,S
				end
			end
		end
	end
end
return nil,nil
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