module Main exposing (..)

import Browser
import Entity.Entity exposing (Snake, initialSnake)
import Html exposing (Html, div, text)
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


view : Model -> Html Msg
view model =
    div [ style "background" "#d3d3d3", style "width" "30rem", style "height" "30rem" ]
        []
