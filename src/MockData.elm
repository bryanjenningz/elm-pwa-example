module MockData exposing (..)

import Data exposing (Moment, Comment, User, Language, Talk, Message)


mockMoments : List Moment
mockMoments =
    List.repeat 10 mockMoment


mockMoment : Moment
mockMoment =
    { userId = "id_example123"
    , pictures = mockPictures
    , text =
        List.repeat 10 "test moment "
            |> String.join ""
    , likes = 2
    , comments = mockComments
    }


mockPictures : List String
mockPictures =
    List.repeat 9 mockPicture


mockPicture : String
mockPicture =
    "http://s3.amazonaws.com/37assets/svn/765-default-avatar.png"


mockComments : List Comment
mockComments =
    List.range 1 3
        |> List.map
            (\i ->
                if i % 2 == 0 then
                    Comment
                        "id_example123"
                        "example name"
                        "test reply 123!!!"
                else
                    Comment
                        "id_abe123"
                        "abe name"
                        "this is just a test reply, I hope this reply is not too long"
            )


mockUser : User
mockUser =
    { id = "id_example123"
    , name = "example name"
    , email = "example@example.com"
    , age = 99
    , isMan = True
    , lastLogin = 20
    , location = "Pleasantville, Pleasant Country"
    , localTime = "7:38 PM"
    , learning = Language "EN" "English" 2
    , native = Language "CN" "中文" 5
    , corrections = 22
    , savedWords = 34
    , audioLookups = 5
    , translationLookups = 2
    , bookmarks = 0
    , intro =
        List.repeat 10 "this is a test intro"
            |> String.join ", "
    , interests = [ "Music", "Soccer", "Movies" ]
    , picture = mockPicture
    , moments = mockMoments
    }


mockMessage : Message
mockMessage =
    Message mockUser 10000000 "Hello" True


mockTalks : List Talk
mockTalks =
    List.repeat 10 (Talk mockUser (List.repeat 10 mockMessage))
