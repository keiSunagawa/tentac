module Main exposing (..)

import Browser
import Root
import Routes
import Routing
import Task
import Url
import Url.Parser as Parser
import Lib.CmdExt as CmdExt

main : Program () Root.State Root.Msg
main =
    Browser.application
        { init = Root.init
        , view = view
        , update = Root.update
        , subscriptions = subscriptions
        , onUrlChange = Routing.UrlChanged >> Root.RoutingMsg
        , onUrlRequest = Routing.LinkClicked >> Root.RoutingMsg
        }

subscriptions _ =
    Sub.none


view : Root.State -> Browser.Document Root.Msg
view state =
    Root.body state
