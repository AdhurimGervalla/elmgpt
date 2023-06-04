module Main exposing (..)

import Browser
import Html.Events exposing (onClick)
import Html exposing (..)
import Html.Attributes exposing (..)

import Page.Chat as Chat
import Page.Library as Library


main : Program () Model Msg
main =
  Browser.document
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

init : () -> (Model, Cmd Msg)
init () =
  ({ page = Chat {} }, Cmd.none)

type alias Model =
  {
   page: Page
  }

type Page
    = Chat Chat.Model
    | Library Library.Model



type Msg
  = GoToChat Chat.Model
  | GoToLibrary Library.Model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case (model.page, msg) of
    (_, GoToChat m) -> ( { model | page = Chat m }, Cmd.none )
    (_, GoToLibrary m) -> ( { model | page = Library m }, Cmd.none)

    -- (_, _) -> (model, Cmd.none)







subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none



-- VIEW

viewHeader : Html Msg
viewHeader  =
  div [class "header"]
    [ div [class "nav"]
        [ viewLink "/chat"
        , viewLink "/library"
        ]
    ]

viewFooter  =
  div [class "footer"]
    [ text "aso"]

viewSkeleton : Html Msg -> Browser.Document Msg
viewSkeleton content =
  { title =
      "Elm gpt"
  , body =
      [ viewHeader
      , content
      , viewFooter
      ]
  }


view : Model -> Browser.Document Msg
view model =
  case model.page of
    Chat chat ->
      viewSkeleton (Chat.view chat)
    Library library ->
      viewSkeleton (Library.view library)



viewLink : String -> Html Msg
viewLink path =
  li [] [ a [  onClick (GoToLibrary {})] [ text path ] ]