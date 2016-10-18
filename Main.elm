module Main exposing (..)

import Random exposing (int)
import Array exposing (get, fromList)
import Html exposing (..)
import Html.App as App


-- model


type alias Model =
    { quote : Quote
    }


type alias Quote =
    -- quote will also need to have an id here
    { text : String
    , author : String
    , genre : String
    }


quotes : List Quote
quotes =
    [ { text = "It's all about the money!"
      , author = "Meja"
      , genre = "music"
      }
    , { text = "I love tacos and burritos"
      , author = "Jennifer Lopez (Eric Cartman)"
      , genre = "funny"
      }
    ]


initModel : Model
initModel =
    { quote =
        { text = "Awaiting your quote..."
        , author = ""
        , genre = ""
        }
    }



-- update


type alias Msg =
    String


update : Msg -> Model -> Model
update msg model =
    model



-- fetch


fetchQuote : Model -> Model
fetchQuote model =
    -- there will be a call to API here, for fetching a quote, the current logic is temporary
    -- seems like it will be easier to write the backend first..
    let
        generator =
            Random.int 0 100

        seed0 =
            Random.int 0 100

        -- Random.initialSeed 31415
        n =
            Random.generate generator seed0

        -- Random.generate (int 0 (List.length quotes)) seed0
        -- Random.Generator a Random.int 0 (List.length quotes)
        -- newQuote =
        -- Array.get n (Array.fromList quotes)
    in
        model



-- view


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "YO!" ]
        ]


main : Program Never
main =
    App.beginnerProgram
        { model = initModel
        , update = update
        , view = view
        }
