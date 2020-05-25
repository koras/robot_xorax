

local M = {}

function Red(tableShow, Line, Col) 
	if Col == nil then Col = QTABLE_NO_INDEX; end;
	SetColor(tableShow, Line, Col, RGB(255,168,164), RGB(0,0,0), RGB(255,168,164), RGB(0,0,0));
 end;
 function Gray(tableShow, Line, Col)  
	if Col == nil then Col = QTABLE_NO_INDEX; end;
	SetColor(tableShow, Line, Col, RGB(200,200,200), RGB(0,0,0), RGB(200,200,200), RGB(0,0,0));
 end;
 function Green(tableShow,Line, Col) 
	if Col == nil then Col = QTABLE_NO_INDEX; end;
	SetColor(tableShow, Line, Col, RGB(165,227,128), RGB(0,0,0), RGB(165,227,128), RGB(0,0,0));
 end;


 function WhiteGreen(tableShow,Line, Col) 
	if Col == nil then Col = QTABLE_NO_INDEX; end;
	SetColor(tableShow, Line, Col, RGB(216,252,219), RGB(0,0,0), RGB(165,227,128), RGB(0,0,0));
 end;


 function Yellow(tableShow,Line, Col) 
	if Col == nil then Col = QTABLE_NO_INDEX; end;
	SetColor(tableShow, Line, Col, RGB(255,255,0), RGB(000,000,0),RGB(255,255,0),RGB(0,0,0));
 end;

 
 function Blue(tableShow, Line, Col) 
	if Col == nil then Col = QTABLE_NO_INDEX; end;
	SetColor(tableShow, Line, Col, RGB(4,51,119), RGB(4,51,119),RGB(4,51,119),RGB(4,51,119));
 end;
 
 function White(tableShow, Line, Col) 
	if Col == nil then Col = QTABLE_NO_INDEX; end;
	SetColor(tableShow, Line, Col, RGB(255,255,255), RGB(4,51,119), RGB(255,255,255),RGB(4,51,119));
 end;
 
 M. WhiteGreen =  WhiteGreen;
 M.Red = Red;
 M.White = White;
 M.Blue = Blue;
 M.Green = Green;
 M.Yellow = Yellow;
 M.Gray = Gray;
 