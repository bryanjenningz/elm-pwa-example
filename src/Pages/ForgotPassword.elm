module Pages.ForgotPassword exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, placeholder, value)
import Html.Events exposing (onInput, onClick)
import Data exposing (Msg(..))


viewForgotPassword : String -> Html Msg
viewForgotPassword email =
    div [ class "pb-4" ]
        [ div [ class "card mb-4" ]
            [ div [ class "card-block" ]
                [ div [ class "row" ]
                    [ div
                        [ class "col-2 text-center"
                        , onClick <| UpdateLoginState Data.LandingPage
                        ]
                        [ text "✖" ]
                    , div [ class "col-7" ] [ text "Forgot Password" ]
                    , div
                        [ class "col-1"
                        , onClick (UpdateLoginState (Data.LoginPage "" "" True))
                        ]
                        [ text "SEND" ]
                    ]
                ]
            ]
        , div [ class "row" ]
            [ div [ class "col-2" ] [ h2 [ class "text-center" ] [ text "📧" ] ]
            , div [ class "col-9" ]
                [ input
                    [ class "form-control"
                    , placeholder "Email"
                    , value email
                    , onInput
                        (\newEmail ->
                            UpdateLoginState (Data.ForgotPasswordPage newEmail)
                        )
                    ]
                    []
                ]
            ]
        ]
