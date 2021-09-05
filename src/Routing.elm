module Routing exposing (Msg(..), State, update)

import Browser
import Browser.Navigation as Nav
import Routes exposing (Routes(..), routeParser)
import Url
import Url.Parser as Parser
import Lib.CmdExt as CmdExt


type Msg
    = LinkClicked Browser.UrlRequest -- hrefがクリックされた場合に発生
    | UrlChanged Url.Url -- Nav.pushUrlでurlを変更したときに発生
    | ParamsChange


type alias State =
    { key : Nav.Key
    , url : Url.Url
    , route : Routes
    }


update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case msg of
        LinkClicked urlreq ->
            case urlreq of
                Browser.Internal url ->
                    -- "href" などで "/hoge" などを踏んだときに発生
                    -- pushUrlの場合page再ロードが発生しない
                    ( state, Nav.pushUrl state.key (Url.toString url) )

                Browser.External href ->
                    -- "href" などで "https://foo/bar" などを踏んだときに発生
                    ( state, Nav.load href )

        UrlChanged url ->
            -- pushUrl後に発生
            let
                routeMaybe =
                    Parser.parse Routes.routeParser url

                routeAndCmd =
                    case routeMaybe of
                        Just rt ->
                            ( rt, CmdExt.pure ParamsChange )

                        Nothing ->
                            ( Routes.HomeRoute, Nav.pushUrl state.key "/" )
            in
            Tuple.mapFirst (\rt -> { state | url = url, route = rt }) routeAndCmd
        ParamsChange -> (state, Cmd.none) -- Root.updateで処理しているため、ここでは到達しない
