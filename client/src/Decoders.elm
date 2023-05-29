module Decoders exposing (..)
import Json.Decode as Decode exposing (Decoder)
import Types exposing (..)
decodeMessage : Decoder Message
decodeMessage =
    Decode.map2 Message
        (Decode.field "role" decodeRole)
        (Decode.field "content" Decode.string)

decodeApiResponse : Decoder ApiResponse
decodeApiResponse =
    Decode.map ApiResponse
        (Decode.field "choices" (Decode.list decodeChoice))

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


decodeApiResponseFromPocketbaseList : Decoder ApiResponsePocketbaseList
decodeApiResponseFromPocketbaseList =
    Decode.map5 ApiResponsePocketbaseList
        (Decode.field "page" Decode.int)
        (Decode.field "perPage" Decode.int)
        (Decode.field "totalPages" Decode.int)
        (Decode.field "totalItems" Decode.int)
        (Decode.field "items" (Decode.list decodeApiResponsePocketbase))

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