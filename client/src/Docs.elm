module Docs exposing (..)
import Types exposing (..)
import Html.Styled exposing (..)
import Css exposing (..)
import Html.Styled.Attributes exposing (..)

view : Model ->  Html Msg
view model = 
    styled div 
        [ margin (px 0) ] 
        [] [a  [href "/docs/issue-id/1avs214-123"] [text "Detailpage"]]

viewDetail : String -> Model ->  Html Msg
viewDetail slug model = 
    styled div [margin (px 0)] []
  [ 
    
  styled div [ marginLeft (px 100), marginRight auto, marginTop (px 100), maxWidth (px 800)] [] [
      
        ul [] (List.map viewMessage model.choices)
  ]
  , footer
  ]

viewMessage : Choice -> Html Msg
viewMessage choice =
    div [] [styled li [if choice.message.role == User then fontWeight bold else fontWeight normal] [] [ text choice.message.content ],
            p [] []]

footer : Html Msg
footer = styled div [position fixed, left (px 0), bottom (px 0),
                     Css.width (pct 100), Css.height (px 40), backgroundColor (rgb 200 200 200),
                     paddingTop (px 10), paddingBottom (px 7),
                     displayFlex, justifyContent center] [] [styled div [position absolute, top (pct 50), transform (translateY (pct -50))] [] [
                      imageButton "/docs" "./Images/Heart-Icon.png" , imageButton "/" "./Images/Home-Icon.svg"]]

imageButton : String -> String -> Html Msg
imageButton uri path = styled button [border (px 0), backgroundColor (rgba 0 0 0 0)] [] [ 
    a [href uri] [ styled img [Css.width (px 25), Css.height (px 25), marginRight (px 50) ] [src path] []
    ]] 
