module Docs exposing (..)
import Types exposing (..)
import Html.Styled exposing (..)
import Css exposing (..)
import Html.Styled.Attributes exposing (..)

view : Model ->  Html Msg
view model = 
    let 
        _ = Debug.log "model" model
    in
    styled div 
        [ margin (px 0) ] 
        [] [h1 [] [ a [href "/docs/id-abcd"] [text "detail link"]]]

viewDetail : String -> Model ->  Html Msg
viewDetail slug model = 
    let 
        _ = Debug.log "slug" slug
    in
    styled div 
        [ margin (px 0) ] 
        [] [h1 [] [ text slug]]