module Common exposing (..)

type alias Position =
    { x : Int
    , y : Int
    }

type CellType = AppleCell | SnakeCell

cellColor : CellType -> String
cellColor t =
    case t of
        AppleCell ->
          "#FF0000"

        SnakeCell ->
          "#32cd32"

isCollision : Position -> Position -> Bool
isCollision p1 p2 =
    p1.x == p2.x && p1.y == p2.y
