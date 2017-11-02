module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode


--Model


type alias Model =
    { trumpMsg : String
    }


initModel : ( Model, Cmd Msg )
initModel =
    ( { trumpMsg = "" }, Cmd.none )



--Update


type Msg
    = NewMsg
    | TrumpMsg (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewMsg ->
            ( model, getTrumpMsg )

        TrumpMsg (Ok string) ->
            ( { model | trumpMsg = string }, Cmd.none )

        TrumpMsg (Err _) ->
            ( model, Cmd.none )


getTrumpMsg : Cmd Msg
getTrumpMsg =
    let
        url =
            "https://api.whatdoestrumpthink.com/api/v1/quotes/random"

        request =
            Http.get url (Decode.at [ "message" ] Decode.string)
    in
    Http.send TrumpMsg request



--Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



--View


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Trump Message: " ]
        , br [] []
        , h2 [] [ text model.trumpMsg ]
        , br [] []
        , button [ onClick NewMsg ] [ text "New Trump Message" ]
        ]



--main


main : Program Never Model Msg
main =
    program
        { init = initModel
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
