module Main exposing (..)

import Browser
import Browser.Events
import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Json.Decode as Decode
import Snake exposing (Direction(..), Snake, initialSnake, moveHead)
import Time



-- MAIN


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



-- MODEL


type alias Model =
    { snake : Snake
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { snake = initialSnake }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Tick Time.Posix
    | ChangeDirection Direction


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick _ ->
            ( { model
                | snake =
                    { health = model.snake.health
                    , positions = moveHead model.snake.positions model.snake.direction
                    , direction = Left
                    }
              }
            , Cmd.none
            )

        ChangeDirection direction ->
            ( { model
                | snake =
                    { health = model.snake.health
                    , positions = model.snake.positions
                    , direction = direction
                    }
              }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
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
            ChangeDirection Up

        "ArrowDown" ->
            ChangeDirection Down

        "ArrowLeft" ->
            ChangeDirection Left

        "ArrowRight" ->
            ChangeDirection Right

        _ ->
            ChangeDirection Left



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


view : Model -> Html Msg
view model =
    div [ style "background" "#d3d3d3", style "width" "30rem", style "height" "30rem", style "position" "relative" ]
        (List.map (\pos -> cell pos.x pos.y) model.snake.positions)
