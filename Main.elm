module Main exposing (..)

import Html exposing (..)
import Task
import Http
import Json.Decode exposing (..)
import Html.App as App


-- decoders


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


type alias Error =
    Http.Error


type alias Model =
    { quote : Maybe Quote
    , error : Maybe Error
    }


initModel : Model
initModel =
    -- TODO: consider just also starting with quote equalling to Nothing, and then managing this on the view
    { quote =
        Just
            { id = 0
            , text = "Fetching your quote..."
            , author = { id = 0, name = "Fetching your quote..." }
            , category = { id = 0, name = "Fetching your quote..." }
            }
    , error = Nothing
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
            ( { error = Nothing, quote = Just response }, Cmd.none )

        Fail error ->
            -- TODO: in the view, do a "toString" on this error
            ( { error = Just error, quote = Nothing }, Cmd.none )



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
