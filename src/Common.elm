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