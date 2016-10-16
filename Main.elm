module Main exposing (..)

import Html exposing (..)
import Html.App as App


-- model


type alias Model =
    { quote : Quote
    }


type alias Quote =
    { text : String
    , author : String
    }


initModel : Model
initModel =
    { quote =
        { text = "Awaiting your quote..."
        , author = ""
        }
    }



-- update


type alias Msg =
    String


update : Msg -> Model -> Model
update msg model =
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
