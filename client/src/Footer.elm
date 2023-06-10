module Footer exposing (..)


import Html.Events exposing (onClick)
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Types exposing (Msg)

imageButton : String -> String -> Html Msg
imageButton uri path = styled button [border (px 0), backgroundColor (rgba 0 0 0 0)] [] [
    a [href uri] [ styled img [Css.width (px 25), Css.height (px 25), marginRight (px 50) ] [src path] []
    ]]

btn : List (Attribute msg) -> List (Html msg) -> Html msg
btn =
    styled button
        [
          color (rgb 0 0 0)
        , hover
            [
            color (rgb 255 255 255)
            , textDecoration underline
            ]
        , Css.width (px 50)
        , Css.height (px 50)
        , marginLeft (px 10)
        ]

appFooter : Html Msg
appFooter = styled div [position fixed, left (px 0), bottom (px 0), backgroundColor (rgb 255 255 255)
                     , Css.width (pct 100), Css.height (px 60)
                     --, backgroundColor (rgb 200 200 200)
                     , paddingTop (px 10), paddingBottom (px 7)
                     , boxShadow5 (px 1) (px 1) (px 4) (px 4) (rgba 150 150 150 0.2)
                     
                     , displayFlex, justifyContent center] [] [styled div [position absolute, top (pct 50), transform (translateY (pct -50))] [] [
                      imageButton "/docs" "./Images/Heart-Icon.png" , imageButton "/" "./Images/Home-Icon.svg"]]