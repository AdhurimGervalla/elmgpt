module Home exposing (..)
import Footer exposing (appFooter, btn)
import Types exposing (..)
import Json.Encode as Encode
import List exposing (length)
import Html.Styled exposing (..)
import Css exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onInput, onClick)
import Http exposing (Error)
import Debug as Debug
import Decoders exposing (..)
import Encoders exposing (..)

view : Model ->  Html Msg
view model = styled div [margin (px 0)] []
  [ 
    styled div [marginTop (px 100)] [] [
      styled Html.Styled.form [ displayFlex, justifyContent center] [] [
        styled div mainStyle [] [
          styled input [Css.width (px 400)] [
                  type_ "text"
                , list "aiSearch"
                , placeholder "Ask the AI"
                , value model.inputText
                , onInput UpdateInputText] []
          ,btn [onClick SubmitMessage, type_ "button"] [text "GO!" ]
        ]
    ], viewSuggestedQuestions model
  , styled div [marginRight (px 100), marginLeft (auto), marginTop (auto), maxWidth (px 800)] [] [
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
  , appFooter
  ]]

getSuggestedQuestionsCmd : Cmd Msg
getSuggestedQuestionsCmd =
    let
        uri = "http://127.0.0.1:8090/api/collections/docs/records"
        _ = Debug.log "uri is: " uri
    in
        Http.get
        {
            url = uri,
            expect = Http.expectJson ReceiveSuggestedQuestions decodeApiResponseFromPocketbaseList
        }




mainStyle : List (Style)
mainStyle = [ 
              displayFlex,
              flexDirection row,
              margin auto
            ]

viewSuggestedQuestions : Model -> Html Msg
viewSuggestedQuestions model =
    let 
        allMessages = List.concatMap (\apiResponse -> apiResponse.messages) model.suggestedQuestions
        userMessages = List.filter (\message -> message.role == User) allMessages
        matchedMessages = List.filter (\message -> String.contains model.inputText message.content) userMessages
        allContent = List.map (\item -> item.content) matchedMessages
    in
        div [] [if model.inputText /= "" then datalist [id "aiSearch"] (List.map (\content -> option [] [text content]) allContent) else text ""]

viewMessage : Choice -> Html Msg
viewMessage choice =
    li [] [ text choice.message.content ]


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

apiKey : String
apiKey =
    ""

url : String
url =
    "https://api.openai.com/v1/chat/completions"