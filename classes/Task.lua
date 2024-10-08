Task = {}
local tasks = {}
local nextTaskId = 0

local function addTask(callback, delay, args)
    nextTaskId = nextTaskId + 1

    table.insert(tasks, {
        id = nextTaskId,
        co = coroutine.create(function() callback(unpack(args)) end),
        delay = delay or 0,
        startTime = love.timer.getTime(),
        canceled = false
    })

    return nextTaskId
end

function Task.spawn(callback, ...)
    local args = {...}
    local co = coroutine.create(function() callback(unpack(args)) end)

    local success, err = coroutine.resume(co)
    if not (success) then
        print("Error in task: " .. err)
    end

    if (coroutine.status(co) ~= "dead") then
        nextTaskId = nextTaskId + 1
        table.insert(tasks, {
            id = nextTaskId,
            co = co,
            delay = 0,
            startTime = love.timer.getTime(),
            canceled = false
        })
        return nextTaskId
    end

    return nil
end

function Task.delay(delay, callback, ...)
    return addTask(callback, delay, {...})
end

function Task.wait(seconds)
    local start = love.timer.getTime()
    while (love.timer.getTime() - start < (seconds or 0)) do
        coroutine.yield()
    end
end

function Task.cancel(taskId)
    for i = #tasks, 1, -1 do
        if (tasks[i].id == taskId) then
            tasks[i].canceled = true
            break
        end
    end
end

function Task.update(dt)
    for i = #tasks, 1, -1 do
        local task = tasks[i]
        local currentTime = love.timer.getTime()

        if (task.canceled) then
            table.remove(tasks, i)
        elseif (currentTime - task.startTime >= task.delay) then
            local success, err = coroutine.resume(task.co)
            if not (success) then
                print("Error in task: " .. err)
            end

            if (coroutine.status(task.co) == "dead") then
                table.remove(tasks, i)
            end
        end
    end
end
