module Main exposing (..)

import Browser
import Browser.Events
import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Json.Decode as Decode
import Snake exposing (Direction(..), Snake, initialSnake, move)
import HUD exposing (hud, GameStatus(..))
import Apple exposing (Apple)
import Time
import Common exposing (CellType(..), cellColor, isCollision)
import Apple exposing (Apple)
import Snake exposing (grow)
import Random



-- MAIN


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



-- MODEL


type alias Model =
    { snake : Snake,
      status: GameStatus,
      apple : Apple
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { snake = initialSnake, apple = { position = { x = 10, y = 10 } }
    , status = Playing }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Tick Time.Posix
    | ChangeDirection (Maybe Direction)
    | StopGame
    | AppleEaten
    | RegenerateApple (Int, Int)

isAppleEaten : Apple -> Snake -> Bool
isAppleEaten apple snake =
    isCollision apple.position (List.head snake.positions |> Maybe.withDefault { x = 0, y = 0 })

onAppleEaten : Model -> Model
onAppleEaten model = {model | snake = grow model.snake}

randomApple : Cmd Msg
randomApple =
    Random.generate RegenerateApple (Random.pair (Random.int 1 30) (Random.int 1 30))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        
        -- Move the snake every second
        Tick _ ->
            if isAppleEaten model.apple model.snake then update AppleEaten {   
              model | snake = move model.snake
              }
            else ({model | snake = move model.snake}, Cmd.none)

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

        StopGame ->
            ( { model | status = model.status |> \status -> if status == Playing then Paused else Playing }
            , Cmd.none
            )

        AppleEaten ->
            ( onAppleEaten model
            , Random.generate RegenerateApple (Random.pair (Random.int 4 28) (Random.int 4 28))
            )

        RegenerateApple (x, y) ->
            ( { model | apple = {
                position = { x = x, y = y }
            } }
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

        " " ->
            StopGame

        _ ->
            ChangeDirection Nothing



-- VIEW


cell : CellType -> Int -> Int -> Html Msg
cell cellType posX posY =
    div
        [ style "background" (cellColor cellType)
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
        (cell AppleCell model.apple.position.x model.apple.position.y ::
        (List.map (\pos -> cell SnakeCell pos.x pos.y) model.snake.positions))

view : Model -> Html Msg
view model =
    div [ style "display" "flex", style "flex-direction" "column", style "width" "30rem" ]
        [ board model, hud { health = model.snake.health, status = model.status } ]
