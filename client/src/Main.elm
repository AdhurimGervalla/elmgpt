module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Html.Events exposing (onInput)
import Html.Events exposing (onClick)
import Debug as Debug
import List exposing (length)

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


-- Source: https://package.elm-lang.org/packages/elm/http/2.0.0

type alias ApiResponse = { choices: List Choice }

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
    | UpdateInputText String
    | SubmitMessage

apiKey : String
apiKey =
    "PUT YOUR API KEY HERE"

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

view : Model -> Html Msg
view model =
    div [ class "jumbotron" ]
        [ h1 [] [ text "elmGPT" ],
            div []
            [ input
                [ type_ "text"
                , placeholder "ask the AI"
                , value model.inputText
                , onInput UpdateInputText
                ]
                []
            , button [ onClick SubmitMessage ] [ text "Send Message" ]
            ],
            h1 [] [ if (length model.choices) > 0 then text "AI Chat" else text ""], 
            ul [] (List.map viewMessage model.choices)
        ]


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
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

        UpdateInputText newText ->
            ( { model | inputText = newText }, Cmd.none )

        SubmitMessage ->
            let
                cmd = chatWithAi model.inputText model
                _ = Debug.log "Input Message" model.inputText
            in
            ( model, cmd )

viewMessage : Choice -> Html Msg
viewMessage choice =
    li [] [ text choice.message.content ]