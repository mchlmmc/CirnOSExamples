print "99 BOTTLES OF BEER:"

_ones = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine"}
_teens = {"eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"}
_tens = {"ten", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"}

function wordify(number)
   -- One and zero
   if number == 0 then return "zero" end
   if number == 1 then return "one" end
   -- Teens
   if number > 10 and number < 20 then return _teens[number - 10] end
   -- Everything else
   local word = ""
   if number >= 10 then
      local tenVal = math.floor(number / 10)
      word = _tens[tenVal]
      number = number - (tenVal * 10)
      if number == 0 then return word
      else
	 word = word .. "-"
      end
   end
   word = word .. _ones[number]
   return word
end

function quantize(amount, unit, plural)
   local quantized = ""
   if amount == 1 then
      return "one " .. unit
   -- For words like cacti
   elseif plural then
      return wordify(amount) .. " " .. plural 
   else
      return wordify(amount) .. " " .. unit .. "s"
   end
end

for i=99, 0, -1 do
   local beerAmount = quantize(i, "bottle")
   local upperAmount = beerAmount:sub(1, 1):upper() .. beerAmount:sub(2)
   print(upperAmount .. " of beer on the wall,")
   print(upperAmount .. " of beer!")
   print("You take one down, pass it around,")
   print("You got " .. beerAmount .. " of beer on the wall!")
   print()
end

-- Halt forever
while true do end
