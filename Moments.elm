module Moments exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


type alias Comment =
    { name : String
    , id : String
    , profilePicture : String
    , time : Int
    , message : String
    }


type alias Moment =
    { name : String
    , id : String
    , profilePicture : String
    , time : Int
    , nativeLanguage : String
    , learningLanguage : String
    , pictures : List String
    , content : String
    , likes : Int
    , comments : List Comment
    }


mockMoments : List Moment
mockMoments =
    [ { name = "Bryan"
      , id = "id_bryan123"
      , profilePicture = "http://s3.amazonaws.com/37assets/svn/765-default-avatar.png"
      , time = 1497488859787
      , nativeLanguage = "English"
      , learningLanguage = "Chinese"
      , pictures = []
      , content = "This is a moment example"
      , likes = 0
      , comments = []
      }
    ]


viewMoments : List Moment -> Html msg
viewMoments moments =
    div [] <|
        List.map
            (\moment ->
                div []
                    [ -- moment header
                      div [ style [ ( "display", "flex" ), ( "height", "200px" ) ] ]
                        [ div [ style [ ( "flex", "1" ) ] ]
                            [ img
                                [ src moment.profilePicture
                                , style
                                    [ ( "width", "100%" )
                                    , ( "border-radius", "50%" )
                                    ]
                                ]
                                []
                            ]
                        , div [ style [ ( "flex", "4" ) ] ]
                            [ div
                                [ style
                                    [ ( "display", "flex" )
                                    , ( "flex-direction", "column" )
                                    ]
                                ]
                                [ div [ style [ ( "flex", "1" ) ] ] [ text moment.name ]
                                , div [ style [ ( "display", "flex" ), ( "align-items", "center" ), ( "flex", "1" ) ] ]
                                    [ div [ style [ ( "flex", "1" ) ] ] [ text moment.learningLanguage ]
                                    , div [ style [ ( "flex", "1" ) ] ] [ text ">" ]
                                    , div [ style [ ( "flex", "1" ) ] ] [ text moment.nativeLanguage ]
                                    ]
                                ]
                            ]
                        , div [ style [ ( "flex", "1" ) ] ]
                            [ div []
                                [ text (toString moment.time) ]
                            ]
                        ]
                      -- moment content
                    , div []
                        [ div [] [ text moment.content ]
                        , if List.length moment.pictures == 0 then
                            text ""
                          else
                            div [ style [ ( "display", "flex" ) ] ] <|
                                List.map
                                    (\picture ->
                                        div [ style [ ( "flex", "1" ) ] ]
                                            [ img [ src picture ] [] ]
                                    )
                                    moment.pictures
                        ]
                      -- moment comments
                    , div [] <|
                        List.map
                            (\comment ->
                                div [] [ text comment.message ]
                            )
                            moment.comments
                    ]
            )
            moments


main : Html msg
main =
    viewMoments mockMoments
