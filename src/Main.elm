module Main exposing (..)

import Browser
import Entity.Entity exposing (Snake, initialSnake)
import Html exposing (Html, div)
import Html.Attributes exposing (style)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { snake : Snake }


init : Model
init =
    { snake = initialSnake
    }



-- UPDATE


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | snake = { health = model.snake.health + 1, positions = [] } }

        Decrement ->
            { model | snake = { health = model.snake.health - 1, positions = [] } }



-- VIEW

cell : Int -> Int -> Html Msg
cell posX posY =
    div [ style "background" "#32cd32", style "width" "1rem", style "height" "1rem",
     style "border" "1px solid #fff",
     style "position" "absolute", 
     style "left" (String.fromInt posX ++ "rem"), 
     style "top" (String.fromInt posY ++ "rem") ] [ ]

view : Model -> Html Msg
view model =
    div [ style "background" "#d3d3d3", style "width" "30rem", style "height" "30rem", style "position" "relative" ]
        (List.map (\pos -> cell pos.x pos.y) model.snake.positions)
