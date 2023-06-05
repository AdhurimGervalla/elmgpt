module UriParser exposing (pageParser)
import Types exposing (Page(..))
import Url.Parser as Parser exposing ((</>), Parser, s, string)

pageParser : Parser (Page -> a) a
pageParser =

    Parser.oneOf
        [ Parser.map HomePage (s "")
        , Parser.map DocsPage (s "docs")
        , Parser.map DocsDetailPage (s "docs" </> string)
        ]