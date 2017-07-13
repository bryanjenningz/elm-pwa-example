module Pages.Talks exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, src, placeholder)
import Html.Events exposing (onClick)
import Data exposing (Msg(..), Talk)
import MockData exposing (mockPicture)
import Pages.Moment exposing (stylePicture)


viewTalks : List Talk -> Html Msg
viewTalks talks =
    div [ class "row" ]
        [ div [ class "col-12 offset-md-3 col-md-6 mt-4" ] <|
            List.map
                (\talk ->
                    div [ class "row mb-4" ]
                        [ div
                            [ class "col-2"
                            , onClick <| ChangeRoute <| Data.RouteProfile talk.user
                            ]
                            [ img [ stylePicture, src mockPicture ] [] ]
                        , div
                            [ class "col-8"
                            , onClick <| ChangeRoute <| Data.RouteTalk talk
                            ]
                            [ div [] [ text talk.user.name ]
                            , div []
                                [ text
                                    (talk.messages
                                        |> List.head
                                        |> Maybe.map .text
                                        |> Maybe.withDefault ""
                                    )
                                ]
                            ]
                        , div
                            [ class "col-2"
                            , onClick <| ChangeRoute <| Data.RouteTalk talk
                            ]
                            [ div []
                                [ text (toString talk.user.lastLogin ++ "d") ]
                            , case
                                (talk.messages
                                    |> List.filter (not << .read)
                                    |> List.length
                                )
                              of
                                0 ->
                                    div [] [ text "↩" ]

                                unreadCount ->
                                    div [ class "badge badge-pill badge-danger" ]
                                        [ text (toString unreadCount) ]
                            , div [] []
                            ]
                        ]
                )
                talks
        , div [ class "pt-4 pb-4 mt-4 text-center" ] [ text "." ]
        ]


viewTalk : Talk -> Html Msg
viewTalk talk =
    div []
        [ div []
            (List.map
                (\message ->
                    div [ class "row" ]
                        [ div [ class "col-3" ]
                            [ img
                                [ stylePicture
                                , src message.user.picture
                                , onClick (ChangeRoute (Data.RouteProfile talk.user))
                                ]
                                []
                            ]
                        , div [ class "col-9" ] [ text message.text ]
                        ]
                )
                talk.messages
            )
        , div []
            [ input
                [ class "form-control", placeholder "Type a message..." ]
                []
            ]
        ]
