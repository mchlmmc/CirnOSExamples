-- LCD Driver in Lua test
local bit = require("bit")

-- Begin SPI

LCD_CS = 8
LCD_RST = 27
LCD_DC = 25
LCD_BL = 24

pinMode(LCD_RST, OUTPUT)
pinMode(LCD_DC, OUTPUT)
pinMode(LCD_CS, OUTPUT)

beginSPI()
setSPIDataMode(SPI_MODE0)
setSPIClockDivider(DIVIDER_8)
setSPIChipSelect(SPI_CS0)
setSPIChipSelectPolarity(SPI_CS0, OFF)

-- Begin LCD
-- Backlight on
writePin(LCD_BL, OFF)

-- Reset LCD
function resetLCD()
   writePin(LCD_RST, ON)
   delay(100)
   writePin(LCD_RST, OFF)
   delay(100)
   writePin(LCD_RST, ON)
   delay(100)   
end

resetLCD()

-- Init registers

function writeReg(reg)
   writePin(LCD_DC, OFF)
   writeByteSPI(reg)
end

function writeData8Bit(data)
   writePin(LCD_DC, ON)
   writeByteSPI(data)
end

function writeData16Bit(data)
   writePin(LCD_DC, ON)
   writeByteSPI(bit.rshift(data, 8))
   writeByteSPI(bit.band(data, 0xFF))   
end

function writeDataNLen16Bit(data, len)   
   writePin(LCD_DC, ON)
   for i=1, len do
      writeByteSPI(bit.rshift(data, 8))
      writeByteSPI(bit.band(data, 0xFF))         
   end
end

function initRegs()
    --ST7735R Frame Rate
    writeReg(0xB1)
    writeData8Bit(0x01)
    writeData8Bit(0x2C)
    writeData8Bit(0x2D)

    writeReg(0xB2)
    writeData8Bit(0x01)
    writeData8Bit(0x2C)
    writeData8Bit(0x2D)

    writeReg(0xB3)
    writeData8Bit(0x01)
    writeData8Bit(0x2C)
    writeData8Bit(0x2D)
    writeData8Bit(0x01)
    writeData8Bit(0x2C)
    writeData8Bit(0x2D)

    writeReg(0xB4) --Column inversion
    writeData8Bit(0x07)

    --ST7735R Power Sequence
    writeReg(0xC0)
    writeData8Bit(0xA2)
    writeData8Bit(0x02)
    writeData8Bit(0x84)
    writeReg(0xC1)
    writeData8Bit(0xC5)

    writeReg(0xC2)
    writeData8Bit(0x0A)
    writeData8Bit(0x00)

    writeReg(0xC3)
    writeData8Bit(0x8A)
    writeData8Bit(0x2A)
    writeReg(0xC4)
    writeData8Bit(0x8A)
    writeData8Bit(0xEE)

    writeReg(0xC5) --VCOM
    writeData8Bit(0x0E)

    --ST7735R Gamma Sequence
    writeReg(0xe0)
    writeData8Bit(0x0f)
    writeData8Bit(0x1a)
    writeData8Bit(0x0f)
    writeData8Bit(0x18)
    writeData8Bit(0x2f)
    writeData8Bit(0x28)
    writeData8Bit(0x20)
    writeData8Bit(0x22)
    writeData8Bit(0x1f)
    writeData8Bit(0x1b)
    writeData8Bit(0x23)
    writeData8Bit(0x37)
    writeData8Bit(0x00)
    writeData8Bit(0x07)
    writeData8Bit(0x02)
    writeData8Bit(0x10)

    writeReg(0xe1)
    writeData8Bit(0x0f)
    writeData8Bit(0x1b)
    writeData8Bit(0x0f)
    writeData8Bit(0x17)
    writeData8Bit(0x33)
    writeData8Bit(0x2c)
    writeData8Bit(0x29)
    writeData8Bit(0x2e)
    writeData8Bit(0x30)
    writeData8Bit(0x30)
    writeData8Bit(0x39)
    writeData8Bit(0x3f)
    writeData8Bit(0x00)
    writeData8Bit(0x07)
    writeData8Bit(0x03)
    writeData8Bit(0x10)

    writeReg(0xF0) --Enable test command
    writeData8Bit(0x01)

    writeReg(0xF6) --Disable ram power save mode
    writeData8Bit(0x00)

    writeReg(0x3A) --65k mode
    writeData8Bit(0x05)
end

initRegs()

LCDDIS = {}

-- Constants
L2R_U2D = 0
L2R_D2U = 1
R2L_U2D = 2
R2L_D2U = 3
U2D_L2R = 4
U2D_R2L = 5
D2U_L2R = 6
D2U_R2L = 7

LCD_HEIGHT = 128
LCD_WIDTH = 128

LCD_X = 2
LCD_Y = 1

-- Set the scan and transfer modes
function setGramScanWay()
    -- Set the screen scan direction
    LCDDIS.scanDir = U2D_R2L

    -- Get GRAM and LCD width and height

    -- Gets the scan direction of GRAM
    local MemoryAccessReg_Data = bit.bor(0x00, 0x40, 0x20)

    -- please set (MemoryAccessReg_Data & 0x10) != 1
    LCDDIS.xAdjust = LCD_Y
    LCDDIS.yAdjust = LCD_X

    -- Set the read / write scan direction of the frame memory
    writeReg(0x36) --MX, MY, RGB mode
    writeData8Bit(bit.bor(MemoryAccessReg_Data, 0x08))	--0x08 set RGB
end

setGramScanWay()

delay(200)

-- sleep out
writeReg(0x11)
delay(120)

-- Colors
BLACK = 0x0000
WHITE = 0xFFFF
RED = 0xF800
GREEN = 0x07E0

function setWindow(xStart, yStart, xEnd, yEnd)
   -- Set the X coordinates
   writeReg(0x2A)
   writeData8Bit(0) -- Set the horizontal starting point to the high octet
   writeData8Bit((bit.band(xStart, 0xFF)) + LCDDIS.xAdjust) -- Set the horizontal starting point to the low octet
   writeData8Bit(0) -- Set the horizontal end to the high octet
   writeData8Bit((bit.band((xEnd - 1), 0xFF)) + LCDDIS.xAdjust) -- Set the horizontal end to the low octet

   -- Set the Y coordinates
   writeReg(0x2B)
   writeData8Bit(0)
   writeData8Bit(bit.band(yStart, 0xFF) + LCDDIS.yAdjust)
   writeData8Bit(0)
   writeData8Bit(bit.band((yEnd - 1), 0xFF) + LCDDIS.yAdjust)

   writeReg(0x2C)
end

function setColor(color, xPoint, yPoint)
   writeDataNLen16Bit(color, xPoint * yPoint)
end

function setAreaColor(xStart, yStart, xEnd, yEnd, color)
   if xStart < 0 then xStart = 0 end
   if yStart < 0 then yStart = 0 end
   if xEnd > 128 then xEnd = 128 end
   if yEnd > 128 then yEnd = 128 end
   if (xEnd <= xStart) or (yEnd <= yStart) then return end   
   setWindow(xStart, yStart, xEnd, yEnd)
   setColor(color, xEnd - xStart, yEnd - yStart)
end

function clear(color)
   setAreaColor(0, 0, LCD_WIDTH, LCD_HEIGHT, color)
end

function drawText(text, x, y, fontName, size, color)
    if not fonts[fontName] then return end
    color = color or WHITE
    size = size or 1
    local curX = x
    for i=1, string.len(text) do
        local thisChar = fonts[fontName][string.byte(text, i)]
        for r=1, #thisChar do
	    setAreaColor(curX + (thisChar[r].x * size), y + (thisChar[r].y * size), curX + ((thisChar[r].x + thisChar[r].w) * size),
	    y + ((thisChar[r].y + thisChar[r].h) * size), color)
	end
	if i < string.len(text) then
	    local charWidth
	    if fonts[fontName].kerning[string.byte(text, i)][string.byte(text, i+1)] then
	        charWidth = fonts[fontName].kerning[string.byte(text, i)][string.byte(text, i+1)]
	    else
	        charWidth = thisChar.width or fonts[fontName].width
	    end
	    curX = curX + (charWidth * size)
	end
    end
end

function loadFont(fontName, path)
    local font = {}
    local fontFile = io.open(path,"r")
    if not fontFile then return end    
    font.width = string.byte(fontFile:read(1))
    font.height = string.byte(fontFile:read(1))
    font.lineHeight = string.byte(fontFile:read(1))
    font.kerning = {}    

    -- Initialize font in memory
    for i=0, 128 do
        font[i] = {}
        font.kerning[i] = {}
    end
    
    local fontStart = string.byte(fontFile:read(1))
    -- Add each character
    for i=fontStart, 128-1 do
        local storedWidth = string.byte(fontFile:read(1))
	if storedWidth ~= 0 then font[i].width = storedWidth end
	local rectCount = string.byte(fontFile:read(1))
	for j=1, rectCount do
	    font[i][j] = {x=string.byte(fontFile:read(1)), y=string.byte(fontFile:read(1)), w=string.byte(fontFile:read(1)), h=string.byte(fontFile:read(1))}
	end
	-- Set kerning
	local kerningCount =  string.byte(fontFile:read(1))
	for j=1, kerningCount do
	    local subChar = string.byte(fontFile:read(1))
	    local kerningWidth = string.byte(fontFile:read(1))	 
	    font.kerning[i][subChar] = kerningWidth
	end
    end

    fonts[fontName] = font
end

function getWidth(text, fontName, size)
    size = size or 1
    local textWidth = 0
    for i=1, string.len(text) do
        if fonts[fontName].kerning[string.byte(text, i)][string.byte(text, i+1)] then
	    textWidth = textWidth + fonts[fontName].kerning[string.byte(text, i)][string.byte(text, i+1)]
    	else
	    textWidth = textWidth + (fonts[fontName][string.byte(text, i)].width or fonts[fontName].width)
	end    	
    end
    return textWidth * size
end

function drawCenteredText(text, y, fontName, size, color)
    local startX = (128 - getWidth(text, fontName, size)) / 2
    drawText(text, startX, y, fontName, size, color)
end

fonts = {}

loadFont("overkern", "fonts/overkern.fnt")

clear(BLACK)

-- Turn on the display
writePin(LCD_BL, ON)
writeReg(0x29)

local printText = "Initiating boot sequence..."

for i=1, string.len(printText) do
    drawText(string.sub(printText, 1, i), 0, 0, "overkern", 1, GREEN)
    delay(50)
end

while true do
    writePin(47, ON)
    delay(1000)
    writePin(47, OFF)
    delay(1000)	
end