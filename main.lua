-- Lua Script that contains the logic for the game

-- Importd
require("back")

-- Variables
local words = {}
-- 5x6 grid
local grid = makeGrid(5, 6)
-- Pointer to the current box
local coords = {1, 1}
-- Engine
local engine = Engine:new()

-- Game
function love.load()
    -- Load font
    love.graphics.setNewFont("font.ttf", 90)
    -- Read the words from the file
    words = read("words.txt")
    -- Grey background
    love.graphics.setBackgroundColor(love.math.colorFromBytes(40, 40, 40, 255))
    -- Window title
    love.window.setTitle("Wordle")
    -- Window size
    love.window.setMode(720, 800)
end

function love.update(dt)
end

function love.draw()
    for i = 1, #grid do
        for j = 1, #grid[i] do
            grid[i][j]:draw()
        end
    end
end
-- Get Keypress
function love.keypressed(key, char, isrepeat)
    if key == "escape" then
        love.event.quit()
    -- If the key is backspace decrement the pointer
    elseif key == "backspace" and coords[1] <= 6 then
        grid[coords[2]][coords[1]]:setText(" ")
        coords[1] = coords[1] - 1
    -- If the the grid is full and enter is pressed check if the answer is correct
    elseif key == "return" then
        -- Itterate through the row and combine the letters
        local guess = ""
        for i = 1, #grid[coords[1]] do
            guess = guess .. grid[coords[2]][i]:getText()
        end
        hint = engine:hint(guess)
        -- If guess === false
        if not hint then
            -- Clear row
            for i = 1, #grid[coords[2]] do
                grid[coords[2]][i]:setText(" ")
            end
            -- Set the pointer to the first box
            coords[1] = 1
            return 0
        elseif hint then
            for i = 1, #hint do
                if hint[i] == -1 then
                    lightGrey(grid[coords[2]][i])
                elseif hint[i] == 0 then
                    lightYellow(grid[coords[2]][i])
                elseif hint[i] == 1 then
                    lightGreen(grid[coords[2]][i])
                end
            end
        end
    -- If the key is a letter save it in the box and increment the pointer
    elseif key:match("%a") and (coords[1] <= #grid[1]) and not (key == "backspace" or key == "return") then
        grid[coords[2]][coords[1]]:setText(key)
        coords[1] = coords[1] + 1
        -- Warp to the next row if the pointer is at the end of the row
        if coords[1] > #grid[1] then
            coords[1] = 1
            coords[2] = coords[2] + 1
        end
    end
end