-- Profiler by https://github.com/Timmy-the-nobody

local os = os
local debug = debug
local string = string
local collectgarbage = collectgarbage

Profiler = Profiler or {}

local bAuditInternal = false        -- Set to true to audit internal functions
local fExecTimeThreshold = 0.00025   -- In seconds (0.0025 = 2.5 milliseconds)

local tIgnoredFuncs = {
    ["for iterator"] = true
}

local tIgnoredSource = {}
tIgnoredSource["=[C]"] = true

if not bAuditInternal then
    tIgnoredSource["INTERNAL - Package Lua Implementation"] = true
end

local function profilerHook(sEvent)
    if (sEvent ~= "call") then return end

    local fStartTime = os.clock()   -- Record the start time
    local iCurLevel = 2             -- Starting level above the profilerHook function
    local sCurSource

    while true do
        local tInfo = debug.getinfo(iCurLevel, "Sl")
        if not tInfo then break end
        if not tIgnoredSource[tInfo.source] then
            sCurSource = tInfo.source
            break
        end
        iCurLevel = iCurLevel + 1
    end

    debug.sethook(function()
        local fElapsedTime = os.clock() - fStartTime
        if (fElapsedTime > fExecTimeThreshold) then             -- Check if execution time is greater than the threshold
            local tCaller = debug.getinfo(2, "nSl") or {}       -- Get function info
            local sFuncName = (tCaller.name or "anonymous")     -- Get function name

            if not tIgnoredFuncs[sFuncName] then
                local tSourceInfo = debug.getinfo(4, "S") or {}     -- Get source info
                local sSrcPath = tSourceInfo.source or "unknown"    -- Get source path

                local msg = string.format("[TProfiler] Function '%s' [%s ms]\ncalled from '%s'", sFuncName, (fElapsedTime * 1000), sSrcPath)
                Console.Warn(msg)
            end
        end
        debug.sethook(profilerHook, "c") -- Reset the hook
    end, "return")
end

---`🔸 Client`<br>`🔹 Server`<br>
---Starts the profiler
---
function Profiler.Start()
    debug.sethook(profilerHook, "c")
end

---`🔸 Client`<br>`🔹 Server`<br>
---Stops the profiler
---
function Profiler.Stop()
    debug.sethook()
end

---`🔸 Client`<br>`🔹 Server`<br>
---Benchmark a function for performance
---@param sName string @The name of the benchmark
---@param iAmount number @The amount of times to benchmark
---@param fnInput function @The function to benchmark
---@param ... any @The arguments to pass to the function
---@return number @The benchmarked time in milliseconds
---
function Profiler.Benchmark(sName, iAmount, fnInput, ...)
    collectgarbage()

    local fStartTime = os.clock()
    for _ = 1, iAmount do
        fnInput(...)
    end

    return (os.clock() - fStartTime) * 1000
end

---`🔸 Client`<br>`🔹 Server`<br>
---Returns the current memory usage of the Lua VM
---@return number @The current memory usage in KB
---
function Profiler.GetMemoryUsage()
    collectgarbage()
    return collectgarbage("count")
end

Console.RegisterCommand("profiler_start", Profiler.Start, "Starts the profiler")
Console.RegisterCommand("profiler_stop", Profiler.Stop, "Stops the profiler")
