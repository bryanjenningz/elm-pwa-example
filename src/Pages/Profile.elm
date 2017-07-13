module Pages.Profile exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, src, style)
import Data exposing (Msg, User)
import MockData exposing (mockPicture)
import Pages.Moment exposing (viewMoment, viewLanguageLevel, stylePicture)


viewProfile : User -> Html Msg
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
                                ++ user.birthday
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
                    [ div [] [ text user.nativeLanguage.shortName ]
                    , viewLanguageLevel user.nativeLanguage.level
                    , div [] [ text user.nativeLanguage.name ]
                    ]
                , div [ class "col-1 pt-2" ] [ text ">" ]
                , div [ class "col-2" ]
                    [ div [] [ text user.learningLanguage.shortName ]
                    , viewLanguageLevel user.learningLanguage.level
                    , div [] [ text user.learningLanguage.name ]
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
                    [ div [ class "col-4" ]
                        [ div [ class "text-center text-primary" ] [ text "💬" ]
                        , div [ class "text-center text-muted" ]
                            [ text "Message" ]
                        ]
                    , div [ class "col-4" ]
                        [ div [ class "text-center text-primary" ] [ text "⊕" ]
                        , div [ class "text-center text-muted" ]
                            [ text "Follow" ]
                        ]
                    , div [ class "col-4" ]
                        [ div [ class "text-center text-primary" ] [ text "⚐" ]
                        , div [ class "text-center text-muted" ]
                            [ text "Block/Report" ]
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
                        (List.map2
                            viewMoment
                            (List.range 1 (List.length user.moments)
                                |> List.map (\_ -> user)
                            )
                            user.moments
                        )
                    ]
                ]
            ]
        ]


styleHeader : Attribute msg
styleHeader =
    style
        [ ( "position", "absolute" )
        , ( "left", "0" )
        , ( "right", "0" )
        , ( "height", "80px" )
        ]
