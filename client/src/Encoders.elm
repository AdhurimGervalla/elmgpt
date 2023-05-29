module Encoders exposing (..)
import Json.Encode as Encode
import Types exposing (..)
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