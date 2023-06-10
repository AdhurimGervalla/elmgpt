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
      , docsFilterText = ""
      , choices = []
      , suggestedQuestions = []
      , page = HomePage
      , detailPage =  { id = "", collectionId = "", collectionName = "", created = "", updated = "", messages = [], scraped = False }
      , isLoading = False
      , apiKey = ""
      , placeholder = "Enter API key"
      }
    , getSuggestedQuestionsCmd
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
        Loading isLoading ->
            ( {model | isLoading = isLoading}, Cmd.none )

        GetOneFromPocketbase slug ->
            let
                cmd = Docs.getOne slug
            in
            ( model, cmd)

        GotResponseFromOnePocketbase result ->
            case result of
                Ok apiResponse ->
                    let
                        _ = Debug.log "Detail APi Call" apiResponse
                    in
                    ( {model | detailPage = apiResponse}, Cmd.none )

                Err httpError ->
                    let
                        _ = Debug.log "HTTP Error" httpError
                    in
                    ( model, Cmd.none )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            let
                newPage =
                   case String.split "/" url.path of
                        [ "", "docs", "issue-id", id ] ->
                             DocsDetailPage id

                        [ "", "docs" ] ->
                             DocsPage

                        _ -> HomePage
            in
            ( { model | url = url, page = newPage }
            , Cmd.none
            )
        GotResponse result ->
            case result of
                Ok apiResponse ->
                    ( {model | placeholder = "Any other questions?", choices = model.choices ++ List.map (\i -> i) apiResponse.choices, isLoading = False}, Cmd.none )

                Err httpError ->
                    ( {model | apiKey = "", choices = [], isLoading = False, placeholder = "Please enter a valid API key"}, Cmd.none )


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
            ( { model | inputText = newText },  getSuggestedQuestionsCmd )

        UpdateDocsFilterText newText ->
             ( { model | docsFilterText = newText },  Cmd.none )

        ReceiveSuggestedQuestions result ->
            case result of
                Ok suggestedQuestions ->
                    ( {model | suggestedQuestions = suggestedQuestions.items}, Cmd.none )
                Err httpError ->
                    ( model, Cmd.none )

        SubmitApiKey ->
            ({ model | apiKey = model.inputText, inputText = "", isLoading = False, placeholder = "Ask me anything" }, Cmd.none)

        SubmitMessage ->
            let
                userMessage = { message = { role = User, content = model.inputText }, finish_reason = "", index = 0 }
                cmd = chatWithAi model.inputText model                        
            in
            ( { model | choices = model.choices ++ [userMessage], inputText = "", isLoading = True }, cmd )

        BookmarkMessage ->
            let
                data = { messages = (List.map (\c -> c.message) model.choices), scraped = False }
                cmd = bookmarkChat data
            in
            ( model, cmd)
        DeleteMessage ->( {model | choices = [], inputText = "", placeholder = "Ask me anything"}, Cmd.none )