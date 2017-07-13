module Pages.Search exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import Data exposing (Msg(..), User)
import MockData exposing (mockPicture)
import Pages.Moment exposing (viewLanguageLevel, stylePicture)


viewSearch : List User -> Html Msg
viewSearch users =
    div [ class "row" ]
        [ div [ class "col-12 col-md-6 offset-md-3 pt-2" ]
            (List.map
                (\user ->
                    div
                        [ class "row mb-4"
                        , onClick <| ChangeRoute <| Data.RouteProfile user
                        ]
                        [ div [ class "col-2" ]
                            [ img [ stylePicture, src mockPicture ] [] ]
                        , div [ class "col-8" ]
                            [ div [] [ text user.name ]
                            , div [ class "row" ]
                                [ div [ class "col-3" ]
                                    [ div [] [ text user.nativeLanguage.shortName ]
                                    , viewLanguageLevel user.nativeLanguage.level
                                    ]
                                , div [ class "col-1 mr-4" ] [ text " > " ]
                                , div [ class "col-3" ]
                                    [ div [] [ text user.learningLanguage.shortName ]
                                    , viewLanguageLevel user.learningLanguage.level
                                    ]
                                ]
                            ]
                        , div [ class "col-2" ]
                            [ div []
                                [ text (toString user.lastLogin ++ "d") ]
                            , div [] [ text "☰" ]
                            ]
                        ]
                )
                users
            )
        ]
