port module Ports exposing (..)

import Data exposing (UserToken)


port uploadPicture : () -> Cmd msg


port getPicture : (String -> msg) -> Sub msg


port saveUserToken : UserToken -> Cmd msg
