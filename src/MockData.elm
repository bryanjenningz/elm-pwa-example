module MockData exposing (..)

import Data exposing (Moment, Comment, User, Language, Talk, Message, Date, SignupInfo)


mockSignupInfo : SignupInfo
mockSignupInfo =
    { email = "a@example.com"
    , password = "example"
    , name = "Example Name"
    , birthday = Date 1996 1 2
    , isMan = True
    , picture = ""
    }


emptySignupInfo : SignupInfo
emptySignupInfo =
    SignupInfo "" "" "" defaultDate True ""


defaultDate : Date
defaultDate =
    Date 1996 1 1


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
    , birthday = "2-1-1996"
    , isMan = True
    , lastLogin = "2017-07-12T18:03:15.693Z"
    , location = "Pleasantville, Pleasant Country"
    , localTime = "7:38 PM"
    , learningLanguage = Language "EN" "English" 2
    , nativeLanguage = Language "CN" "中文" 5
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
