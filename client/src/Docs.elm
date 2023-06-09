module Docs exposing (..)
import Footer exposing (appFooter)
import Html.Styled.Attributes exposing (href, list, placeholder, type_, value)
import Html.Styled.Events exposing (onInput, onClick)
import List exposing (filter, foldl)
import String exposing (contains, toUpper)
import Types exposing (..)
import Html.Styled exposing (..)
import Css exposing (..)
import Http exposing (Error)
import Decoders exposing (..)
import Encoders exposing (..)

choices : List Message
choices =
    [ {role = User, content = "Hello Worldddddddddddddddddddddddddddddddddddddddddddddddddddddddd ddddddddddddddddddddddd dddddddddddddddddddddddddddddddddd dddddddddddddddddddddddddddd Hello Worldddddddddddddddddddddddddddddddddddddddddddddddddddddddd"}
    , {role = Assistant, content = "Hello how can I help you?"}
    , {role = User, content = "Serve me a drink"}
    , {role = Assistant, content = "Sure son"}
    ]

view : Model -> Html Msg
view model =
    let
        filteredItems = filter (\i -> containsKeyword i model.docsFilterText) model.suggestedQuestions
    in
      styled div [margin (px 0)] []
          [
          viewFilterInput model,
          styled div [displayFlex, flexWrap wrap] [] (List.map (\content -> viewDocsItem content) filteredItems),
          a [href "/docs/issue-id/eh5knmlwex3nils"] [text "Click here"],
          appFooter
          ]

containsKeyword: ApiResponsePocketbase -> String -> Bool
containsKeyword item query = foldl (||) False (List.map (\i -> contains (toUpper query) (toUpper i.content)) item.messages)

viewDocsItem : ApiResponsePocketbase -> Html Msg
viewDocsItem item =
          styled a [flex3 (int 1) (int 1) (px 100), textDecoration none] [href ("docs/issue-id/" ++ item.id), onClick (GetOneFromPocketbase item.id)]
           [
            styled div [margin (px 8), padding (px 8), minWidth (px 300),boxShadow5 (px 1) (px 1) (px 4) (px 4) (rgba 150 150 150 0.2), border3 (px 1) solid (rgb 200 200 200)] [] [
                 styled div [displayFlex, flexDirection column, color (rgb 0 0 0)] [] (List.map(\message -> span [] [text message.content]) item.messages),
                  text "more"
              ]
            ]

viewFilterInput: Model -> Html Msg
viewFilterInput model = styled input [margin2 (px 12) (px 8), Css.width (px 400)] [
                    type_ "text"
                  , placeholder "Search for Conversation"
                  , value model.docsFilterText
                  , onInput UpdateDocsFilterText] []


viewDetail : String -> Model ->  Html Msg
viewDetail slug model = 
    styled div [margin (px 0)] []
  [ 
    
  styled div [ marginLeft (px 100), marginRight auto, marginTop (px 100), marginRight (px 100)] [] [
      
        --ul [] (List.map viewMessage model.detailPage.messages)
        ul [] (List.map viewMessage choices)
  ]
  , appFooter
  ]


viewMessage : Message -> Html Msg
viewMessage message =
    styled div [boxShadow5 (px 1) (px 1) (px 4) (px 4) (rgba 150 150 150 0.2), marginTop (px 20), 
    if message.role == User then backgroundColor (rgb 255 255 255) else backgroundColor (rgb 250 250 250)] [] [styled div (if message.role == User then userStyled else assistantStyled) [] [ text message.content ],
            p [] []]

getOne : String -> Cmd Msg
getOne id =
    let
        uri = "http://127.0.0.1:8090/api/collections/docs/records/" ++ id
    in
        Http.get {
            url = uri,
            expect = Http.expectJson GotResponseFromOnePocketbase decodeApiResponsePocketbase
        } 

userStyled : List Style
userStyled = [marginLeft (px 20), paddingTop (px 20), paddingBottom (px 20), color (rgb 50 50 50)]

assistantStyled : List Style
assistantStyled = [fontWeight normal, marginLeft (px 20), paddingTop (px 20), paddingBottom (px 20)]