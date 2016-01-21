module PusherApp (..) where

import Signal
import Graphics.Element exposing (..)
import Html exposing (..)
import Task exposing (Task)
import Http
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, targetValue, on)
import Json.Decode as JSDecode
import Json.Encode as JSEncode


port newMessage : Signal String
type alias Model =
    { messages : List String
    , field : String
    }


type Action
    = NoOp
    | NewMessage String
    | SendMessage
    | UpdateField String


actions : Signal.Mailbox Action
actions =
    Signal.mailbox NoOp


initialModel =
    { messages = [ "Hello World" ], field = "" }


jsonBody : String -> String
jsonBody str =
    JSEncode.encode
        0
        (JSEncode.object
            [ ( "text", JSEncode.string str ) ]
        )


postJson : String -> Task () ()
postJson str =
    silenceTask
        <| Http.send
            Http.defaultSettings
            { verb = "POST"
            , headers =
                [ ( "Content-Type", "application/json" )
                , ( "Accept", "application/json" )
                ]
            , url = "http://localhost:5000/messages"
            , body = Http.string (jsonBody str)
            }


update : Action -> ( Model, Task () () ) -> ( Model, Task () () )
update action ( model, _ ) =
    case action of
        NewMessage string ->
            ( { model | messages = string :: model.messages }
            , Task.succeed ()
            )

        UpdateField string ->
            ( { model | field = string }, Task.succeed () )

        NoOp ->
            ( model, Task.succeed () )

        SendMessage ->
            ( { model | field = "" }, postJson model.field )


makeListItem : String -> Html
makeListItem message =
    li [] [ text message ]


makeUserForm : Signal.Address Action -> Html
makeUserForm address =
    div
        []
        [ input
            [ placeholder "Your chat message here"
            , on "input" targetValue (Signal.message address << UpdateField)
            ]
            []
        , button
            [ onClick address SendMessage ]
            [ text "Send" ]
        ]


view : Signal.Address Action -> Model -> Html
view address model =
    div
        []
        [ makeUserForm address
        , ul
            []
            (List.map makeListItem model.messages)
        ]



-- SIGNALS


newMessageSignal : Signal Action
newMessageSignal =
    Signal.map (\str -> (NewMessage str)) newMessage


inputSignal : Signal Action
inputSignal =
    Signal.mergeMany [ actions.signal, newMessageSignal ]


effectsAndModel : Signal ( Model, Task () () )
effectsAndModel =
    Signal.foldp update ( initialModel, Task.succeed () ) inputSignal


modelSignal : Signal Model
modelSignal =
    Signal.map fst effectsAndModel


tasksSignal : Signal (Task () ())
tasksSignal =
    Signal.map snd effectsAndModel


silenceTask : Task x a -> Task () ()
silenceTask task =
    task
        |> Task.map (\_ -> ())
        |> Task.mapError (\_ -> ())


port tasks : Signal (Task () ())
port tasks =
    tasksSignal


main : Signal Html
main =
    Signal.map (view actions.address) modelSignal
