Settings = {
Name = "*PSAR (Parabolic SAR)", 
Step = 0.02,
MaxStep = 0.2, 
line = {{
		Name = "Horizontal line",
		Type = TYPE_LINE, 
		Color = RGB(140, 140, 140)
		},
		{
		Width = 3,
		Name = "PSAR_Up", 
		Type = TYPE_POINT, 
		Color = RGB(0, 206, 0)
		},
		{
		Width = 3,
		Name = "PSAR_Down", 
		Type = TYPE_POINT, 
		Color = RGB(221, 44, 44)
		}
		},
Round = "off",
Multiply = 1,
Horizontal_line="off"
}

function Init()
	func = PSAR()
	return #Settings.line
end

function OnCalculate(Index) 
local Out = ConvertValue(Settings, func(Index, Settings))
local HL = tonumber(Settings.Horizontal_line)
	if Out then
		if Out > ((H(Index)-L(Index))/2)+L(Index) then
			return HL,Out,nil
		else
			return HL,nil,Out
		end
	else
		return HL,nil,nil
	end
end

function PSAR() --Parabolic SAR ("PSAR")
	local tmp = {pp=nil, p=nil}
	local it = {ppp=0, pp=0, p=0, l=0}
return function (I, Fsettings, ds)
local Out = nil
local Fsettings=(Fsettings or {})
local Step = (Fsettings.Step or 0.02)
local MaxStep = (Fsettings.MaxStep or 0.2)
	if I == 1 then
		tmp = {pp=nil, p=nil}
		it = {ppp=0, pp=0, p=0, l=0}
	end
	if CandleExist(I,ds) then
		if I~=it.p then 
			it={ppp=it.pp, pp=it.p, p=I, l=it.l+1}
			tmp.pp = tmp.p
		end
		local cand = {ppp=nil, pp=nil, p=nil}
		tmp.p = {Val = nil, Step = 0, Ext = 0, Long = true}
		cand.p = {H = GetValueEX(it.p,HIGH,ds), L = GetValueEX(it.p,LOW,ds)}
		if it.l==2 then
			tmp.p = {Val = GetValueEX(it.p,HIGH,ds), Step = Step, Ext = cand.p.H, Long = true}
		end
		if it.l > 2 then
			local Revers = false
			tmp.p.Val = tmp.pp.Val + tmp.pp.Step * (tmp.pp.Ext - tmp.pp.Val)
			tmp.p.Long = tmp.pp.Long
			tmp.p.Ext = tmp.pp.Ext
			tmp.p.Step = tmp.pp.Step
			if tmp.pp.Long then
				if cand.p.L < tmp.p.Val then
					tmp.p = {Val = tmp.pp.Ext, Step = Step, Ext = cand.p.L, Long = false}
					Revers = true
				end
			else
				if cand.p.H > tmp.p.Val then
					tmp.p = {Val = tmp.pp.Ext, Step = Step, Ext = cand.p.H, Long = true}
					Revers = true
				end
			end
			if not Revers then
				cand.pp = {H = GetValueEX(it.pp,HIGH,ds), L = GetValueEX(it.pp,LOW,ds)}
				cand.ppp = {H = GetValueEX(it.ppp,HIGH,ds), L = GetValueEX(it.ppp,LOW,ds)}
				if tmp.pp.Long then
					if cand.p.H > tmp.pp.Ext then
						tmp.p.Ext = cand.p.H
						tmp.p.Step = tmp.pp.Step + Step
						if tmp.p.Step > MaxStep then tmp.p.Step = MaxStep end
					end
					if cand.pp.L < tmp.p.Val then tmp.p.Val = cand.pp.L end
					if cand.ppp.L < tmp.p.Val then tmp.p.Val = cand.ppp.L end
				else
					if cand.p.L < tmp.pp.Ext then
						tmp.p.Ext = cand.p.L
						tmp.p.Step = tmp.pp.Step + Step
						if tmp.p.Step > MaxStep then tmp.p.Step = MaxStep end
					end
					if cand.pp.H > tmp.p.Val then tmp.p.Val = cand.pp.H end
					if cand.ppp.H > tmp.p.Val then tmp.p.Val = cand.ppp.H end
				end
			end
		end
		return tmp.p.Val
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