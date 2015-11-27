module PusherApp where

import Signal
import Graphics.Element exposing(..)
import Html exposing(..)

port newMessage : Signal (String)

type alias Model =
  {
    messages : List String
  }

initialModel = { messages = ["Hello World"] }

update : String -> Model -> Model
update newMessage model =
  { model | messages = newMessage :: model.messages }

makeListItem: String -> Html
makeListItem message =
  li [] [text message]

view : Model -> Html
view model =
  ul
    []
    (List.map makeListItem model.messages)

-- SIGNALS

model : Signal Model
model =
  Signal.foldp update initialModel newMessage

main : Signal Html
main =
  Signal.map view model

