module Lib.CmdExt exposing (pure)

import Task

pure : a -> Cmd a
pure a = Task.succeed a |> Task.perform identity
