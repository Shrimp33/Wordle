-- Create Box class
Box = {}
-- Constructor
function Box:new(x, y, w, h, size, rgba)
    local box = {
        x = x,
        y = y,
        w = w,
        h = h,
        text = "",
        size = size,
        rgba = rgba
    }
    setmetatable(box, {__index = Box})
    return box
end
-- Draw the box
function Box:draw()
    -- Draw the box
    love.graphics.setColor(love.math.colorFromBytes(self.rgba))
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    -- Draw the text
    love.graphics.setColor(love.math.colorFromBytes(255, 255, 255, 255))
    love.graphics.print(self.text, math.floor(self.x + self.w/5), math.floor(self.y + self.h/20), 0, self.size)
    -- Draw the border
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end
-- Change text of the box
function Box:setText(text)
    self.text = text
end
-- Change color of the box
function Box:setColor(rgba)
    self.rgba = rgba
end
-- Get the text of the box
function Box:getText()
    return self.text
end
-- Get the color of the box
function Box:getColor()
    return self.rgba
end
-- End of Box class


-- Util

-- Read all the lines in a file and return them as a table
function read(file)
    local f = io.open(file, "r")
    local t = {}
    for line in f:lines() do
        upper = line:upper()
        table.insert(t, upper)
    end
    f:close()
    return t
end
-- Make a grid of boxes
function makeGrid(w, h)
    local grid = {}
    for i = 1, h do
        grid[i] = {}
        for j = 1, w do
            grid[i][j] = Box:new(j * 100, i * 100, 100, 100, 1, {50, 50, 50, 255})
        end
    end
    return grid
end
-- Change the box to light green
function lightGreen(box)
    box.rgba = {50, 255, 50, 150}
end
-- Change the box to light yellow
function lightYellow(box)
    box.rgba = {255, 255, 50, 150}
end
-- Change the box to light grey
function lightGrey(box)
    box.rgba = {50, 50, 50, 150}
end
-- Pick a random word
function pickWord(words)
    return words[love.math.random(1, #words)]
end

-- End of util

-- Create Engine class that contains the logic
Engine = {}
-- Constructor
function Engine:new()
    local engine = {
        grid = makeGrid(5, 6),
        words = read("words.txt"),
        answer = pickWord(read("words.txt"))
    }
    setmetatable(engine, {__index = Engine})
    return engine
end
-- If guess is in words
function Engine:guess(guess)
    for i = 1, #self.words do
        if self.words[i] == guess then
            return true
        end
    end
    return false
end
-- Gives hints
function Engine:hint(guess)
    local regiestered = {}
    for i = 1, #guess do
        if guess:sub(i, i) == self.answer:sub(i, i) then
            regiestered[i] = 0
        end
        for j = 1, #self.answer do
            if guess:sub(i, i) == self.answer:sub(j, j) then
                if not regiestered[j] then
                    regiestered[j] = 1
                end
            end
        end
    end
    for i = 1, #regiestered do
        if regiestered[i] < 0 then
            regiestered[i] = -1
        end
    end
    return regiestered
end
-- Check the guess
function Engine:check(guess)
    if self.guess(guess) then
        return self.hit(guess)
    else
        return false
    end
end