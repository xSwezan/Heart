---
outline: deep
---

# Creating sprites

Creating sprites in Heart is very simple,
Heart also gives you extra features that makes it easier to use the sprites in your game!

## Creating a sprite

To create a sprite, you can call the `Sprite.new` function
with the first parameter being the path to your image.

```lua
require("Heart")

local player = Sprite.new("path/to/your/sprite.png")
```

## Drawing a sprite

Drawing a sprite is as easy as calling `:Draw()` in the [love.draw](https://love2d.org/wiki/love.draw) function.

```lua
require("Heart")

local player = Sprite.new("path/to/your/sprite.png")

function love.draw()
    player:Draw()
end
```

## Configuring a sprite

Sprites have a lot of properties that can be changed to your liking!
Some of the properties include:
- `Position` - A `Vector2` defining the position in pixels of the sprite.
- `Size` - A `Vector2` defining the size in pixels of the sprite.
- `Scale` - A `Vector2` defining the scale of the sprite.
    This multiplies the size, meaning that a Scale of (1, 2) would make the sprite 2 times taller!
- `Rotation` - A number in degrees that defines the rotation of the sprite
- `AnchorPoint` - A `Vector2` that defines where the sprite should be pivoted from.
    (0, 0) being top left and (1, 1) being bottom right.
    The AnchorPoint changes where the sprite is: rotated from, scaled from, and positioned from.
    **The default AnchorPoint is (0.5, 0.5)**.
- `Color` - A `Color` that defines the color of the sprite.

::: tip
Please refer to the [API](./api) for more information!
:::

```lua
require("Heart")

local player = Sprite.new("path/to/your/sprite.png")

function love.load()
    -- Position the player at (100, 100)
    player.Position = Vector2.new(100, 100)

    -- Align the sprite to the bottom center
    player.AnchorPoint = Sprite.ALIGN.BOTTOM_CENTER

    -- Tint player red
    player.Color = Color.fromRGB(255, 0, 0)
end
```
