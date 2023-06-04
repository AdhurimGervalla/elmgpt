module Types exposing (..)
import Http exposing (Error)
type Msg
  = GotResponse (Result Http.Error ApiResponse)
    | GotResponseFromPocketbase (Result Http.Error ApiResponsePocketbase)
    | UpdateInputText String
    | ReceiveSuggestedQuestions (Result Http.Error ApiResponsePocketbaseList)
    | SubmitMessage
    | BookmarkMessage
    | DeleteMessage

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
    , detail : List Message
    , suggestedQuestions : List ApiResponsePocketbase
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
type alias ApiResponsePocketbaseList = {page: Int, perPage: Int, totalPages: Int, totalItems: Int, items: List ApiResponsePocketbase }
