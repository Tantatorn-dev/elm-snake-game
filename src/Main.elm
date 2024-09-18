module Main exposing (..)

import Browser
import Entity.Entity exposing (Snake, initialSnake, moveHead)
import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Time



-- MAIN


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



-- MODEL


type alias Model =
    { 
        snake : Snake
    }


init : () -> (Model, Cmd Msg)
init _ =
    (
        { snake = initialSnake }
        , Cmd.none
    )



-- UPDATE


type Msg
    = Increment
    | Decrement
    | Tick Time.Posix


update :  Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            (
                { model | snake = { health = model.snake.health + 1, positions = [] } },
                Cmd.none
            )

        Decrement ->
            (
                { model | snake = { health = model.snake.health - 1, positions = [] } },
                Cmd.none
            )

        Tick _   ->
            (
                { model | snake = { health = model.snake.health, positions = (moveHead model.snake.positions) } },
                Cmd.none
            )
        
-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every 1000 Tick

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
