-- GUI Stuff
buttons = {}
labels = {}
objects = {}
clickingButton = nil
hoverButton = nil
mouseMovedListeners = {}
mouseReleasedListeners = {}
mousePressedListeners = {}
textInputListeners = {}

-- GUI parameters
thickness = 3

-- Editing stuff
editingCharacterIndex = 0
mousePressed = false

-- Data stuff
valueSelected = 0
maxHeight = 7

-- General program stuff
state = "init"
lastWasEdit = true

-- Font information
fontHeight = 7
fontWidth = 6
fontCharacters = {}
fontKerning = {}
fontLineHeight = 10

-- Kerning stuff
compareIndex = 1

-- Save stuff
savePath = love.filesystem.getUserDirectory() .. "font.fnt"

-- Open stuff
openPath = savePath

-- Provides description to all the characters that can be edited
characterNames = {}
function loadCharacterNames()
   characterNames[1] = "Space"      
   characterNames[#characterNames+1] = "Exclamation Mark"
   characterNames[#characterNames+1] = "Double Quote"
   characterNames[#characterNames+1] = "Octothorpe"
   characterNames[#characterNames+1] = "Dollar Sign"
   characterNames[#characterNames+1] = "Percentage Symbol"
   characterNames[#characterNames+1] = "Ampersand"
   characterNames[#characterNames+1] = "Single Quote"
   characterNames[#characterNames+1] = "Opening Parentheses"
   characterNames[#characterNames+1] = "Closing Parentheses"
   characterNames[#characterNames+1] = "Asterix"
   characterNames[#characterNames+1] = "Plus"
   characterNames[#characterNames+1] = "Comma"
   characterNames[#characterNames+1] = "Dash"
   characterNames[#characterNames+1] = "Period"
   characterNames[#characterNames+1] = "Forward Slash"
   characterNames[#characterNames+1] = "Zero"
   characterNames[#characterNames+1] = "One"
   characterNames[#characterNames+1] = "Two"
   characterNames[#characterNames+1] = "Three"
   characterNames[#characterNames+1] = "Four"
   characterNames[#characterNames+1] = "Five"
   characterNames[#characterNames+1] = "Six"
   characterNames[#characterNames+1] = "Seven"
   characterNames[#characterNames+1] = "Eight"
   characterNames[#characterNames+1] = "Nine"
   characterNames[#characterNames+1] = "Colon"
   characterNames[#characterNames+1] = "Semicolon"
   characterNames[#characterNames+1] = "Less Than"
   characterNames[#characterNames+1] = "Equals"     
   characterNames[#characterNames+1] = "Greater Than"
   characterNames[#characterNames+1] = "Question Mark"
   characterNames[#characterNames+1] = "At sign"
   characterNames[#characterNames+1] = "Capital A"
   characterNames[#characterNames+1] = "Capital B"
   characterNames[#characterNames+1] = "Capital C"
   characterNames[#characterNames+1] = "Capital D"
   characterNames[#characterNames+1] = "Capital E"
   characterNames[#characterNames+1] = "Capital F"
   characterNames[#characterNames+1] = "Capital G"
   characterNames[#characterNames+1] = "Capital H"
   characterNames[#characterNames+1] = "Capital I"
   characterNames[#characterNames+1] = "Capital J"
   characterNames[#characterNames+1] = "Capital K"
   characterNames[#characterNames+1] = "Capital L"
   characterNames[#characterNames+1] = "Capital M"
   characterNames[#characterNames+1] = "Capital N"
   characterNames[#characterNames+1] = "Capital O"
   characterNames[#characterNames+1] = "Capital P"
   characterNames[#characterNames+1] = "Capital Q"
   characterNames[#characterNames+1] = "Capital R"
   characterNames[#characterNames+1] = "Capital S"
   characterNames[#characterNames+1] = "Capital T"
   characterNames[#characterNames+1] = "Capital U"
   characterNames[#characterNames+1] = "Capital V"
   characterNames[#characterNames+1] = "Capital W"
   characterNames[#characterNames+1] = "Capital X"
   characterNames[#characterNames+1] = "Capital Y"
   characterNames[#characterNames+1] = "Capital Z"
   characterNames[#characterNames+1] = "Opening Brace"
   characterNames[#characterNames+1] = "Back Slash"
   characterNames[#characterNames+1] = "Closing Brace"
   characterNames[#characterNames+1] = "Caret"
   characterNames[#characterNames+1] = "Underscore"
   characterNames[#characterNames+1] = "Forward Quote"
   characterNames[#characterNames+1] = "Lower a"
   characterNames[#characterNames+1] = "Lower b"
   characterNames[#characterNames+1] = "Lower c"
   characterNames[#characterNames+1] = "Lower d"
   characterNames[#characterNames+1] = "Lower e"
   characterNames[#characterNames+1] = "Lower f"
   characterNames[#characterNames+1] = "Lower g"
   characterNames[#characterNames+1] = "Lower h"
   characterNames[#characterNames+1] = "Lower i"
   characterNames[#characterNames+1] = "Lower j"
   characterNames[#characterNames+1] = "Lower k"
   characterNames[#characterNames+1] = "Lower l"
   characterNames[#characterNames+1] = "Lower m"
   characterNames[#characterNames+1] = "Lower n"
   characterNames[#characterNames+1] = "Lower o"
   characterNames[#characterNames+1] = "Lower p"
   characterNames[#characterNames+1] = "Lower q"
   characterNames[#characterNames+1] = "Lower r"
   characterNames[#characterNames+1] = "Lower s"
   characterNames[#characterNames+1] = "Lower t"
   characterNames[#characterNames+1] = "Lower u"
   characterNames[#characterNames+1] = "Lower v"
   characterNames[#characterNames+1] = "Lower w"
   characterNames[#characterNames+1] = "Lower x"
   characterNames[#characterNames+1] = "Lower y"
   characterNames[#characterNames+1] = "Lower z"
   characterNames[#characterNames+1] = "Opening Bracket"
   characterNames[#characterNames+1] = "Vertical Bar"
   characterNames[#characterNames+1] = "Closing Bracket"
   characterNames[#characterNames+1] = "Tilde"
   characterNames[#characterNames+1] = "Delete"   
end

function love.load()
   -- To disable interpolation, because it's ugly
   love.graphics.setDefaultFilter("nearest","nearest")
   
   -- Set font to the 8-bit one
   mainFont = love.graphics.newFont("urban.ttf", 16)   
   love.graphics.setFont(mainFont)

   -- Allow user to hold keys
   love.keyboard.setKeyRepeat(true)

   loadCharacterNames()

   -- Initialize font
   for i=0, 128-1 do
      fontCharacters[i] = {}
      fontKerning[i] = {}
      for j=0, fontHeight-1 do
	 fontCharacters[i][j] = {}
      end
   end

   -- Create listeners for mouse events
   mouseReleasedListeners[#mouseReleasedListeners + 1] = function(x, y)
      clickingButton = nil
      for i in iterateButtons() do
	 if x >= i.x and x <= i.x + i.width and y >= i.y and y <= i.y + i.height then
	    if i.action then
	       i.action()
	    end
	    return
	 end
      end
   end

   mousePressedListeners[#mousePressedListeners + 1] = function(x, y)
      for i in iterateButtons() do
	 if x >= i.x and x <= i.x + i.width and y >= i.y and y <= i.y + i.height then
	    clickingButton = i
	    return
	 end
      end
   end

   mouseMovedListeners[#mouseMovedListeners + 1] = function(x, y)
      if clickingButton then return end
      hoverButton = nil
      for i in iterateButtons() do
	 if x >= i.x and x <= i.x + i.width and y >= i.y and y <= i.y + i.height then
	    hoverButton = i
	    return
	 end
      end
   end

   -- Could be a for loop but I don't mind
   local buttonwidth = love.graphics.getWidth() / 8
   buttons[#buttons+1] = {text="Open",x=0,y=0,width=buttonwidth,height=40}
   buttons[#buttons].action = beginOpen
   
   buttons[#buttons+1] = {text="Save",x=buttonwidth,y=0,width=buttonwidth,height=40}
   buttons[#buttons].action = beginSave

   buttons[#buttons+1] = {text="Select",x=buttonwidth*2,y=0,width=buttonwidth,height=40}
   buttons[#buttons].action = beginSelect
   
   buttons[#buttons+1] = {text="View",x=buttonwidth*3,y=0,width=buttonwidth,height=40}
   buttons[#buttons].action = beginView   
   
   buttons[#buttons+1] = {text="Data",x=buttonwidth*4,y=0,width=buttonwidth,height=40}
   buttons[#buttons].action = beginData
	   
   buttons[#buttons+1] = {text="Edit",x=buttonwidth*5,y=0,width=buttonwidth,height=40}
   buttons[#buttons].action = beginEdit

   buttons[#buttons+1] = {text="Kerning",x=buttonwidth*6,y=0,width=buttonwidth,height=40}
   buttons[#buttons].action = beginKerning   
   
   buttons[#buttons+1] = {text="Exit",x=buttonwidth*7,y=0,width=buttonwidth,height=40}
   buttons[#buttons].action = function ()
      love.event.quit()
   end

   -- Start out in open mode 
   beginOpen()
end

-- Open a font
function openFont()
   -- TODO: Add error messages
   local fontFile = io.open(openPath,"r")
   if not fontFile then return end
   
   fontWidth = string.byte(fontFile:read(1))
   fontHeight = string.byte(fontFile:read(1))
   fontLineHeight = string.byte(fontFile:read(1))   
   local fontStart = string.byte(fontFile:read(1))
   
   -- Clear font info
   for i=0, 128-1 do
      fontCharacters[i] = {}
      fontKerning[i] = {}
      for j=0, fontHeight-1 do
	 fontCharacters[i][j] = {}
      end
   end
   
   -- Add each character
   for i=fontStart, 128-1 do
      local storedWidth = string.byte(fontFile:read(1))
      if storedWidth ~= 0 then fontCharacters[i].width = storedWidth end
      local rectCount = string.byte(fontFile:read(1))
      for j=1, rectCount do
	 setRect(i, string.byte(fontFile:read(1)), string.byte(fontFile:read(1)), string.byte(fontFile:read(1)), string.byte(fontFile:read(1)))
      end
      -- Set kerning
      local kerningCount =  string.byte(fontFile:read(1))
      for j=1, kerningCount do
	 local subChar = string.byte(fontFile:read(1))
	 local kerningWidth = string.byte(fontFile:read(1))	 
	 fontKerning[i][subChar] = kerningWidth
      end
   end
end

-- Set rect in font
function setRect(index, x, y, width, height)
   for i=y, y+height-1 do
      for j=x, x+width-1 do
	 fontCharacters[index][i][j] = true
      end
   end   
end

-- Save the font
function saveFont()
   -- TODO: Add error messages   
   local fontFile = io.open(savePath, "w")
   fontFile:write(string.char(fontWidth, fontHeight, fontLineHeight))
   -- Get starting offset
   local startOffset = 0
   local getStart = function()
      while startOffset < #fontCharacters do
	 local charWidth = fontCharacters[startOffset].width or fontWidth
	 for i=0, fontHeight-1 do
	    for j=0, fontWidth-1 do
	       if fontCharacters[startOffset][i][j] then return end	    
	    end
	 end      
	 startOffset = startOffset + 1
      end
   end
   getStart()
   fontFile:write(string.char(startOffset))
   -- For each character, write rectangle data
   for i=startOffset, #fontCharacters do
      -- Write width of character
      if fontCharacters[i].width == nil or fontCharacters[i].width == fontWidth then
	 fontFile:write(string.char(0))
      else
	 fontFile:write(string.char(fontCharacters[i].width))
      end      
      -- Separate into rectangles
      local rects = rectangularize(fontCharacters[i])
      fontFile:write(string.char(#rects))            
      for j=1, #rects do
	 fontFile:write(string.char(rects[j].x, rects[j].y, rects[j].width, rects[j].height))
      end
      -- Count the kerning table entries
      local kerningEntries = {}
      for j=0, #fontCharacters do
	 if fontKerning[i][j] then
	    kerningEntries[#kerningEntries + 1] = {j, fontKerning[i][j]} -- Subsequent character, width
	 end
      end
      fontFile:write(string.char(#kerningEntries))
      for j=1, #kerningEntries do
	 fontFile:write(string.char(kerningEntries[j][1], kerningEntries[j][2]))
      end
   end
   fontFile:close()
end

-- Convert font data into rectangle array
function rectangularize(character)
   local rects = {}
   local width = character.width or fontWidth
      -- Make temporary character to not erase font
   local tmpChar = {}
   for i=0, fontHeight-1 do
      tmpChar[i] = {}
      for j=0, width-1 do
	 tmpChar[i][j] = character[i][j]
      end
   end
   -- Locate pixel
   for y=0, fontHeight-1 do
      for x=0, width-1 do
	 if tmpChar[y][x] then
	    rects[#rects+1] = rectxy(tmpChar, x, y, width)
	 end	
      end
   end
   return rects
end

-- Find rectangle at x and y in character
function rectxy(character, x, y, width)   
   local rectWidth = 1
   character[y][x] = nil         
   while character[y][x+rectWidth] and x+rectWidth < width do
      character[y][x+rectWidth] = nil
      rectWidth = rectWidth + 1
   end
   local rectHeight = 1
   while y+rectHeight < fontHeight do
      for scanX=x, x+rectWidth-1 do
	 if character[y+rectHeight][scanX] == nil then
	    return {x=x, y=y, width=rectWidth, height=rectHeight}
	 end
      end
      -- Whole row is now part of rectangle now, so clear it
      for clearX=x, x+rectWidth-1 do
	 character[y+rectHeight][clearX] = nil
      end
      rectHeight = rectHeight + 1
   end
   return {x=x, y=y, width=rectWidth, height=rectHeight}   
end

-- Switch to view mode
function beginView()
   if state == "view" then return end
   if stateDestructor then stateDestructor() end
   state = "view"   

   local showFont = function ()
      local lines = {
	 "The quick brown fox",
	 "jumps over the lazy dog.",
	 "THE QUICK BROWN FOX",
	 "JUMPS OVER THE LAZY DOG.",
	 "\"Silence!\", said Kha'lud & B`en.",
	 "Email me at <sample@x.com>",
	 "1 - 6 + 5 / (3 * 6) % 4 ^ 6 = 19",
	 "~xX{[|/^|]}__$hadow$licer__{[^\\|]}Xx~",
	 "#0123456789"
      }
      
      local curY = 60
      local offsetY = 0

      for j=1, #lines do
	 local sentence = lines[j]
	 local curX = 20
	 local offsetX = 0
	 for i=1, string.len(sentence) do
	    drawCharacterSmall(fontCharacters[string.byte(sentence, i)], curX + offsetX, curY + offsetY)
	    if i < string.len(sentence) then
	       local charWidth
	       if fontKerning[string.byte(sentence, i)][string.byte(sentence, i+1)] then
		  charWidth = fontKerning[string.byte(sentence, i)][string.byte(sentence, i+1)]
	       else
		  charWidth = fontCharacters[string.byte(sentence, i)].width
		  if not charWidth or charWidth == 0 then
		     charWidth = fontWidth
		  end
	       end
	       offsetX = offsetX + (charWidth * 2)
	    end
	 end
	 offsetY = offsetY + fontLineHeight*2
      end
   end

   local delIndex = #objects + 1

   objects[delIndex] = showFont

   stateDestructor = function()
      objects[delIndex] = nil
   end
end

-- Switch to open mode
function beginOpen()
   if state == "open" then return end
   if stateDestructor then stateDestructor() end
   state = "open"

   local buttonWidth = 150
   local buttonHeight = 50

   local openButton = {
      text="Open Font",
      x=((love.graphics.getWidth() - buttonWidth) / 2),
      y=(love.graphics.getHeight() - 200),
      width=buttonWidth,
      height=buttonHeight,
      action=openFont
   }

   local delIndexButton = #buttons + 1

   buttons[delIndexButton] = openButton

   local pathLabel = function()
      if(mainFont:getWidth(openPath)) < 500 then
	 love.graphics.printf(openPath, (love.graphics.getWidth() - mainFont:getWidth(openPath)) / 2, 120, 500, "justify")
      else
	 love.graphics.printf(openPath, (love.graphics.getWidth() - 500) / 2, 120, 500, "justify")
      end
   end

   local delIndexObjects = #objects + 1

   objects[delIndexObjects] = pathLabel

   local pathEditListener = function (t)
      if string.len(openPath) < 512 then
	 openPath = openPath .. t
      end
   end

   local delIndexListeners = #textInputListeners + 1

   textInputListeners[delIndexListeners] = pathEditListener

   keyHandler = function(key)
      local len = string.len(openPath)
      if key == "backspace" and len > 0 then
	 openPath = string.sub(openPath, 1, len-1)
      end
   end   

   stateDestructor = function()
      keyHandler = nil
      textInputListeners[delIndexListeners] = nil
      objects[delIndexObjects] = nil
      buttons[delIndexButton] = nil
   end
end      

-- Switch to save mode
function beginSave()
   if state == "save" then return end
   if stateDestructor then stateDestructor() end
   state = "save"

   local buttonWidth = 150
   local buttonHeight = 50

   local saveButton = {
      text="Save Font",
      x=((love.graphics.getWidth() - buttonWidth) / 2),
      y=(love.graphics.getHeight() - 200),
      width=buttonWidth,
      height=buttonHeight,
      action=saveFont
   }

   local delIndexButton = #buttons + 1

   buttons[delIndexButton] = saveButton

   local pathLabel = function()
      if(mainFont:getWidth(savePath)) < 500 then
	 love.graphics.printf(savePath, (love.graphics.getWidth() - mainFont:getWidth(savePath)) / 2, 120, 500, "justify")
      else
	 love.graphics.printf(savePath, (love.graphics.getWidth() - 500) / 2, 120, 500, "justify")
      end
   end

   local delIndexObjects = #objects + 1

   objects[delIndexObjects] = pathLabel

   local pathEditListener = function (t)
      if string.len(savePath) < 512 then
	 savePath = savePath .. t
      end
   end

   local delIndexListeners = #textInputListeners + 1

   textInputListeners[delIndexListeners] = pathEditListener

   keyHandler = function(key)
      local len = string.len(savePath)
      if key == "backspace" and len > 0 then
	 savePath = string.sub(savePath, 1, len-1)
      end
   end

   stateDestructor = function()
      keyHandler = nil
      textInputListeners[delIndexListeners] = nil
      objects[delIndexObjects] = nil
      buttons[delIndexButton] = nil
   end
end      

-- Switch to select mode
function beginSelect()
   if state == "select" then return end
   if stateDestructor then stateDestructor() end            
   state = "select"
   local buttonsize = 40
   local selectButtons = {}

   for i=0, 7 do
      for j=0, 15 do
	 selectButtons[#selectButtons+1] = {
	    text=string.char(i * 16 + j),
	    x=((love.graphics.getWidth() - 16 * buttonsize) / 2) + (j * buttonsize),
	    y=((love.graphics.getHeight() - 8 * buttonsize) / 2) + (i * buttonsize),
	    width=buttonsize,
	    height=buttonsize,
	    action = function()
	       editingCharacterIndex = i * 16 + j
	       if lastWasEdit then
		  beginEdit()
	       else
		  beginKerning()
	       end
	    end
	 }
      end
   end

   local delIndexButtons = #buttons + 1

   buttons[delIndexButtons] = selectButtons
   
   stateDestructor = function()
      buttons[delIndexButtons] = nil
   end
end

-- Switch to data mode
function beginData()
   if state == "data" then return end
   if stateDestructor then stateDestructor() end
   state = "data"
   local dataLabels = {}
   dataLabels[#dataLabels + 1] = {text="Width: " .. fontWidth, centered=true, y=((love.graphics.getHeight() - 72) / 2)}
   dataLabels[#dataLabels + 1] = {text="Height: " .. fontHeight, centered=true, y=((love.graphics.getHeight() - 72) / 2) + 32}
   dataLabels[#dataLabels + 1] = {text="Line Height: " .. fontLineHeight, centered=true, y=((love.graphics.getHeight() - 72) / 2) + 64}   
   dataLabels[#dataLabels + 1] = {text="*", x=290, y=((love.graphics.getHeight() - 72) / 2) + (valueSelected * 32)}
   local delLabelsIndex = #labels + 1
   labels[delLabelsIndex] = dataLabels

   stateDestructor = function()
      keyHandler = nil
      labels[delLabelsIndex] = nil
   end

   keyHandler = function(key)
      if key == "tab" or key == "down" then
	 valueSelected = valueSelected + 1
	 if valueSelected == 3 then valueSelected = 0 end
	 dataLabels[#dataLabels] = {text="*", x=300, y=((love.graphics.getHeight() - 72) / 2) + (valueSelected * 32)}  
	 return
      elseif key == "up" then
	 valueSelected = valueSelected - 1
	 if valueSelected == -1 then valueSelected = 2 end
	 dataLabels[#dataLabels] = {text="*", x=300, y=((love.graphics.getHeight() - 72) / 2) + (valueSelected * 32)}  	 
	 return
      end
      
      local keyNum = tonumber(key)
      
      if keyNum then
	 if valueSelected == 0 and fontWidth < 10 then
	    fontWidth = fontWidth * 10 + keyNum
	 elseif valueSelected == 1 and fontHeight < 10 then
	    fontHeight = fontHeight * 10 + keyNum
	    -- Add more rows to the font if height increased
	    if fontHeight > maxHeight then
	       local prevMaxHeight = maxHeight
	       maxHeight = fontHeight
	       for i=0, 128-1 do
		  for j=prevMaxHeight, maxHeight-1 do
		     fontCharacters[i][j] = {}
		  end
	       end		  
	    end
	 elseif fontLineHeight < 10 then
	    fontLineHeight = fontLineHeight * 10 + keyNum	    
	 end
      elseif key == "backspace" then
	 if valueSelected == 0 then	    
	    fontWidth = math.floor(fontWidth / 10)
	 elseif valueSelected == 1 then
	    fontHeight = math.floor(fontHeight / 10)
	 else
	    fontLineHeight = math.floor(fontLineHeight / 10)
	 end
      end
      
      dataLabels[1].text = "Width: " .. fontWidth
      dataLabels[2].text = "Height: " .. fontHeight
      dataLabels[3].text = "Line Height: " .. fontLineHeight
   end
end

-- Switch to kerning mode
function beginKerning()
   if state == "kerning" then return end
   if stateDestructor then stateDestructor() end            
   state = "kerning"
   lastWasEdit = false
   
   local charName = {text=characterNames[editingCharacterIndex - 31] or "Special Character", centered=true, y=85}
   charName.text = charName.text .. " and "
   if characterNames[compareIndex - 31] then
      charName.text = charName.text .. characterNames[compareIndex - 31]
   else
      charName.text = charName.text .. "Special Character"
   end

   local delIndexLabels = #labels + 1
   
   labels[delIndexLabels] = charName

   local buttonsize = 40
   local selectButtons = {}

   for i=0, 7 do
      for j=0, 15 do
	 selectButtons[#selectButtons+1] = {
	    text=string.char(i * 16 + j),
	    x=((love.graphics.getWidth() - 16 * buttonsize) / 2) + (j * buttonsize),
	    y=((love.graphics.getHeight() - 8 * buttonsize) / 2) + (i * buttonsize) + 100,
	    width=buttonsize,
	    height=buttonsize,
	    action = function()
	       compareIndex = i * 16 + j
	       local selName = characterNames[editingCharacterIndex - 31] or "Special Character"
	       selName = selName .. " and "
	       if characterNames[compareIndex - 31] then
		  selName = selName .. characterNames[compareIndex - 31]
	       else
		  selName = selName .. "Special Character"
	       end	       
	       charName.text = selName
	    end
	 }
      end
   end

   selectButtons[#selectButtons+1] = {
      text="+",
      x=360,
      y=130,
      width=buttonsize,
      height=buttonsize,
      action = function()
	 if not fontKerning[editingCharacterIndex][compareIndex] then
	    if not fontCharacters[editingCharacterIndex].width then
	       fontKerning[editingCharacterIndex][compareIndex] = fontWidth + 1
	    else
	       fontKerning[editingCharacterIndex][compareIndex] = fontCharacters[editingCharacterIndex].width + 1
	    end
	 else
	    fontKerning[editingCharacterIndex][compareIndex] = fontKerning[editingCharacterIndex][compareIndex] + 1
	 end
      end
   }

   selectButtons[#selectButtons+1] = {
      text="-",
      x=360 + buttonsize,
      y=130,
      width=buttonsize,
      height=buttonsize,
      action = function()
	 if not fontKerning[editingCharacterIndex][compareIndex] then
	    if not fontCharacters[editingCharacterIndex].width then
	       fontKerning[editingCharacterIndex][compareIndex] = fontWidth - 1
	    else
	       fontKerning[editingCharacterIndex][compareIndex] = fontCharacters[editingCharacterIndex].width - 1
	    end
	 else
	    fontKerning[editingCharacterIndex][compareIndex] = fontKerning[editingCharacterIndex][compareIndex] - 1
	 end
      end      
   }

   local delIndexButtons = #buttons + 1

   buttons[delIndexButtons] = selectButtons

   local drawSpacing = function ()
      local curX = 85
      local curY = 130
      local charWidth
      if fontKerning[editingCharacterIndex][compareIndex] then
	 charWidth = fontKerning[editingCharacterIndex][compareIndex]
      else
	 charWidth = fontCharacters[editingCharacterIndex].width
	 if not charWidth or charWidth == 0 then
	    charWidth = fontWidth
	 end
      end
      drawCharacter(fontCharacters[editingCharacterIndex], curX, curY)
      drawCharacter(fontCharacters[compareIndex], curX + (3 * charWidth), curY)
   end

   local delIndexObjects = #objects + 1
   
   objects[delIndexObjects] = drawSpacing

   local drawCurrentSelected = function ()
      local i = selectButtons[compareIndex+1]
      love.graphics.rectangle("fill", i.x, i.y, i.width, i.height)	 
      love.graphics.setColor(0, 0, 0, 255)
      love.graphics.print(i.text, i.x + (i.width - mainFont:getWidth(i.text)) / 2,
			  i.y + ((i.height - mainFont:getHeight()) / 2))
      love.graphics.setColor(255, 255, 255, 255)	 	
   end

   local delIndexObjectsB = #objects + 1

   objects[delIndexObjects + 1] = drawCurrentSelected   
   
   stateDestructor = function()
      labels[delIndexLabels] = nil
      objects[delIndexObjects] = nil
      objects[delIndexObjectsB] = nil            
      buttons[delIndexButtons] = nil
   end
end

-- Switch to edit character mode
function beginEdit()
   if state == "edit" then return end
   if stateDestructor then stateDestructor() end
   state = "edit"
   lastWasEdit = true
   
   local charName = {text=characterNames[editingCharacterIndex - 31] or "Special Character", centered=true, y=85}
   local characterWidth = {text="Character Width: " .. (fontCharacters[editingCharacterIndex].width or fontWidth), centered=true, y=love.graphics.getHeight() - 100}
   local indicator = {text="*", x=275, y=love.graphics.getHeight() - 100}

   labels[#labels + 1] = charName
   labels[#labels + 1] = characterWidth
   labels[#labels + 1] = indicator

   -- Draw a grid fontwidth by fontheight cells wide

   local charGrid = function()

      local fontWidth = fontWidth
      if fontCharacters[editingCharacterIndex].width ~= nil and fontCharacters[editingCharacterIndex].width ~= 0 then
	 fontWidth = fontCharacters[editingCharacterIndex].width
      end

      local cellWidth, cellHeight
      if fontWidth > fontHeight then
	 cellWidth = 300 / fontWidth
	 cellHeight = cellWidth
      elseif fontWidth < fontHeight then
	 cellHeight = 300 / fontHeight
	 cellWidth = cellHeight      
      else
	 cellWidth, cellHeight = 300 / fontWidth, 300 / fontWidth
      end
      
      love.graphics.rectangle("fill", ((love.graphics.getWidth() - (fontWidth * cellWidth)) / 2), ((love.graphics.getHeight() - (fontHeight * cellHeight)) / 2), fontWidth * cellWidth + 1, fontHeight * cellHeight + 1)
      love.graphics.setColor(0, 0, 0, 255)
      for i=0, fontHeight-1 do
	 for j=0, fontWidth-1 do
	    if not fontCharacters[editingCharacterIndex][i][j] then
	       love.graphics.rectangle("fill", ((love.graphics.getWidth() - (fontWidth * cellWidth) - 2) / 2) + j * cellWidth + 2, ((love.graphics.getHeight() - (fontHeight * cellHeight - 2)) / 2) + i * cellHeight, cellWidth - 1, cellHeight - 1)
	    end
	 end
      end
      love.graphics.setColor(255, 255, 255, 255)      
   end

   local delObjectsIndex = #objects + 1

   objects[delObjectsIndex] = charGrid

   local pressListener = function(x, y)
      mousePressed = true
      local fontWidth = fontWidth
      if fontCharacters[editingCharacterIndex].width ~= nil and fontCharacters[editingCharacterIndex].width ~= 0 then
	 fontWidth = fontCharacters[editingCharacterIndex].width
      end

      local cellWidth, cellHeight
      if fontWidth > fontHeight then
	 cellWidth = 300 / fontWidth
	 cellHeight = cellWidth
      elseif fontWidth < fontHeight then
	 cellHeight = 300 / fontHeight
	 cellWidth = cellHeight      
      else
	 cellWidth, cellHeight = 300 / fontWidth, 300 / fontWidth
      end

      -- Left click for set, right for clear
      local mouseMode = nil
      if love.mouse.isDown(1) then
	 mouseMode = true
      elseif not love.mouse.isDown(2) then
	 return
      end
      
      for i=0, fontHeight-1 do
	 for j=0, fontWidth-1 do
	    if x >= ((love.graphics.getWidth() - (fontWidth * cellWidth) - 2) / 2) + j * cellWidth + 2 and
	       x <= ((love.graphics.getWidth() - (fontWidth * cellWidth) - 2) / 2) + j * cellWidth + cellWidth + 1 and
	       y >= ((love.graphics.getHeight() - (fontHeight * cellHeight - 2)) / 2) + i * cellHeight and
	       y <= ((love.graphics.getHeight() - (fontHeight * cellHeight - 2)) / 2) + i * cellHeight + cellHeight + 1 then
		  fontCharacters[editingCharacterIndex][i][j] = mouseMode
	    end
	 end
      end	      
   end

   local releaseListener = function(x, y)
      mousePressed = false
   end

   moveListener = function(x, y)
      if not mousePressed then return end
      pressListener(x, y)
   end         

   local pressListenerIndex = #mousePressedListeners + 1
   mousePressedListeners[pressListenerIndex] = pressListener
   local releasedListenerIndex = #mouseReleasedListeners + 1
   mouseReleasedListeners[releasedListenerIndex] = releaseListener
   local movedListenerIndex = #mouseMovedListeners + 1
   mouseMovedListeners[movedListenerIndex] = moveListener   
   
   stateDestructor = function()
      keyHandler =  nil
      mousePressed = false
      for i=1, #labels do
	 if labels[i] == charName or labels[i] == characterWidth or labels[i] == indicator then
	    labels[i] = nil
	 end
      end
      objects[delObjectsIndex] = nil
      mousePressedListeners[pressListenerIndex] = nil
      mouseReleasedListeners[releasedListenerIndex] = nil
      mouseMovedListeners[movedListenerIndex] = nil
   end

   keyHandler = function(key)
      local keyNum = tonumber(key)

      if fontCharacters[editingCharacterIndex].width and fontCharacters[editingCharacterIndex].width ~= 0 then
	 oldWidth = fontCharacters[editingCharacterIndex].width
      end
      
      if keyNum then
	 if not fontCharacters[editingCharacterIndex].width then fontCharacters[editingCharacterIndex].width = fontWidth end
	 if fontCharacters[editingCharacterIndex].width < 10 then
	    fontCharacters[editingCharacterIndex].width = fontCharacters[editingCharacterIndex].width * 10 + keyNum
	 end
      elseif key == "backspace" then
	 if not fontCharacters[editingCharacterIndex].width then fontCharacters[editingCharacterIndex].width = fontWidth end	 
	 fontCharacters[editingCharacterIndex].width = math.floor(fontCharacters[editingCharacterIndex].width / 10)
      else
	 return
      end

      if fontCharacters[editingCharacterIndex].width == 0 then
	 characterWidth.text = "Character Width: " ..  fontCharacters[editingCharacterIndex].width .. " (" .. fontWidth .. ")"
      else
	 characterWidth.text = "Character Width: " ..  fontCharacters[editingCharacterIndex].width
      end
   end   
end

function love.textinput(t)
   for i=1, #textInputListeners do
      if textInputListeners[i] then textInputListeners[i](t) end
   end
end

function love.mousereleased(x, y)
   for i=1, #mouseReleasedListeners do
      if mouseReleasedListeners[i] then mouseReleasedListeners[i](x, y) end
   end
end

function love.mousemoved(x, y)
   for i=1, #mouseMovedListeners do
      if mouseMovedListeners[i] then mouseMovedListeners[i](x, y) end
   end
end

function love.mousepressed(x, y)
   for i=1, #mousePressedListeners do
      if mousePressedListeners[i] then mousePressedListeners[i](x, y) end
   end
end

function love.keypressed(key)
   if keyHandler then keyHandler(key) end
end

function love.draw()
   drawButtons(buttons)
   drawLabels(labels)
   drawMode()
   for i=1, #objects do
      if objects[i] then objects[i]() end
   end
end

function drawButtons(buttons)
   for i in iterateButtons() do
      if i == clickingButton then
	 love.graphics.setColor(255, 255, 255, 255)
	 love.graphics.rectangle("fill", i.x, i.y, i.width, i.height)	 
	 love.graphics.setColor(0, 0, 0, 255)
	 love.graphics.print(i.text, i.x + ((i.width - mainFont:getWidth(i.text)) / 2),
			     i.y + ((i.height - mainFont:getHeight()) / 2))
	 love.graphics.setColor(255, 255, 255, 255)	 
      elseif i == hoverButton then
	 love.graphics.rectangle("fill", i.x, i.y, i.width, i.height)
	 love.graphics.setColor(0, 0, 0, 255)
	 love.graphics.rectangle("fill", i.x + thickness, i.y + thickness, i.width - (thickness*2), i.height - (thickness*2))	 
	 love.graphics.setColor(255, 255, 255, 100)
	 love.graphics.rectangle("fill", i.x + thickness, i.y + thickness, i.width - (thickness*2), i.height - (thickness*2))
	 love.graphics.setColor(255, 255, 255, 255)
	 love.graphics.print(i.text, i.x + ((i.width - mainFont:getWidth(i.text)) / 2),
			     i.y + ((i.height - mainFont:getHeight()) / 2))	 
      else
	 love.graphics.rectangle("fill", i.x, i.y, i.width, i.height)
	 love.graphics.setColor(0, 0, 0, 255)
	 love.graphics.rectangle("fill", i.x + thickness, i.y + thickness, i.width - (thickness*2), i.height - (thickness*2))
	 love.graphics.setColor(255, 255, 255, 255)
	 love.graphics.print(i.text, i.x + ((i.width - mainFont:getWidth(i.text)) / 2),
			     i.y + ((i.height - mainFont:getHeight()) / 2))
      end
   end
end

function drawLabels(labels)
   for i in iterateLabels() do
      if i.centered then
	 printCenteredX{text=i.text, y=i.y}
      else
	 love.graphics.print(i.text, i.x, i.y)
      end
   end
end

function drawCharacter(character, x, y)
   local charWidth = character.width
   if not charWidth or charWidth == 0 then charWidth = fontWidth end
   for i=0, fontHeight-1 do
      -- If the row exists
      if character[i] then
	 -- Draw each column
	 for j=0, charWidth-1 do
	    if character[i][j] then
	       love.graphics.rectangle("fill", x + j*3, y + i*3, 3, 3)
	    end
	 end
      end
   end
end

function drawCharacterSmall(character, x, y)
   local charWidth = character.width
   if not charWidth or charWidth == 0 then charWidth = fontWidth end
   for i=0, fontHeight-1 do
      -- If the row exists
      if character[i] then
	 -- Draw each column
	 for j=0, charWidth-1 do
	    if character[i][j] then
	       love.graphics.rectangle("fill", x + j*2, y + i*2, 2, 2)
	    end
	 end
      end
   end
end

-- The workhorse behind iterateButtons
function recursiveIterator()
   -- Beyond last index of current layer
   if _layerIndex[#_layers] > #_layers[#_layers] then
      -- If current layer is topmost end
      if #_layers == 1 then return nil
      -- Otherwise go up one layer
      else
	 _layers[#_layers] = nil
	 _layerIndex[#_layerIndex] = nil
	 return recursiveIterator()
      end
   else
      -- If item at index is a deeper layer itself
      if _layers[#_layers][_layerIndex[#_layers]][1] then
	 -- Increment index on current layer
	 _layerIndex[#_layers] = _layerIndex[#_layers] + 1
	 -- Move last layer to deeper layer at index
	 _layers[#_layers + 1] = _layers[#_layers][_layerIndex[#_layers] - 1]
	 -- Start index for deeper layer at one
	 _layerIndex[#_layers] = 1
	 -- Return first element of deeper layer
	 return recursiveIterator()
      -- Just another item, return it and continue
      else
	 _layerIndex[#_layers] = _layerIndex[#_layers] + 1
	 return _layers[#_layers][_layerIndex[#_layers] - 1]
      end
   end      	    
end

function iterateButtons()
   _layers = {buttons}
   _layerIndex = {1}
   return recursiveIterator
end

function iterateLabels()
   _layers = {labels}
   _layerIndex = {1}
   return recursiveIterator
end

function drawMode()
   for i in iterateButtons() do   
      if string.lower(i.text) == state then
	 love.graphics.setColor(255, 255, 255, 255)
	 love.graphics.rectangle("fill", i.x, i.y, i.width, i.height)	 
	 love.graphics.setColor(0, 0, 0, 255)
	 love.graphics.print(i.text, i.x + ((i.width - mainFont:getWidth(i.text)) / 2),
			     i.y + ((i.height - mainFont:getHeight()) / 2))
	 love.graphics.setColor(255, 255, 255, 255)	 	 
	 return
      end
   end   
end

function printCenteredX(options)
   love.graphics.print(
      options.text,
      (love.graphics.getWidth() - mainFont:getWidth(options.text)) / 2,
      options.y,
      options.r and (options.r * math.pi/180) or 0, -- Convert radians to degrees.
      options.sx or nil,
      options.sy or nil,
      options.ox or nil,
      options.oy or nil)
end
