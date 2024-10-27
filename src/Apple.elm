module Apple exposing (..)
import Common exposing (Position)

type alias Apple = {
    position: Position
 }

regenerateApple : Apple -> Apple
regenerateApple apple =
    { apple | position = { x = apple.position.x + 1, y = apple.position.y + 1 } }