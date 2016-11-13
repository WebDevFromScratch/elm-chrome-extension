module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Task
import Http
import Json.Decode exposing (..)
import Html.App as App
import Animation exposing (px)


-- decoders


likeResponseDecoder : Decoder Like
likeResponseDecoder =
    object2 Like
        ("id" := int)
        ("quote_id" := int)
        |> at [ "like" ]


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


likeQuote : Model -> Cmd Msg
likeQuote model =
    let
        url =
            "http://localhost:4000/api/likes"

        task =
            Http.send Http.defaultSettings
                { verb = "POST"
                , headers =
                    [ ( "Content-Type", "application/json" )
                    ]
                , url = url
                , body = Http.string """{ "like": { "quote_id": 124 } }"""
                }

        cmd =
            Task.perform Fail LikeMsg (Http.fromJson likeResponseDecoder task)
    in
        cmd



-- model


type alias Like =
    { id : Int
    , quote_id : Int
    }


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
    , loading : Bool
    , style : Animation.State
    }


emptyQuote =
    { id = 0
    , text = ""
    , author = { id = 0, name = "" }
    , category = { id = 0, name = "" }
    }


initModel : Model
initModel =
    { quote =
        Just emptyQuote
    , error = Nothing
    , loading = True
    , style =
        Animation.style
            [ Animation.opacity 1.0
            ]
    }


init : ( Model, Cmd Msg )
init =
    ( initModel, randomQuote )



-- update


type Msg
    = QuoteMsg Quote
    | LikeMsg Like
    | Fail Http.Error
    | NewQuote
    | LikeQuote
    | Animate Animation.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        QuoteMsg response ->
            ( { model | error = Nothing, quote = Just response, loading = False }, Cmd.none )

        LikeMsg response ->
            -- sth should be added, possibly to state I guess, to let know that the quote has been liked
            ( model, Cmd.none )

        Fail error ->
            ( { model | error = Just error, quote = Nothing, loading = False }, Cmd.none )

        NewQuote ->
            ( { model | error = Nothing, quote = Just emptyQuote, loading = True }, randomQuote )

        LikeQuote ->
            ( model, likeQuote model )

        Animate animMsg ->
            ( { model | style = Animation.update animMsg model.style }, Cmd.none )



-- view


contentToRenderForLoading model =
    div [ class "content" ]
        -- [ h1 [ class "ti-reload" ] [] ]
        [ h1 [] [] ]


contentToRenderForError : { b | error : Maybe a } -> Html c
contentToRenderForError model =
    let
        errorText =
            case model.error of
                Nothing ->
                    "Something unexpected happened, please contact support."

                Just error ->
                    "We had some troubles fetching a quote for you.. Please try to fetch it once more."
    in
        div [ class "content" ]
            [ h1 [] [ text errorText ] ]


contentToRenderForResponse model =
    case model.loading of
        True ->
            contentToRenderForLoading model

        False ->
            case model.quote of
                Nothing ->
                    contentToRenderForError model

                Just quote ->
                    div
                        [ class "content" ]
                        [ h1 [] [ text quote.text ]
                        , h3 [] [ text quote.author.name ]
                        , div
                            [ class "buttons-wrapper margin-top-md" ]
                            [ button [ class "button", onClick LikeQuote ] [ span [ class "ti-heart" ] [] ]
                            , button [ class "button", onClick NewQuote ] [ span [ class "ti-reload" ] [] ]
                            ]
                        ]


view : Model -> Html Msg
view model =
    contentToRenderForResponse model



-- subscription


subscriptions : Model -> Sub Msg
subscriptions model =
    Animation.subscription Animate [ model.style ]


main : Program Never
main =
    App.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
