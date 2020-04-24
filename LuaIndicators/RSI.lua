Settings = {
Name = "*RSI (Relative Strength Index)", 
Period = 14, 
Metod = "MMA", --SMA, MMA, EMA, WMA, SMMA, VMA
VType = "Close", --Open, High, Low, Close, Volume, Median, Typical, Weighted, Difference
line = {{
		Name = "Horizontal line (top)",
		Type = TYPE_LINE, 
		Color = RGB(140, 140, 140)
		},
		{
		Name = "Horizontal line (bottom)",
		Type = TYPE_LINE, 
		Color = RGB(140, 140, 140)
		},
		{
		Name = "RSI",
		Type = TYPE_LINE, 
		Color = RGB(221, 44, 44)
		}
		},
Round = "off",
Multiply = 1,
Horizontal_line="20"
}

function Init()
	func = RSI()
	return #Settings.line
end

function OnCalculate(Index)
local Out = ConvertValue(Settings, func(Index, Settings))
local HL = tonumber(Settings.Horizontal_line)
	if HL then
		return 50+HL,50-HL,Out
	else
		return nil,nil,Out
	end
end

function RSI() --Relative Strength I("RSI")
	local RSI_MA_U = MA()
	local RSI_MA_D = MA()
	local sumU = {}
	local sumD = {}
	local cand = {pp=nil, p=nil}
	local it = {pp=0, p=0, l=0}
return function (I, Fsettings, ds)
local Fsettings=(Fsettings or {})
local P = (Fsettings.Period or 14)
local M = (Fsettings.Metod or MMA)
local VT = (Fsettings.VType or CLOSE)
if (P>0) then
	if I == 1 then
		it = {pp=0, p=0, l=0}
	end
	if CandleExist(I,ds) then
		if I~=it.p then 
			it={pp=it.p, p=I, l=it.l+1}
			cand.pp = cand.p
		end
		cand.p = GetValueEX(it.p,VT,ds)
		local Up = 0
		local Down = 0
		if it.l > 1 then
			if cand.pp < cand.p then
				Up = cand.p - cand.pp
			end
			if cand.pp > cand.p then
				Down = cand.pp - cand.p
			end
		end
		local val_Up = RSI_MA_U(it.l, {Period=P, Metod = M, VType=ANY}, {[it.l] = Up})
		local val_Down = RSI_MA_D(it.l, {Period=P, Metod = M, VType=ANY}, {[it.l] = Down})
		if it.l >= P then
			if val_Down==0 then 
				return 100
			else
				return 100 - (100 / (1 + (val_Up / val_Down)))
			end
		end
	end
end
return nil
end
end

function MA() --Moving Average ("MA")
	local T_MA = {[SMA]=F_SMA(),[MMA]=F_MMA(),[EMA]=F_EMA(),[VMA]=F_VMA(),[SMMA]=F_SMMA(),[WMA]=F_WMA()}
return function (I, Fsettings, ds)
	local Fsettings=(Fsettings or {})
	local P = (Fsettings.Period or 14)
	if (P > 0) then
		return T_MA[string.upper(Fsettings.Metod or EMA)](I, P, (Fsettings.VType or CLOSE), ds)
	end
return nil
end
end

------------------------------------------------------------------
----Moving Average SMA, MMA, EMA, WMA, SMMA, VMA
------------------------------------------------------------------
--[[Simple Moving Average (SMA)
SMA = sum(Pi) / n]]
function F_SMA()
	local sum = {}
	local it = {p=0, l=0}
return function (I, P, VT, ds)
	if I == 1 then
		sum = {}
		it = {p=0, l=0}
	end
	if CandleExist(I,ds) then
		if I~=it.p then it={p=I, l=it.l+1} end
		local Ip,Ipp,Ippp = Squeeze(it.l,P),Squeeze(it.l-1,P),Squeeze(it.l-P,P)
		sum[Ip] = (sum[Ipp] or 0) + GetValueEX(it.p,VT,ds)
		if it.l >= P then
			return (sum[Ip] - (sum[Ippp] or 0)) / P
		end
	end
return nil
end
end

--[[Modified Moving Average (MMA)
MMA = (MMAi-1*(n-1) + Pi) / n]]
function F_MMA() 
	local sum = {}
	local tmp = {pp=nil, p=nil}
	local it = {p=0, l=0}
return function(I, P, VT, ds)
	if I == 1 then
		sum = {}
		tmp = {pp=nil, p=nil}
		it = {p=0, l=0}
	end
	if CandleExist(I,ds) then
		if I~=it.p then 
			it = {p=I, l=it.l+1} 
			tmp.pp = tmp.p
		end
		local Ip,Ipp,Ippp = Squeeze(it.l,P),Squeeze(it.l-1,P),Squeeze(it.l-P,P)
		if it.l <= P + 1 then
			sum[Ip] = (sum[Ipp] or 0) + GetValueEX(it.p,VT,ds)
			if (it.l == P) or (it.l == P + 1) then
				tmp.p = (sum[Ip] - (sum[Ippp] or 0)) / P
			end
		else
			tmp.p = (tmp.pp*(P-1) + GetValueEX(it.p,VT,ds)) / P
		end
		if it.l >= P then
			return tmp.p
		end
	end
return nil
end
end

--[[Exponential Moving Average (EMA)
EMAi = (EMAi-1*(n-1)+2*Pi) / (n+1)]]
function F_EMA() 
	local tmp = {pp=nil, p=nil}
	local it = {p=0, l=0}
return function(I, P, VT, ds)
	if I == 1 then
		tmp = {pp=nil, p=nil}
		it = {p=0, l=0}
	end
	if CandleExist(I,ds) then
		if I~=it.p then 
			it = {p=I, l=it.l+1} 
			tmp.pp = tmp.p
		end
		if it.l == 1 then
			tmp.p = GetValueEX(it.p,VT,ds)
		else
			tmp.p = (tmp.pp*(P-1) + 2*GetValueEX(it.p,VT,ds)) / (P+1)
		end
		if it.l >= P then
			return tmp.p
		end
	end
return nil
end
end

--[[
William Moving Average (WMA)
( Previous WILLMA * ( Period - 1 ) + Data ) / Period]]
function F_WMA()
	local tmp = {pp=nil, p=nil}
	local it = {p=0, l=0}
return function(I, P, VT, ds)
	if I == 1 then
		tmp = {pp=nil, p=nil}
		it = {p=0, l=0}
	end
	if CandleExist(I,ds) then
		if I~=it.p then 
			it={p=I, l=it.l+1}
			tmp.pp = tmp.p
		end
		if it.l == 1 then
			tmp.p = GetValueEX(it.p,VT,ds)
		else
			tmp.p = (tmp.pp * (P-1) + GetValueEX(it.p,VT,ds)) / P
		end
		if it.l >= P then
			return tmp.p
		end
	end
return nil
end
end

--[[Volume Adjusted Moving Average (VMA)
VMA = sum(Pi*Vi) / sum(Vi)]]
function F_VMA()
	local sum = {}
	local sum2 = {}
	local it = {p=0, l=0}
return function(I, P, VT, ds)
	if I == 1 then
		sum = {}
		sum2 = {}
		it = {p=0, l=0}
	end
	if CandleExist(I,ds) then
		if I~=it.p then it={p=I, l=it.l+1} end
		local Ip,Ipp,Ippp = Squeeze(it.l,P),Squeeze(it.l-1,P),Squeeze(it.l-P,P)
		sum[Ip] = (sum[Ipp] or 0) + GetValueEX(it.p,VT,ds) * GetValueEX(it.p,VOLUME,ds)
		sum2[Ip] = (sum2[Ipp] or 0) + GetValueEX(it.p,VOLUME,ds)
		if it.l >= P then
			return (sum[Ip] - (sum[Ippp] or 0)) / (sum2[Ip] - (sum2[Ippp] or 0))
		end
	end
return nil
end
end

--[[Smoothed Moving Average (SMMA)
SMMAi = (sum(Pi) - SMMAi-1 + Pi) / n]]
function F_SMMA()
	local sum = {}
	local sum2 = {}
	local it = {p=0, l=0}
return function(I, P, VT, ds)
	if I == 1 then
		sum = {}
		sum2 = {}
		it = {p=0, l=0}
	end
	if CandleExist(I,ds) then
		if I~=it.p then it={p=I, l=it.l+1} end
		local Ip,Ipp,Ippp = Squeeze(it.l,P),Squeeze(it.l-1,P),Squeeze(it.l-P,P)
		sum[Ip] = (sum[Ipp] or 0) + GetValueEX(it.p,VT,ds)
		if it.l >= P then
			if it.l == P then
				sum2[Ip] = (sum[Ip] - (sum[Ippp] or 0)) / P
			else
				sum2[Ip] = ((sum[Ip] - (sum[Ippp] or 0)) - (sum2[Ipp] or 0)+ GetValueEX(it.p,VT,ds)) / P
			end
			return sum2[Ip]
		end
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