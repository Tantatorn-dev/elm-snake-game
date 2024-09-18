module Entity.Entity exposing (Position, Snake, initialSnake, moveHead)


type alias Position =
    { x : Int
    , y : Int
    }


type alias Snake =
    { health : Int
    , positions : List Position
    }



-- Return a list of positions for the snake based on the starting position and health
-- e.g. initSnakePos { x = 0, y = 0 } 3 = [ { x = 0, y = 0 }, { x = 0, y = 1 }, { x = 0, y = 2 } ]


initSnakePos : Position -> Int -> List Position
initSnakePos pos health =
    List.range 0 (health - 1)
        |> List.map (\i -> { pos | x = pos.x + i })


initialSnake : Snake
initialSnake =
    { health = 3
    , positions = initSnakePos { x = 15, y = 15 } 3
    }

moveHead : List Position -> List Position
moveHead pos =
    case pos of
        [] ->
            []

        head :: tail ->
            { head | x = head.x - 1 } :: tail