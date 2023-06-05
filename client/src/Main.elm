module Main exposing (main)

import Browser
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Types exposing (..)
import Collection exposing (..)

main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view >> Html.Styled.toUnstyled
        , update = update
        , subscriptions = subscriptions
        }

init : flags -> ( Model, Cmd Msg )
init _ =
    ( { inputText = "", choices = [], suggestedQuestions = [] }, getSuggestedQuestionsCmd )

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none