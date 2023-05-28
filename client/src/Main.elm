module Main exposing (main)

import Browser
--import Html exposing (..)
--import Html.Attributes exposing (..)
--import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
--import Html.Events exposing (onInput)
--import Html.Events exposing (onClick)
import Debug as Debug
import List exposing (length)
import Html.Styled exposing (..)
import Css exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onInput, onClick)
import Http exposing (Error)

type alias ChatCompletion = {
    model: String,
    messages: List Message,
    temperature: Float }

type Role
    = System
    | User
    | Assistant

type alias Message =
    { role : Role
    , content : String
    }

type alias Model =
    { inputText : String
    , choices : List Choice
    }
type alias Choice =
    { message : Message
    , finish_reason : String
    , index : Int
    }

type alias Conversation =
    { messages : List Message
    , scraped : Bool
    }


-- Source: https://package.elm-lang.org/packages/elm/http/2.0.0

type alias ApiResponse = { choices: List Choice }
type alias ApiResponsePocketbase = { id: String, collectionId: String, collectionName: String, created: String, updated: String, messages: List Message, scraped: Bool }

decodeApiResponse : Decoder ApiResponse
decodeApiResponse =
    Decode.map ApiResponse
        (Decode.field "choices" <| Decode.list decodeChoice)

decodeChoice : Decoder Choice
decodeChoice =
    Decode.map3 Choice
        (Decode.field "message" decodeMessage)
        (Decode.field "finish_reason" Decode.string)
        (Decode.field "index" Decode.int)

decodeApiResponsePocketbase : Decoder ApiResponsePocketbase
decodeApiResponsePocketbase =
    Decode.map7 ApiResponsePocketbase
        (Decode.field "id" Decode.string)
        (Decode.field "collectionId" Decode.string)
        (Decode.field "collectionName" Decode.string)
        (Decode.field "created" Decode.string)
        (Decode.field "updated" Decode.string)
        (Decode.field "messages" (Decode.list decodeMessage))
        (Decode.field "scraped" Decode.bool)

roleDecoder: String -> Decoder Role
roleDecoder str =
    case str of
        "system" ->
            Decode.succeed System

        "user" ->
            Decode.succeed User

        "assistant" ->
            Decode.succeed Assistant
        _ ->
            Decode.fail ("Invalid role: " ++ str)

decodeRole : Decoder Role
decodeRole =
    Decode.andThen roleDecoder Decode.string

type Msg
  = GotResponse (Result Http.Error ApiResponse)
    | GotResponseFromPocketbase (Result Http.Error ApiResponsePocketbase)
    | UpdateInputText String
    | SubmitMessage
    | BookmarkMessage
    | DeleteMessage

apiKey : String
apiKey =
    "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"

url : String
url =
    "https://api.openai.com/v1/chat/completions"

encodeRole : Role -> Encode.Value
encodeRole role =
    case role of
        System ->
            Encode.string "system"

        User ->
            Encode.string "user"

        Assistant ->
            Encode.string "assistant"

encodeMessage : Message -> Encode.Value
encodeMessage sm =
    Encode.object
        [ ( "role", encodeRole sm.role )
        , ( "content", Encode.string sm.content )
        ]

encodeChatCompletion : ChatCompletion -> Encode.Value
encodeChatCompletion chatCompletion =
    Encode.object
        [ ( "model", Encode.string chatCompletion.model )
        , ( "messages", Encode.list encodeMessage chatCompletion.messages )
        , ( "temperature", Encode.float chatCompletion.temperature )
        ]

encodeConversation : Conversation -> Encode.Value
encodeConversation conversation =
    Encode.object
        [ ( "messages", Encode.list encodeMessage conversation.messages )
        , ( "scraped", Encode.bool conversation.scraped )
        ]

decodeMessage : Decoder Message
decodeMessage =
    Decode.map2 Message
        (Decode.field "role" decodeRole)
        (Decode.field "content" Decode.string)

-- Fprod Test Message to send to the API
chatMessages : String -> Model -> ChatCompletion
chatMessages question model = ChatCompletion "gpt-3.5-turbo" ((List.map (\c -> c.message) model.choices) ++ [(Message User question)]) 0.7

chatWithAi : String -> Model -> Cmd Msg
chatWithAi input model =
    let
        requestBody = encodeChatCompletion (chatMessages input model)
        requestBodyJsonString = Encode.encode 2 requestBody
        _ = Debug.log "Request Body" requestBodyJsonString
    in
    Http.request
    {
        method = "POST",
        headers = [Http.header "Authorization" ("Bearer " ++ apiKey)],
        url = url,
        body = Http.jsonBody requestBody,
        expect = Http.expectJson GotResponse decodeApiResponse,
        timeout = Nothing,
        tracker = Nothing
    }

bookmarkChat : Conversation -> Cmd Msg
bookmarkChat conversation = 
    let
        requestBody = encodeConversation conversation
        requestBodyJsonString = Encode.encode 2 requestBody
        _ = Debug.log "Request Body" requestBodyJsonString
    in
        Http.request
        {
            method = "POST",
            headers = [],
            url = "http://127.0.0.1:8090/api/collections/docs/records",
            body = Http.jsonBody requestBody,
            expect = Http.expectJson GotResponseFromPocketbase decodeApiResponsePocketbase,
            timeout = Nothing,
            tracker = Nothing
        }
    

--view : Model -> Html Msg
--view model =
--    div [ class "jumbotron" ]
--        [ h1 [] [ text "elmGPT" ],
--            div []
--            [ input
--                [ type_ "text"
--                , placeholder "ask the AI"
--                , value model.inputText
--                , onInput UpdateInputText
--                ]
--                []
--            , button [ onClick SubmitMessage ] [ text "Send Message" ]
--            ],
--            h1 [] [ if (length model.choices) > 0 then text "AI Chat" else text ""], 
--            ul [] (List.map viewMessage model.choices)
--        ]
imageButton : String -> Html Msg --                                              Method call here
imageButton path = styled button [border (px 0), backgroundColor (rgba 0 0 0 0)] [] [ 
  styled img [Css.width (px 25), Css.height (px 25), marginRight (px 50) ] [src path] []] 

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


footer : Html Msg
footer = styled div [position fixed, left (px 0), bottom (px 0),
                     Css.width (pct 100), Css.height (px 40), backgroundColor (rgb 200 200 200),
                     displayFlex, justifyContent center] [] [styled div [position absolute, top (pct 50), transform (translateY (pct -50))] [] [
                      imageButton "./Images/Heart-Icon.png" , imageButton "./Images/Home-Icon.svg"]]

mainStyle : List (Style)
mainStyle = [ 
              displayFlex,
              flexDirection row,
              margin auto
            ]

view : Model ->  Html Msg
view model = styled div [margin (px 0)] []
  [ 
    styled div [marginTop (px 100)] [] [
      styled Html.Styled.form [ displayFlex, justifyContent center] [] [
        styled div mainStyle [] [
          styled input [Css.width (px 400)] [
                  type_ "text"
                , placeholder "ask the AI"
                , value model.inputText
                , onInput UpdateInputText] []
          ,btn [onClick SubmitMessage, type_ "button"] [text "GO!" ]
        ]
    ]
  , styled div [displayFlex, justifyContent center, marginRight (px 100), marginLeft (px 100), marginTop (px 50)] [] [
        h1 [] [ if (length model.choices) > 0 then text "AI Chat" else text ""], 
        div [] 
        (if (length model.choices) > 0 
            then 
                [ button [onClick BookmarkMessage, type_ "button"] [ text "Save" ]
                , button [onClick DeleteMessage] [ text "Delete" ] 
                ]
            else 
                [ text "" ]
        ),
        ul [] (List.map viewMessage model.choices)
  ]
  , footer

  ]    
  ]



main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view >> Html.Styled.toUnstyled
        , update = update
        , subscriptions = subscriptions
        }

init : flags -> ( Model, Cmd Msg )
init _ =
    ( { inputText = "", choices = [] }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotResponse result ->
            case result of
                Ok apiResponse ->
                    let
                        _ = Debug.log "API Response" apiResponse
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
                        _ = Debug.log "API Response" apiResponse
                    in
                    ( {model | choices = [], inputText = ""}, Cmd.none )

                Err httpError ->
                    let
                        _ = Debug.log "HTTP Error" httpError
                    in
                    ( model, Cmd.none )

        UpdateInputText newText ->
            ( { model | inputText = newText }, Cmd.none )

        SubmitMessage ->
            let
                cmd = chatWithAi model.inputText model
                _ = Debug.log "Input Message" model.inputText
            in
            ( model, cmd )
        BookmarkMessage ->
            let
                data = { messages = (List.map (\c -> c.message) model.choices), scraped = False }
                cmd = bookmarkChat data
                _ = Debug.log "data to save in pocketbase" data
            in
            ( model, cmd)
        DeleteMessage ->( {model | choices = [], inputText = ""}, Cmd.none )

viewMessage : Choice -> Html Msg
viewMessage choice =
    li [] [ text choice.message.content ]