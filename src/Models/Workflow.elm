module Models.Workflow exposing (Workflow, Labels, test)

import Json.Decode exposing (string, array, dict, field, at, Decoder, map3, maybe, decodeString)
import Dict exposing (Dict)

-- TODO annotations
type alias Workflow =
    { name : String
    , templateRef: String
    , labels : Labels
    , status: String
    , nodes: List WorkflowNode
    }

type alias Labels = Dict String String

-- storedTemplatesからannotationを取得する
type alias WorkflowNode =
    { name: String
    , templateRef: String
    , labels : Labels
    , status: String
    }

type alias WorkflowNodeRaw =
    { name: String
    , templateRefName: Maybe String
        -- labelsはstoredTemplateより取得
    , status: String
    }

workflowRawDcoder : Decoder WorkflowNodeRaw
workflowRawDcoder =
    let
        nameD = field "name" string
        templateRefName = at ["templateRef", "name"] string |> maybe
        -- templateRefName = field "templateRef" string |> maybe
        statusD = field "phase" string
    in
      map3
        WorkflowNodeRaw
        nameD
        templateRefName
        statusD

testJson = """
{
                "id": "robo-ac-add-start-of-day-p4ch2",
                "name": "robo-ac-add-start-of-day-p4ch2",
                "displayName": "robo-ac-add-start-of-day-p4ch2",
                "type": "Steps",
                "templateName": "entrypoint",
                "templateScope": "local/",
                "phase": "Succeeded",
                "startedAt": "2021-09-03T11:38:22Z",
                "finishedAt": "2021-09-03T11:39:35Z",
                "estimatedDuration": 71,
                "progress": "2/2",
                "resourcesDuration": {
                    "cpu": 100,
                    "memory": 114
                },
                "inputs": {
                    "parameters": [
                        {
                            "name": "run-date",
                            "value": ""
                        },
                        {
                            "name": "as-of-time",
                            "value": ""
                        },
                        {
                            "name": "is-past-date-run",
                            "value": "false"
                        }
                    ]
                },
                "children": [
                    "robo-ac-add-start-of-day-p4ch2-1842376984"
                ],
                "outboundNodes": [
                    "robo-ac-add-start-of-day-p4ch2-533891737"
                ]
            }
"""

test = decodeString workflowRawDcoder testJson |> Debug.toString |> \x -> Debug.log x 1
