module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)

-- MAIN

main =
  Browser.sandbox { init = init, update = update, view = view }

-- MODEL

type alias Model = { length: Int, posX: Int, posY: Int }

init : Model
init = {
  length = 4
  , posX = 15
  , posY = 15 
  }


-- UPDATE

type Msg = Increment | Decrement

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment -> { model | length = model.length + 1 }
    Decrement -> { model | length = model.length - 1 }

-- VIEW
view : Model -> Html Msg
view model =
  div [ style "background" "#d3d3d3", style "width" "30rem", style "height" "30rem" ]
    [ 
    div [] [ text (String.fromInt model.length) ]
    ]