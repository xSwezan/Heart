---
outline: deep
---

# Rect2D

## Enums

### ALIGN
|Enum
|-
BOTTOM_CENTER
TOP_LEFT
TOP_CENTER
TOP_RIGHT
TOP_LEFT
TOP_LEFT
TOP_LEFT
TOP_LEFT
TOP_LEFT

## Properties
- ### Size <Badge type="tip">Vector2</Badge>
    Size in pixels.
- ### Scale <Badge type="tip">Vector2</Badge>
    Multiplies the size, meaning a Scale of `(1, 2)` would make the sprite 2 times taller.
- ### Position <Badge type="tip">Vector2</Badge>
    Position in pixels.
- ### AnchorPoint <Badge type="tip">Vector2</Badge>
    Defines where the sprite should be pivoted from. `(0, 0)` being top left and `(1, 1)` being bottom right. The AnchorPoint changes where the sprite is: rotated from, scaled from, and positioned from. The default AnchorPoint is `(0.5, 0.5)`.
- ### Rotation <Badge type="tip">number</Badge>
    Rotation in degrees.

## Methods
- ### Overlaps <Badge type="warning">Debug</Badge>
    Rotates the Rect2D to point at a position.
    ```lua
    Rect2D:Overlaps(
        other: Rect2D, -- The Rect2D to check the overlap with.
    ) -> nil
    ```
- ### Overlaps <Badge type="warning">Debug</Badge>
    Rotates the Rect2D to point at a position.
    ```lua
    Rect2D:Overlaps() -> nil
    ```
- ### Overlaps <Badge type="warning">Debug</Badge>
    Rotates the Rect2D to point at a position.
    ```lua
    Rect2D:Overlaps(
        other: Rect2D, -- The Rect2D to check the overlap with.
    ) -> nil
    ```