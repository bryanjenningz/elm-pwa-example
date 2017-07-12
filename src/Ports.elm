port module Ports exposing (..)


port uploadPicture : () -> Cmd msg


port getPicture : (String -> msg) -> Sub msg


port saveToken : String -> Cmd msg
