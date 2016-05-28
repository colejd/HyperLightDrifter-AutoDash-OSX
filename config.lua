-- Hyper Light Drifter autodash v0.1
-- MIT License
-- *** For use with HammerSpoon (paste this in your init.lua) ***
-- This program automates the timing needed to speed-dash in Hyper Light Drifter.
-- It worked on my copy of the game, all the way up to 850 in a row. It may be able to get more.
-- It may also have been a fluke! Try running this script a few times.

-- Set to true if you want to terminate the repeating function
local killLoop = false
-- Number of times we've pressed space
local reps = 0
-- Total number of times space will be pressed
local maxReps = 850

-- Delay is 140ms unless we're up to speed, then it's 125ms
local lowSpeedDelay_ms = 140
local highSpeedDelay_ms = 125

-- Brings the loop control variables back to their starting values. Use
-- when resetting or canceling the repeating action.
function reset()
    killit = false
    reps = 0
end

-- Duration: length of keypress in ms
function pressSpace(duration)
    hs.eventtap.event.newKeyEvent({}, "space", true):post()
    hs.timer.usleep(duration * 1000) --convert to microseconds
    hs.eventtap.event.newKeyEvent({}, "space", false):post()
    
    -- hs.timer.doAfter(duration / 1000, function() hs.eventtap.event.newKeyEvent({}, "space", false):post() end)
end 

-- Repeating function (calls itself after some number of milliseconds)
function doRepeats()
    if killLoop == true then
        hs.alert.show("Canceled")
        reset()
    else
        -- Delay is 140ms unless we're up to speed, then it's 125ms
        local delay_ms = lowSpeedDelay_ms
        if reps > 3 then
            delay_ms = highSpeedDelay_ms
        end
        
        -- It fails around the 675 mark.
        -- Subtract some delay for one frame at 650 to reduce any accumulated error.
        if reps == 650 then
            delay_ms = delay_ms - 5
        end
        
        -- Press space and call this function again if we have more reps to do
        pressSpace(140) --Hold the key down for 140 ms
        reps = reps + 1
        if reps < maxReps then
            hs.timer.doAfter(delay_ms / 1000, doRepeats)
        else
            hs.alert.show("Done")
            reset()
        end 
    end
end

-- [hotkey] Start repeat
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "S", function()
    if reps == 0 then
        hs.alert.show("Starting " .. maxReps .. " presses")
        killLoop = false
        doRepeats()
    else
        hs.alert.show("Already running")
    end
                 
end)

-- [hotkey] End repeat manually
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "C", function()
    if reps > 0 then
        killLoop = true
    else
        hs.alert.show("Not running")
    end
end)

                                                                                  
