module Main exposing (main)

import Browser
import Html.Styled exposing (..)
import Types exposing (..)
import Home exposing (..)
import Browser.Navigation as Nav
import Url
import Home
import Docs

main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }

init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { key = key
      , url = url
      , inputText = ""
      , choices = []
      , suggestedQuestions = []
      , page = HomePage
      }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
view : Model -> Browser.Document Msg
view model =
    { title = "Elmgpt"
    , body = [ viewPage model.page model |> Html.Styled.toUnstyled ]
    }

viewPage : Page -> Model -> Html Msg
viewPage page model =
    case page of
        HomePage ->
            Home.view model
        DocsPage ->
            Docs.view model
        DocsDetailPage slug ->
            Docs.viewDetail slug model

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal uerel ->
                    ( model, Nav.pushUrl model.key (Url.toString uerel) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            let
                page =
                    if url.path == "/docs" then
                        DocsPage
                    else
                        HomePage
            in
            ( { model | url = url, page = page }
            , Cmd.none
            )
        GotResponse result ->
            case result of
                Ok apiResponse ->
                    let
                        _ = Debug.log "API Response Chat GPT" apiResponse
                    in
                    ( {model | choices = model.choices ++ List.map (\i -> i) apiResponse.choices}, Cmd.none )

                Err httpError ->
                    let
                        _ = Debug.log "HTTP Error" httpError
                    in
                    ( model, Cmd.none )

        GotResponseFromPocketbase result ->
            case result of
                Ok apiResponse ->
                    let
                        _ = Debug.log "API Response Pocketbase" apiResponse
                    in
                    ( {model | choices = [], inputText = ""}, Cmd.none )

                Err httpError ->
                    let
                        _ = Debug.log "HTTP Error" httpError
                    in
                    ( model, Cmd.none )

        UpdateInputText newText ->
            ( { model | inputText = newText },  getSuggestedQuestionsCmd newText )

        ReceiveSuggestedQuestions result ->
            case result of
                Ok suggestedQuestions ->
                    let
                        _ = Debug.log "Suggested Questions" suggestedQuestions.items
                    in
                    ( {model | suggestedQuestions = suggestedQuestions.items}, Cmd.none )

                Err httpError ->
                    let
                        _ = Debug.log "HTTP Error" httpError
                    in
                    ( model, Cmd.none )

        SubmitMessage ->
            let
                userMessage = { message = { role = User, content = model.inputText }, finish_reason = "", index = 0 }
                cmd = chatWithAi model.inputText model
                _ = Debug.log "Input Message" model.inputText
            in
            ( { model | choices = model.choices ++ [userMessage], inputText = "" }, cmd )
        BookmarkMessage ->
            let
                data = { messages = (List.map (\c -> c.message) model.choices), scraped = False }
                cmd = bookmarkChat data
                _ = Debug.log "data to save in pocketbase" model.choices
            in
            ( model, cmd)
        DeleteMessage ->( {model | choices = [], inputText = ""}, Cmd.none )
