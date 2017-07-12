module Decoders exposing (..)

import Json.Decode
import Json.Decode.Pipeline
import Data exposing (Moment, User, Language, Comment, UserToken)


decodeUser : Json.Decode.Decoder User
decodeUser =
    Json.Decode.Pipeline.decode User
        |> Json.Decode.Pipeline.required "_id" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "email" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "birthday" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "isMan" (Json.Decode.bool)
        |> Json.Decode.Pipeline.required "lastLogin" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "location" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "localTime" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "learning" (decodeLanguage)
        |> Json.Decode.Pipeline.required "native" (decodeLanguage)
        |> Json.Decode.Pipeline.required "corrections" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "savedWords" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "audioLookups" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "translationLookups" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "bookmarks" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "intro" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "interests" (Json.Decode.list Json.Decode.string)
        |> Json.Decode.Pipeline.required "picture" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "moments" (Json.Decode.list decodeMoment)


decodeUserToken : Json.Decode.Decoder UserToken
decodeUserToken =
    Json.Decode.map2 UserToken
        (Json.Decode.field "user" decodeUser)
        (Json.Decode.field "token" Json.Decode.string)


decodeLanguage : Json.Decode.Decoder Language
decodeLanguage =
    Json.Decode.Pipeline.decode Language
        |> Json.Decode.Pipeline.required "shortName" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "level" (Json.Decode.int)


decodeMoment : Json.Decode.Decoder Moment
decodeMoment =
    Json.Decode.Pipeline.decode Moment
        |> Json.Decode.Pipeline.required "userId" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "pictures" (Json.Decode.list Json.Decode.string)
        |> Json.Decode.Pipeline.required "text" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "likes" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "comments" (Json.Decode.list decodeComment)


decodeComment : Json.Decode.Decoder Comment
decodeComment =
    Json.Decode.Pipeline.decode Comment
        |> Json.Decode.Pipeline.required "userId" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "text" (Json.Decode.string)
