module Main exposing (..)

import Browser
import Browser.Events
import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Json.Decode as Decode
import Snake exposing (Direction(..), Snake, initialSnake, move)
import HUD exposing (hud, GameStatus(..))
import Time



-- MAIN


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



-- MODEL


type alias Model =
    { snake : Snake,
      status: GameStatus
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { snake = initialSnake, status = Playing }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Tick Time.Posix
    | ChangeDirection (Maybe Direction)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick _ ->
            ( { model
                | snake = move model.snake
              }
            , Cmd.none
            )

        ChangeDirection direction ->
            ( { model
                | snake =
                    { health = model.snake.health
                    , positions = model.snake.positions
                    , direction = direction |> Maybe.withDefault model.snake.direction
                    }
              }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Time.every 1000 Tick
        , Browser.Events.onKeyDown keyDecoder
        ]


keyDecoder : Decode.Decoder Msg
keyDecoder =
    Decode.map toDirection (Decode.field "key" Decode.string)


toDirection : String -> Msg
toDirection str =
    case str of
        "ArrowUp" ->
            ChangeDirection (Just Up)

        "ArrowDown" ->
            ChangeDirection (Just Down)

        "ArrowLeft" ->
            ChangeDirection (Just Left)

        "ArrowRight" ->
            ChangeDirection (Just Right)

        _ ->
            ChangeDirection Nothing



-- VIEW


cell : Int -> Int -> Html Msg
cell posX posY =
    div
        [ style "background" "#32cd32"
        , style "width" "1rem"
        , style "height" "1rem"
        , style "border" "1px solid #fff"
        , style "position" "absolute"
        , style "left" (String.fromInt posX ++ "rem")
        , style "top" (String.fromInt posY ++ "rem")
        ]
        []

board : Model -> Html Msg
board model =
    div [ style "background" "#d3d3d3", style "width" "30rem", style "height" "30rem", style "position" "relative" ]
        (List.map (\pos -> cell pos.x pos.y) model.snake.positions)

view : Model -> Html Msg
view model =
    div [ style "display" "flex", style "flex-direction" "column", style "width" "30rem" ]
        [ board model, hud { health = model.snake.health, status = model.status } ]
