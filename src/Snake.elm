module Snake exposing (..)
import Common exposing (Position)


type Direction
    = Up
    | Down
    | Left
    | Right

type alias Snake =
    { health : Int
    , positions : List Position
    , direction : Direction
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
    , direction = Left
    }


addNewHead : List Position -> Direction -> List Position
addNewHead pos dir =
    case pos of
        [] ->
            []

        head :: _ ->
            { head | x = head.x + directionToDiff dir X, y = head.y + directionToDiff dir Y } :: pos


shiftBody : List Position -> List Position
shiftBody pos =
    case List.reverse pos of
        [] ->
            []

        _ :: rest ->
            List.reverse rest


move : Snake -> Snake
move snake =
    { snake
        | positions = shiftBody (addNewHead snake.positions snake.direction)
    }


type Axis
    = X
    | Y


directionToDiff : Direction -> Axis -> Int
directionToDiff direction axis =
    case direction of
        Up ->
            case axis of
                X ->
                    0

                Y ->
                    -1

        Down ->
            case axis of
                X ->
                    0

                Y ->
                    1

        Left ->
            case axis of
                X ->
                    -1

                Y ->
                    0

        Right ->
            case axis of
                X ->
                    1

                Y ->
                    0
