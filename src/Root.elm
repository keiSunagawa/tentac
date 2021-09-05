module Root exposing (Msg(..), State, body, update, init)

import Browser
import Bulma.CDN exposing (stylesheet)
import Bulma.Elements as BulmaEl
import Bulma.Layout as Layout
import Html as H
import Pages.Workflow as Wf
import Routes exposing (Routes(..))
import Routing
import Url
import Bulma.Components as BulmaCom
import Html.Attributes exposing (disabled, href)
import Bulma.Modifiers exposing (Color(..))
import Lib.CmdExt as CmdExt
import Browser.Navigation as Nav

type alias State =
    { routing : Routing.State
    , workflow: Wf.State
    }


type Msg
    = RoutingMsg Routing.Msg
    | WorkflowMsg Wf.Msg

init : () -> Url.Url -> Nav.Key -> ( State, Cmd Msg )
init flags url key =
    let
        initRouting =
            Routing.UrlChanged url |> RoutingMsg |> CmdExt.pure

        routingState =
            { key = key
            , url = url
            , route = Routes.HomeRoute
            }
        initState =
            { routing = routingState
            , workflow = Wf.initState
            }
    in
    ( initState, initRouting )

update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case msg of
        RoutingMsg Routing.ParamsChange ->
            case state.routing.route of
                Routes.HomeRoute -> (state, Cmd.none)
                Routes.WorkflowRoute _ -> (state, WorkflowMsg Wf.ParamsChange |>  CmdExt.pure )
        RoutingMsg routingMsg ->
            Routing.update routingMsg state.routing
                |> Tuple.mapFirst (\s -> { state | routing = s })
                |> Tuple.mapSecond (Cmd.map RoutingMsg)
        WorkflowMsg workflowMsg ->
             Wf.update workflowMsg state.workflow
                |> Tuple.mapFirst (\s -> { state | workflow = s })
                |> Tuple.mapSecond (Cmd.map WorkflowMsg)

title =
    Layout.hero
        Layout.heroModifiers
        []
        [ Layout.heroBody
            []
            [ BulmaEl.title BulmaEl.H1 [] [ H.text "WorkflowUI" ] ]
        ]


page state =
    case state.routing.route of
        HomeRoute ->
            Url.toString state.routing.url |> H.text

        WorkflowRoute params ->
            Wf.body params state.workflow

navbarColor = BulmaCom.navbarModifiers |> \mod -> { mod | color = Primary }
navbar = BulmaCom.navbar navbarColor []
    [ BulmaCom.navbarMenu True []
      [ BulmaCom.navbarStart []
        [ BulmaCom.navbarItemLink False [href "/"] [ H.text "Home"  ]
        , BulmaCom.navbarItemLink False [href "/workflow/test"] [ H.text "Workflow" ] -- dummy link
        ]
      ]
    ]

content : State -> H.Html Msg
content state =
    Layout.container
        []
        [ title
        , navbar
        , Layout.section
            Layout.Spaced
            []
            [ page state ]

        -- body
        ]


body : State -> Browser.Document Msg
body state =
    { title = "Tentac"
    , body =
        [ stylesheet
        , content state
        ]
    }
