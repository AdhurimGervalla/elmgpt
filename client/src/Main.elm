module Main exposing (main)

import Browser
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Types exposing (..)
import Detail exposing (..)

testData1 : Message
testData1 = 
    {
    role = User
    , content = "What did you have for lunch?"
    }

testData2 : Message
testData2 = 
    {
    role = Assistant
    , content = "Pizza"
    }

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
    ( { inputText = "", choices = [], detail = [testData1,testData2], suggestedQuestions = [] }, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none