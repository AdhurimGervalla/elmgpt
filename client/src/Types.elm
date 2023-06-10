module Types exposing (..)
import Http exposing (Error)
import Browser.Navigation as Nav
import Browser
import Url

type Page
    = HomePage
    | DocsPage
    | DocsDetailPage String

type Msg
  = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GotResponse (Result Http.Error ApiResponse)
    | GotResponseFromPocketbase (Result Http.Error ApiResponsePocketbase)
    | UpdateInputText String
    | UpdateDocsFilterText String
    | ReceiveSuggestedQuestions (Result Http.Error ApiResponsePocketbaseList)
    | SubmitMessage
    | SubmitApiKey
    | BookmarkMessage
    | DeleteMessage
    | GetOneFromPocketbase String
    | GotResponseFromOnePocketbase (Result Http.Error ApiResponsePocketbase)
    | Loading Bool

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
    { key : Nav.Key
    , url : Url.Url
    , inputText : String
    , docsFilterText: String
    , choices : List Choice
    , suggestedQuestions : List ApiResponsePocketbase
    , detailPage : ApiResponsePocketbase
    , page : Page
    , isLoading : Bool
    , apiKey : String
    , placeholder : String
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
