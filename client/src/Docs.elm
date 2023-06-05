module Docs exposing (..)
import Types exposing (..)
import Html.Styled exposing (..)
import Css exposing (..)
import Html.Styled.Attributes exposing (..)

view : Model ->  Html Msg
view model = 
    styled div 
        [ margin (px 0) ] 
        [] [h1 [] [ text "Your Title Here" ]]

viewDetail : String -> Model ->  Html Msg
viewDetail slug model = 
    styled div 
        [ margin (px 0) ] 
        [] [h1 [] [ text "Detail Page" ]]