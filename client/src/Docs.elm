module Docs exposing (..)
import Footer exposing (appFooter)
import Html.Styled.Attributes exposing (href)
import Types exposing (..)
import Html.Styled exposing (..)
import Css exposing (..)

view : Model -> Html Msg
view model = styled div [margin (px 0)] []
          [
          styled div [displayFlex, flexWrap wrap] [] (List.map (\content -> viewDocsItem content) model.suggestedQuestions),
          appFooter
          ]


viewDocsItem : ApiResponsePocketbase -> Html Msg
viewDocsItem item =
          styled a [flex3 (int 1) (int 1) (px 100), textDecoration none] [href ("docs/issue-id/" ++ item.id)]
           [
            styled div [margin (px 8), padding (px 8), minWidth (px 300),boxShadow5 (px 1) (px 1) (px 4) (px 4) (rgba 150 150 150 0.2), border3 (px 1) solid (rgb 200 200 200)] [] [
                 styled div [displayFlex, flexDirection column, color (rgb 0 0 0)] [] (List.map(\message -> span [] [text message.content]) item.messages),
                  text "more"
              ]
            ]

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

