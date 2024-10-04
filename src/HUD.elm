module HUD exposing (hud, GameStatus(..))
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)

type GameStatus
    = Playing
    | Paused
    | GameOver

statusText : GameStatus -> String
statusText status =
    case status of
        Playing ->
           "Playing"

        GameOver ->
           "Game Over"

        Paused ->
           "Paused"

type alias HUDInfo =
    { health : Int,
      status : GameStatus
    }

hud : HUDInfo -> Html msg
hud info =
     div [style "display" "flex", style "justify-content" "space-between" ]
        [ div [] [text "Health: ", text (String.fromInt info.health)],
          div [] [text "Status: ", text (statusText info.status)]]