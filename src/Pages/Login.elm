module Pages.Login exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, placeholder, type_, checked, value)
import Html.Events exposing (onClick, onInput)
import Data exposing (Msg)
import MockData exposing (emptySignupInfo)


viewLogin : String -> String -> Bool -> Html Msg
viewLogin email password rememberPassword =
    div [ class "pb-4" ]
        [ div [ class "card mb-4" ]
            [ div [ class "card-block" ]
                [ div [ class "row" ]
                    [ div
                        [ class "col-2 text-center"
                        , onClick <| Data.UpdateLoginState Data.LandingPage
                        ]
                        [ text "✖" ]
                    , div [ class "col-7" ] [ text "Log In" ]
                    , div
                        [ class "col-1"
                        , onClick <|
                            Data.UpdateLoginState <|
                                Data.SignupPage emptySignupInfo Nothing
                        ]
                        [ text "SIGNUP" ]
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
                            Data.UpdateLoginState <|
                                Data.LoginPage newEmail password rememberPassword
                        )
                    ]
                    []
                ]
            ]
        , div [ class "row" ]
            [ div [ class "col-2" ] [ h2 [ class "text-center" ] [ text "🔒" ] ]
            , div [ class "col-9" ]
                [ input
                    [ class "form-control"
                    , placeholder "Password"
                    , value password
                    , onInput
                        (\newPassword ->
                            Data.UpdateLoginState <|
                                Data.LoginPage email newPassword rememberPassword
                        )
                    ]
                    []
                ]
            ]
        , div [ class "row" ]
            [ div [ class "offset-2 col-10" ]
                [ label []
                    [ input
                        [ type_ "checkbox"
                        , placeholder "Password"
                        , checked rememberPassword
                        , onClick <|
                            Data.UpdateLoginState <|
                                Data.LoginPage email password (not rememberPassword)
                        ]
                        []
                    , span [ class "text-muted" ] [ text " Remember Password" ]
                    ]
                ]
            ]
        , div [ class "row" ]
            [ div
                [ class "offset-2 col-6 text-muted"
                , onClick (Data.UpdateLoginState (Data.ForgotPasswordPage email))
                ]
                [ text "Forgot Password" ]
            , div [ class "col-3" ]
                [ button
                    [ class "btn btn-primary btn-block"
                    , onClick <| Data.LoginUser "mockemail@gmail.com" "mockpassword"
                    ]
                    [ text "LOGIN" ]
                ]
            ]
        ]
