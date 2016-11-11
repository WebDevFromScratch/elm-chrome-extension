module Main exposing (..)

-- import Random exposing (int)
-- import Array exposing (get, fromList)

import Html exposing (..)
import Html.App as App
import Http
import Task


-- model
-- type alias Model =
--     { quote : Quote
--     }


type alias Model =
    String


type alias Quote =
    -- quote will also need to have an id here - or will they?
    -- YES - because we'll probably be updating them (with likes, etc) - update backend to return id
    { text : String
    , author : String
    , category : String
    }



-- quotes : List Quote
-- quotes =
--     []


randomQuote : Cmd Msg
randomQuote =
    let
        url =
            -- localhost for now
            "http://localhost:4000/api/quotes/random"

        task =
            Http.getString url

        cmd =
            Task.perform Fail FetchQuote task
    in
        cmd


initModel : Model
initModel =
    -- { quote =
    --     { text = "Awaiting your quote..."
    --     , author = ""
    --     , category = ""
    --     }
    -- }
    "Awaiting your quote..."


init : ( Model, Cmd Msg )
init =
    ( initModel, randomQuote )



-- update


type Msg
    = FetchQuote String
    | Fail Http.Error


update : Msg -> Model -> Model
update msg model =
    case msg of
        FetchQuote quote ->
            -- { model | quote = fetchQuote }
            -- { model | quote = { text = "HO!", author = "", category = "" } }
            quote

        Fail error ->
            model


fetchQuote : Model -> Model
fetchQuote model =
    -- there will be a call to API here, for fetching a quote, the current logic is temporary
    -- seems like it will be easier to write the backend first..
    model



-- view


view : Model -> Html Msg
view model =
    div []
        -- [ h1 [] [ text model.quote.text ]
        -- ]
        [ h1 [] [ text model ]
        ]



-- subscription


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- main : Program Never
-- main =
--     App.program
--         { init = init
--         , update = update
--         , view = view
--         , subscriptions = subscriptions
--         }


main : Program Never
main =
    App.beginnerProgram
        { model = initModel
        , update = update
        , view = view
        }
