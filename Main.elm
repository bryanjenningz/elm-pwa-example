module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, src, style)


mockMoment : Moment
mockMoment =
    { userId = "id_example123"
    , pictures = mockPictures
    , text =
        List.range 1 10
            |> List.map (always "test moment ")
            |> List.foldl (++) ""
    , likes = 2
    , comments = mockComments
    }


mockMoments : List Moment
mockMoments =
    List.range 1 10
        |> List.map (\_ -> mockMoment)


mockPicture : String
mockPicture =
    "http://s3.amazonaws.com/37assets/svn/765-default-avatar.png"


mockPictures : List String
mockPictures =
    List.range 1 9
        |> List.map (always mockPicture)


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


mockComment : Comment
mockComment =
    { userId = "id_example123"
    , name = "example name"
    , text = "test replay"
    }


type alias Comment =
    { userId : String
    , name : String
    , text : String
    }


type alias Moment =
    { userId : String
    , pictures : List String
    , text : String
    , likes : Int
    , comments : List Comment
    }


type alias Language =
    { shortName : String
    , name : String
    , level : Int
    }


type alias User =
    { id : String
    , name : String
    , email : String
    , age : Int
    , isMan : Bool
    , lastLogin : Int
    , location : String
    , localTime : String
    , learning : Language
    , native : Language
    , corrections : Int
    , savedWords : Int
    , audioLookups : Int
    , translationLookups : Int
    , bookmarks : Int
    , intro : String
    , interests : List String
    , picture : String
    , moments : List Moment
    }


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
        List.range 1 10
            |> List.map (\_ -> "this is a test intro")
            |> String.join ", "
    , interests = [ "Music", "Soccer", "Movies" ]
    , picture = mockPicture
    , moments = mockMoments
    }


viewProfile : User -> Html msg
viewProfile user =
    div [ class "row", style [ ( "position", "relative" ) ] ]
        [ div [ class "bg-info", styleHeader ] []
        , div [ class "col-12 offset-md-3 col-md-6 mt-4" ]
            [ div [ class "row" ]
                [ div [ class "offset-1 col-1" ]
                    [ span [ class "badge badge-default" ]
                        [ text (toString user.lastLogin ++ "d") ]
                    ]
                , div [ class "offset-8 col-1" ]
                    [ span [ class "badge badge-primary" ]
                        [ text <|
                            (if user.isMan then
                                "♂"
                             else
                                "♀"
                            )
                                ++ " "
                                ++ toString user.age
                        ]
                    ]
                ]
            , div [ class "row" ]
                [ div [ class "col-2 offset-5" ]
                    [ img [ stylePicture, src mockPicture ] [] ]
                ]
            , div [ class "row" ]
                [ div [ class "col-12 text-center" ]
                    [ div [] [ text user.name ]
                    , div [ class "text-muted" ] [ text ("@" ++ user.id) ]
                    , div [ class "badge badge-default mt-1" ]
                        [ text (user.location ++ " " ++ user.localTime) ]
                    ]
                ]
            , div [ class "row mt-2" ]
                [ div [ class "offset-4 col-2" ]
                    [ div [] [ text user.native.shortName ]
                    , viewLanguageLevel user.native.level
                    , div [] [ text user.native.name ]
                    ]
                , div [ class "col-1 pt-2" ] [ text ">" ]
                , div [ class "col-2" ]
                    [ div [] [ text user.learning.shortName ]
                    , viewLanguageLevel user.learning.level
                    , div [] [ text user.learning.name ]
                    ]
                ]
            , div [ class "row mt-2" ]
                [ div [ class "offset-1 col-1" ]
                    [ div [ class "badge badge-default" ]
                        [ text ("✓ " ++ toString user.corrections) ]
                    ]
                , div [ class "offset-1 col-1" ]
                    [ div [ class "badge badge-default" ]
                        [ text ("文 " ++ toString user.translationLookups) ]
                    ]
                , div [ class "offset-1 col-1" ]
                    [ div [ class "badge badge-default" ]
                        [ text ("✎ " ++ toString user.savedWords) ]
                    ]
                , div [ class "offset-1 col-1" ]
                    [ div [ class "badge badge-default" ]
                        [ text ("🔉 " ++ toString user.audioLookups) ]
                    ]
                , div [ class "offset-1 col-1" ]
                    [ div [ class "badge badge-default" ]
                        [ text ("📖 " ++ toString user.bookmarks) ]
                    ]
                ]
            , div [ class "mt-4 card" ]
                [ div [ class "row card-block" ]
                    [ div [ class "offset-1 col-2" ]
                        [ div [ class "text-center text-primary" ] [ text "💬" ]
                        , div [ class "text-center text-muted" ] [ text "Message" ]
                        ]
                    , div [ class "offset-1 col-2" ]
                        [ div [ class "text-center text-primary" ] [ text "⊕" ]
                        , div [ class "text-center text-muted" ] [ text "Follow" ]
                        ]
                    , div [ class "offset-1 col-2" ]
                        [ div [ class "text-center text-primary" ] [ text "⚐" ]
                        , div [ class "text-center text-muted" ] [ text "Block/Report" ]
                        ]
                    ]
                ]
            , div [ class "mt-4 card" ]
                [ div [ class "card-block" ]
                    [ div [ class "text-muted" ] [ text "Self-introduction" ]
                    , div [ class "mt-2" ] [ text user.intro ]
                    , hr [] []
                    , div [ class "row" ]
                        [ div [ class "col-1 text-muted" ] [ text "♡" ]
                        , div [ class "col-11" ] <|
                            List.map
                                (\interest ->
                                    div [ class "badge badge-default mr-2" ]
                                        [ text interest ]
                                )
                                user.interests
                        ]
                    ]
                ]
            , div [ class "mt-4 card" ]
                [ div [ class "card-block" ]
                    [ div [ class "row" ]
                        [ div [ class "col-8" ]
                            [ text <|
                                "Moments ("
                                    ++ (toString <| List.length user.moments)
                                    ++ ")"
                            ]
                        , div [ class "col-4 text-muted" ]
                            [ let
                                totalLikes =
                                    user.moments |> List.map .likes |> List.sum
                              in
                                text <| "❤ " ++ toString totalLikes ++ " Likes"
                            ]
                        ]
                    , div [ class "mt-3" ]
                        (List.map
                            (\moment ->
                                div []
                                    [ div [ class "row" ]
                                        [ div [ class "col-2" ]
                                            [ img [ stylePicture, src user.picture ] [] ]
                                        , div [ class "col-10" ]
                                            [ div [] [ text user.name ]
                                            , div [ class "row" ]
                                                [ div [ class "col-3" ]
                                                    [ div [] [ text user.native.shortName ]
                                                    , viewLanguageLevel user.native.level
                                                    ]
                                                , div [ class "col-1 mr-4" ] [ text " > " ]
                                                , div [ class "col-3" ]
                                                    [ div [] [ text user.learning.shortName ]
                                                    , viewLanguageLevel user.learning.level
                                                    ]
                                                ]
                                            ]
                                        ]
                                    , div [ class "row mt-2" ]
                                        [ div [ class "offset-2 col-10" ]
                                            [ div [] [ text moment.text ]
                                            , div [ class "row mt-2" ]
                                                [ div [ class "col-3 text-muted" ]
                                                    [ text <| "❤ " ++ toString moment.likes ]
                                                , div [ class "col-3 text-muted" ]
                                                    [ text <|
                                                        "💬 "
                                                            ++ (toString <| List.length moment.comments)
                                                    ]
                                                ]
                                            , div [ class "mt-2" ] <|
                                                List.map
                                                    (\comment ->
                                                        div []
                                                            [ span [ class "text-primary" ]
                                                                [ text (comment.name ++ " ") ]
                                                            , text comment.text
                                                            ]
                                                    )
                                                    moment.comments
                                            ]
                                        ]
                                    , hr [] []
                                    ]
                            )
                            user.moments
                        )
                    ]
                ]
            ]
        ]


viewLanguageLevel : Int -> Html msg
viewLanguageLevel level =
    div [ style [ ( "margin-left", "-5px" ) ] ]
        (List.range 1 level
            |> List.map
                (always <|
                    div
                        [ class "bg-primary ml-1"
                        , style
                            [ ( "width", "5px" )
                            , ( "height", "5px" )
                            , ( "display", "inline-block" )
                            ]
                        ]
                        []
                )
        )


styleHeader : Attribute msg
styleHeader =
    style
        [ ( "position", "absolute" )
        , ( "left", "0" )
        , ( "right", "0" )
        , ( "height", "80px" )
        ]


stylePicture : Attribute msg
stylePicture =
    style [ ( "width", "100%" ), ( "border-radius", "50%" ) ]


main : Html msg
main =
    viewProfile mockUser
