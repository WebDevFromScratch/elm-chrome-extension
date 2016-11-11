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


type alias Quote =
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


responseDecoder : Decoder Quote
responseDecoder =
    object4 Quote
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
            Task.perform Fail QuoteMsg task
    in
        cmd



-- model


type alias Model =
    Quote


initModel : Model
initModel =
    { id = 0
    , text = "Fetching your quote..."
    , author = { id = 0, name = "Fetching your quote..." }
    , category = { id = 0, name = "Fetching your quote..." }
    }


init : ( Model, Cmd Msg )
init =
    ( initModel, randomQuote )



-- update


type Msg
    = QuoteMsg Quote
    | Fail Http.Error


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        QuoteMsg response ->
            ( response, Cmd.none )

        Fail error ->
            -- TODO: eventually, we need to show error somewhere, maybe add yet another field to model (error: string)
            -- ( (toString error), Cmd.none )
            ( model, Cmd.none )



-- view


view : Model -> Html Msg
view model =
    div [] [ text (toString model) ]



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
