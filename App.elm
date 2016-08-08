port module PusherApp exposing (..)

import Html exposing (..)
import Html.App as App
import Task exposing (Task)
import Http
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Json.Decode as JSDecode
import Json.Encode as JSEncode


type alias Model =
    { messages : List String
    , field : String
    }


type Msg
    = NoOp
    | NewMessage String
    | SendMessage
    | UpdateField String


main =
    App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


initialModel =
    { messages = [ "Hello World" ], field = "" }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


port newMessage : (String -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    newMessage NewMessage


jsonBody : String -> String
jsonBody str =
    JSEncode.encode 0
        (JSEncode.object [ ( "text", JSEncode.string str ) ])


httpPostMessage : String -> Task Http.Error String
httpPostMessage str =
    Http.fromJson JSDecode.string
        <| Http.send Http.defaultSettings
            { verb = "POST"
            , headers =
                [ ( "Content-Type", "application/json" )
                , ( "Accept", "application/json" )
                ]
            , url = "http://localhost:4567/messages"
            , body = Http.string (jsonBody str)
            }


postJson : String -> Cmd Msg
postJson str =
    Task.perform (always NoOp) (always NoOp) (httpPostMessage str)


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        NewMessage string ->
            ( { model | messages = string :: model.messages }
            , Cmd.none
            )

        UpdateField string ->
            ( { model | field = string }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )

        SendMessage ->
            ( { model | field = "" }, postJson model.field )


makeListItem : String -> Html Msg
makeListItem message =
    li [] [ text message ]


makeUserForm : String -> Html Msg
makeUserForm field =
    div []
        [ input
            [ placeholder "Your chat message here"
            , onInput UpdateField
            , value field
            ]
            []
        , button [ onClick SendMessage ]
            [ text "Send" ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ makeUserForm model.field
        , ul []
            (List.map makeListItem model.messages)
        ]
