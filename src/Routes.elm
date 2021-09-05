module Routes exposing (Routes(..), routeParser, workflowRoute)

import Pages.Workflow as Wf
import Url.Parser exposing ((</>), Parser, int, map, oneOf, s, string, top)


type Routes
    = HomeRoute
    | WorkflowRoute Wf.Params


workflowRoute name =
    WorkflowRoute { workflowName = name }


routeParser : Parser (Routes -> a) a
routeParser =
    oneOf
        [ map HomeRoute top
        , map workflowRoute (s "workflow" </> string)
        ]
