---
outline: deep
---

# Handling Input

Handling input in Heart is a breeze with the custom Input system.

## Detecting keyboard inputs

```lua
require("Heart")

function love.load()
    Input.InputDown({Input.KEYCODE.E}, function()
        print("E was pressed!")
    end)

    Input.InputUp({Input.KEYCODE.E}, function()
        print("E was released!")
    end)
end

function love.update(dt)
    Heart.update(dt)

    if (Input.IsDown(Input.KEYCODE.SPACE)) then
        print("Space is down!")
    end

    if (Input.IsAnyDown({Input.KEYCODE.D, Input.KEYCODE.RIGHT})) then
        print("D or right arrow is down!")
    end

    if (Input.AreAllDown({Input.KEYCODE.D, Input.KEYCODE.RIGHT})) then
        print("D and right arrow is down!")
    end
end
```

## Detecting mouse inputs

```lua
require("Heart")

function love.load()
    Input.MouseDown(Input.MOUSE.LEFT, function(position)
        print("LMB was pressed at " .. position .. "!")
    end)

    Input.MouseUp(Input.MOUSE.LEFT, function(position)
        print("LMB was released at " .. position .. "!")
    end)

    Input.MouseDoubleClick(Input.MOUSE.Left, function(position)
        print("LMB was double clicked at " .. position .. " !")
    end)

    Input.MouseMove(Input.MOUSE.Left, function(newPosition, delta)
        print("Mouse moved " .. delta .. " pixels and is now at " .. newPosition .. " !")
    end)
end

function love.update(dt)
    Heart.update(dt)
end
```

## Disconnecting events

All events that can be connected to; can also be connected by calling the returned function.

```lua{9}
require("Heart")

function love.load()
    local disconnect = Input.MouseDown(Input.MOUSE.LEFT, function(position)
        print("LMB was pressed!")
    end)

    -- Somewhere else --
    disconnect()
end

function love.update(dt)
    Heart.update(dt)
end
```

::: warning EXAMPLE
In this example we bind a `MouseDown` event and disconnect it after 5 clicks.

```lua
require("Heart")

local clicks = 0

function love.load()
    local disconnect
    disconnect = Input.MouseDown(Input.MOUSE.LEFT, function(position)
        print("LMB was pressed!")

        clicks = clicks + 1

        if (clicks == 5) then
            disconnect()
        end
    end)
end

function love.update(dt)
    Heart.update(dt)
end
```
:::