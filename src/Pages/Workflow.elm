module Pages.Workflow exposing (Params, body, State, initState, Msg(..), update)

import Bulma.Columns exposing (column, columnModifiers, columns, columnsModifiers)
import Bulma.Components exposing (Card, card)
import Bulma.Elements as BlumaEl
import Bulma.Modifiers exposing (Devices, Width(..))
import Html exposing (text)
import Models.Workflow exposing (Workflow)


type alias Params =
    { workflowName : String }

type alias State =
    { workflow : Maybe Workflow
    }

initState : State
initState =
    { workflow = Nothing
    }

type Msg
    = ParamsChange

update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case msg of
        ParamsChange -> Debug.log "wf params change" (state, Cmd.none)

columnModifierswidths =
    columnModifiers.widths

labelsInfoColumns =
    { columnModifiers
        | widths = { columnModifierswidths | desktop = Just Width5 }
    }


body params state =
    columns columnsModifiers
        []
        [ column labelsInfoColumns
            []
            -- Boxにする
            [ card []
                -- Contentにする
                [ column columnModifiers [] [ text "todo" ] ]

            -- left infos
            ]
        ]
