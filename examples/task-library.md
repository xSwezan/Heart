---
outline: deep
---

# Task library

The Task library can be used for scheduling threads in an easy manner.
The Task library works almost identically to the one Roblox has,
but with some tweaks and not as many functions.

## Simple usage

### Task.wait

The `wait` function yields the thread for the specified amount of seconds.

```lua{4}
require("Heart")

print(1)
Task.wait(1)
print(2) -- Runs after 1 second
```

### Task.spawn

The `spawn` function creates a new thread and runs the provided callback function.

```lua{5}
require("Heart")

print(1)

Task.spawn(function()
    print(2)
    Task.wait(1)
    print(4)
end)

print(3)
```

### Task.delay

The `delay` function creates a new thread an runs the callback function after the specified time.

```lua{5}
require("Heart")

print(1)

Task.delay(1, function()
    print(3) -- Runs after 1 second
end)

print(2)
```

### Task.cancel

The `cancel` function can be used to cancel threads from running.

```lua{14}
require("Heart")

print(1)

local thread = Task.delay(1, function()
    print(3)
    Task.wait(2)
    print(4) -- This wont run
end)

print(2)

Task.wait(2)
Task.cancel(thread) -- Cancel thread after 2 seconds
```

::: tip
When using `task.delay` or `task.spawn` you can send arguments after the function,
meaning you can do stuff in one line.

```lua
local thread = Task.delay(1, function()
    -- Do something
end)

Task.delay(2, task.cancel, thread) -- Cancel thread after 2 seconds without yielding
```
:::
