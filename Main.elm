module Main exposing (..)

import Html exposing (..)
import Task
import Http
import Json.Decode exposing (..)
import Html.App as App


type alias Category =
    { id : Int
    , name : String
    }


type alias Author =
    { id : Int
    , name : String
    }


type alias Response =
    { id : Int
    , text : String
    , category : Category
    , author : Author
    }


categoryDecoder : Decoder Category
categoryDecoder =
    object2 Category
        ("id" := int)
        ("name" := string)


authorDecoder : Decoder Author
authorDecoder =
    object2 Author
        ("id" := int)
        ("name" := string)


responseDecoder : Decoder Response
responseDecoder =
    object4 Response
        ("id" := int)
        ("text" := string)
        ("category" := categoryDecoder)
        ("author" := authorDecoder)
        |> at [ "quote" ]


randomQuote : Cmd Msg
randomQuote =
    let
        url =
            "http://localhost:4000/api/quotes/random"

        task =
            Http.get responseDecoder url

        cmd =
            Task.perform Fail Quote task
    in
        cmd



-- model


type alias Model =
    String


initModel : Model
initModel =
    "Fetching a quote.."


init : ( Model, Cmd Msg )
init =
    ( initModel, randomQuote )



-- update


type Msg
    = Quote Response
    | Fail Http.Error


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Quote response ->
            ( toString (response.id) ++ " " ++ response.text, Cmd.none )

        Fail error ->
            ( (toString error), Cmd.none )



-- view


view : Model -> Html Msg
view model =
    div [] [ text model ]



-- subscription


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never
main =
    App.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
