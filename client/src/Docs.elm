module Docs exposing (..)
import Footer exposing (appFooter)
import Html.Styled.Attributes exposing (href, list, placeholder, type_, value)
import Html.Styled.Events exposing (onInput)
import List exposing (filter, foldl)
import String exposing (contains, toUpper)
import Types exposing (..)
import Html.Styled exposing (..)
import Css exposing (..)

view : Model -> Html Msg
view model =
    let
        filteredItems = filter (\i -> containsKeyword i model.docsFilterText) model.suggestedQuestions
    in
      styled div [margin (px 0)] []
          [
          viewFilterInput model,
          styled div [displayFlex, flexWrap wrap] [] (List.map (\content -> viewDocsItem content) filteredItems),
          appFooter
          ]

containsKeyword: ApiResponsePocketbase -> String -> Bool
containsKeyword item query = foldl (||) False (List.map (\i -> contains (toUpper query) (toUpper i.content)) item.messages)

viewDocsItem : ApiResponsePocketbase -> Html Msg
viewDocsItem item =
          styled a [flex3 (int 1) (int 1) (px 100), textDecoration none] [href ("docs/issue-id/" ++ item.id)]
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
    
  styled div [ marginLeft (px 100), marginRight auto, marginTop (px 100), maxWidth (px 800)] [] [
      
        ul [] (List.map viewMessage model.choices)
  ]
  , appFooter
  ]

viewMessage : Choice -> Html Msg
viewMessage choice =
    div [] [styled li [if choice.message.role == User then fontWeight bold else fontWeight normal] [] [ text choice.message.content ],
            p [] []]

