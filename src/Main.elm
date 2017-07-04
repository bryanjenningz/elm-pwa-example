module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, classList, src, style, placeholder, type_, checked, value, selected)
import Html.Events exposing (..)
import Dict exposing (Dict)
import Json.Decode as Json
import Array exposing (Array)
import Http
import Regex
import Data exposing (Moment, User, Language, Talk, Message, Comment)
import MockData exposing (mockMoment, mockPicture, mockUser, mockMoments, mockTalks)
import Decoders exposing (decodeUser)
import Ports exposing (uploadPicture, getPicture)


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


viewMoment : User -> Moment -> Html Msg
viewMoment user moment =
    div []
        [ div [ class "row" ]
            [ div
                [ class "col-2" ]
                [ img
                    [ stylePicture
                    , src user.picture
                    , onClick <| ChangeRoute <| RouteProfile user
                    ]
                    []
                ]
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


viewTalks : List Talk -> Html Msg
viewTalks talks =
    div [ class "row" ]
        [ div [ class "col-12 offset-md-3 col-md-6 mt-4" ] <|
            List.map
                (\talk ->
                    div [ class "row mb-4" ]
                        [ div
                            [ class "col-2"
                            , onClick <| ChangeRoute <| RouteProfile talk.user
                            ]
                            [ img [ stylePicture, src mockPicture ] [] ]
                        , div
                            [ class "col-8"
                            , onClick <| ChangeRoute <| RouteTalk talk
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
                            , onClick <| ChangeRoute <| RouteTalk talk
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
                                , onClick (ChangeRoute (RouteProfile talk.user))
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


viewBottomMenu : Route -> Html Msg
viewBottomMenu route =
    let
        routeIndex =
            case route of
                RouteTalks ->
                    Just 0

                RouteMoments ->
                    Just 1

                RouteSearch ->
                    Just 2

                RouteProfile user ->
                    Just 3

                _ ->
                    Nothing
    in
        div [ class "row col-12 col-md-6 offset-md-3 pt-2", styleBottomMenu ]
            [ div
                [ class "col-3 text-center"
                , classList
                    [ ( "text-primary", routeIndex == Just 0 )
                    , ( "text-muted", routeIndex /= Just 0 )
                    ]
                , onClick <| ChangeRoute RouteTalks
                ]
                [ div [] [ text "💬" ]
                , div [] [ text "Talks" ]
                ]
            , div
                [ class "col-3 text-center"
                , classList
                    [ ( "text-primary", routeIndex == Just 1 )
                    , ( "text-muted", routeIndex /= Just 1 )
                    ]
                , onClick <| ChangeRoute RouteMoments
                ]
                [ div [] [ text "☰" ]
                , div [] [ text "Moments" ]
                ]
            , div
                [ class "col-3 text-center"
                , classList
                    [ ( "text-primary", routeIndex == Just 2 )
                    , ( "text-muted", routeIndex /= Just 2 )
                    ]
                , onClick <| ChangeRoute RouteSearch
                ]
                [ div [] [ text "🔍" ]
                , div [] [ text "Search" ]
                ]
            , div
                [ class "col-3 text-center"
                , classList
                    [ ( "text-primary", routeIndex == Just 3 )
                    , ( "text-muted", routeIndex /= Just 3 )
                    ]
                , onClick <| ChangeRoute <| RouteProfile mockUser
                ]
                [ div [] [ text "👤" ]
                , div [] [ text "Profile" ]
                ]
            ]


styleBottomMenu : Attribute msg
styleBottomMenu =
    style
        [ ( "position", "fixed" )
        , ( "bottom", "0" )
        , ( "background", "white" )
        , ( "box-shadow", "0px 0px 10px 0px #888888" )
        ]


viewSearch : List User -> Html Msg
viewSearch users =
    div [ class "row" ]
        [ div [ class "col-12 col-md-6 offset-md-3 pt-2" ]
            (List.map
                (\user ->
                    div
                        [ class "row mb-4"
                        , onClick <| ChangeRoute <| RouteProfile user
                        ]
                        [ div [ class "col-2" ]
                            [ img [ stylePicture, src mockPicture ] [] ]
                        , div [ class "col-8" ]
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


emptySignupInfo : SignupInfo
emptySignupInfo =
    SignupInfo "" "" "" defaultDate True ""


defaultDate : Date
defaultDate =
    Date 1996 1 1


viewLogin : String -> String -> Bool -> Html Msg
viewLogin email password rememberPassword =
    div [ class "pb-4" ]
        [ div [ class "card mb-4" ]
            [ div [ class "card-block" ]
                [ div [ class "row" ]
                    [ div
                        [ class "col-2 text-center"
                        , onClick <| UpdateLoginState LandingPage
                        ]
                        [ text "✖" ]
                    , div [ class "col-7" ] [ text "Log In" ]
                    , div
                        [ class "col-1"
                        , onClick <|
                            UpdateLoginState <|
                                SignupPage emptySignupInfo Nothing
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
                            UpdateLoginState <|
                                LoginPage newEmail password rememberPassword
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
                            UpdateLoginState <|
                                LoginPage email newPassword rememberPassword
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
                            UpdateLoginState <|
                                LoginPage email password (not rememberPassword)
                        ]
                        []
                    , span [ class "text-muted" ] [ text " Remember Password" ]
                    ]
                ]
            ]
        , div [ class "row" ]
            [ div
                [ class "offset-2 col-6 text-muted"
                , onClick (UpdateLoginState (ForgotPasswordPage email))
                ]
                [ text "Forgot Password" ]
            , div [ class "col-3" ]
                [ button
                    [ class "btn btn-primary btn-block"
                    , onClick <| LoginUser "mockemail@gmail.com" "mockpassword"
                    ]
                    [ text "LOGIN" ]
                ]
            ]
        ]


monthToDays : Array Int
monthToDays =
    Array.fromList
        [ 0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ]


months : List String
months =
    [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec" ]


days : Int -> List String
days month =
    let
        dayCount =
            monthToDays
                |> Array.get month
                |> Maybe.withDefault 0
    in
        List.range 1 dayCount |> List.map toString


years : List String
years =
    List.range 1926 2009 |> List.map toString


isValidEmail : String -> Bool
isValidEmail email =
    Regex.contains (Regex.regex """^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$""") email


isValidPassword : String -> Bool
isValidPassword password =
    String.length password |> (\length -> 6 <= length && length <= 255)


isValidName : String -> Bool
isValidName name =
    name |> String.trim |> String.length |> (\length -> 1 <= length && length <= 20)


validateSignup : SignupInfo -> Msg
validateSignup signupInfo =
    if not <| isValidEmail signupInfo.email then
        UpdateLoginState (SignupPage signupInfo (Just InvalidEmail))
    else if not <| isValidPassword signupInfo.password then
        UpdateLoginState (SignupPage signupInfo (Just InvalidPassword))
    else if not <| isValidName signupInfo.name then
        UpdateLoginState (SignupPage signupInfo (Just NoName))
    else if signupInfo.picture == "" then
        UpdateLoginState (SignupPage signupInfo (Just NoPicture))
    else
        Signup signupInfo


viewSignup : SignupInfo -> Maybe SignupError -> Html Msg
viewSignup signupInfo possibleError =
    div [ class "pb-4" ]
        [ viewSignupError signupInfo possibleError
        , div [ class "card mb-4" ]
            [ div [ class "card-block" ]
                [ div [ class "row" ]
                    [ div
                        [ class "col-2 text-center"
                        , onClick <| UpdateLoginState LandingPage
                        ]
                        [ text "✖" ]
                    , div [ class "col-7" ] [ text "Sign Up" ]
                    , div
                        [ class "col-1"
                        , onClick <| validateSignup signupInfo
                        ]
                        [ text "NEXT" ]
                    ]
                ]
            ]
        , div [ class "row" ]
            [ div [ class "col-2" ] [ h2 [ class "text-center" ] [ text "📧" ] ]
            , div [ class "col-9" ]
                [ input
                    [ class "form-control"
                    , placeholder "Email"
                    , value signupInfo.email
                    , onInput
                        (\newEmail ->
                            UpdateLoginState <|
                                SignupPage { signupInfo | email = newEmail } possibleError
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
                    , type_ "password"
                    , value signupInfo.password
                    , onInput
                        (\newPassword ->
                            UpdateLoginState <|
                                SignupPage { signupInfo | password = newPassword } possibleError
                        )
                    ]
                    []
                ]
            ]
        , div [ class "row" ]
            [ div [ class "col-2" ] [ h2 [ class "text-center" ] [ text "👤" ] ]
            , div [ class "col-9" ]
                [ input
                    [ class "form-control"
                    , placeholder "Name"
                    , value signupInfo.name
                    , onInput
                        (\newName ->
                            UpdateLoginState <|
                                SignupPage { signupInfo | name = newName } possibleError
                        )
                    ]
                    []
                ]
            ]
        , div [ class "row" ]
            [ div [ class "col-2" ] [ h2 [ class "text-center" ] [ text "🎂" ] ]
            , div [ class "col-9" ] [ viewDate signupInfo possibleError ]
            ]
        , div [ class "row mt-4" ]
            [ div [ class "offset-2 col-9" ]
                [ div
                    [ class "row" ]
                    [ div [ class "col-6" ]
                        [ h2
                            [ class "d-inline"
                            , classList [ ( "text-primary", signupInfo.isMan ) ]
                            , onClick <|
                                UpdateLoginState
                                    (SignupPage { signupInfo | isMan = True } possibleError)
                            ]
                            [ text " 👤 ♂ " ]
                        , h2
                            [ class "d-inline"
                            , classList [ ( "text-primary", not signupInfo.isMan ) ]
                            , onClick <|
                                UpdateLoginState
                                    (SignupPage { signupInfo | isMan = False } possibleError)
                            ]
                            [ text " 👤 ♀ " ]
                        ]
                    , div [ class "col-6" ]
                        [ h1
                            [ class "d-inline bg-faded float-right"
                            , classList [ ( "p-4", signupInfo.picture == "" ) ]
                            , style [ ( "border-radius", "50%" ) ]
                            , onClick UploadPicture
                            ]
                            [ if signupInfo.picture == "" then
                                text "📷"
                              else
                                img
                                    [ style
                                        -- 88px known by calling getComputedStyle(element).width
                                        [ ( "width", "88px" )
                                        , ( "height", "88px" )
                                        , ( "border-radius", "50%" )
                                        ]
                                    , src signupInfo.picture
                                    ]
                                    []
                            ]
                        ]
                    ]
                ]
            ]
        ]


viewSignupError : SignupInfo -> Maybe SignupError -> Html Msg
viewSignupError signupInfo possibleError =
    case possibleError of
        Nothing ->
            text ""

        Just signupError ->
            div
                [ style
                    [ ( "display", "flex" )
                    , ( "justify-content", "center" )
                    , ( "z-index", "1" )
                    ]
                ]
                [ div
                    [ style [ ( "flex", "1" ) ] ]
                    [ case signupError of
                        InvalidEmail ->
                            text "Invalid Email Address"

                        InvalidPassword ->
                            text "Password needs to be at least 6 characters long"

                        NoName ->
                            text "Please input your username"

                        NoBirthday ->
                            text "Please enter your birthday"

                        NoGender ->
                            text "Please select your gender"

                        NoPicture ->
                            text "Profile picture is required"
                    ]
                , div []
                    [ button
                        [ class "btn btn-primary btn-block"
                        , onClick (UpdateLoginState (SignupPage signupInfo Nothing))
                        ]
                        [ text "Ok" ]
                    ]
                ]


viewDate : SignupInfo -> Maybe SignupError -> Html Msg
viewDate ({ birthday } as signupInfo) possibleError =
    div [ class "row" ]
        [ div [ class "col-4 pr-0" ]
            [ select
                [ class "form-control"
                , onChange
                    (\month ->
                        String.toInt month
                            |> Result.withDefault birthday.month
                            |> (\selectedMonth ->
                                    UpdateLoginState <|
                                        SignupPage { signupInfo | birthday = { birthday | month = selectedMonth } } possibleError
                               )
                    )
                ]
                (List.indexedMap
                    (\index month ->
                        option
                            [ value (toString (index + 1))
                            , selected ((index + 1) == birthday.month)
                            ]
                            [ text month ]
                    )
                    months
                )
            ]
        , div [ class "col-4 px-0" ]
            [ select
                [ class "form-control"
                , onChange
                    (\day ->
                        String.toInt day
                            |> Result.withDefault birthday.day
                            |> (\selectedDay ->
                                    UpdateLoginState <|
                                        SignupPage { signupInfo | birthday = { birthday | day = selectedDay } } possibleError
                               )
                    )
                ]
                (List.indexedMap
                    (\index day ->
                        option
                            [ value (toString (index + 1))
                            , selected (birthday.day == (index + 1))
                            ]
                            [ text day ]
                    )
                    (days birthday.month)
                )
            ]
        , div [ class "col-4 pl-0" ]
            [ select
                [ class "form-control"
                , onChange
                    (\year ->
                        String.toInt year
                            |> Result.withDefault birthday.year
                            |> (\selectedYear ->
                                    UpdateLoginState <|
                                        SignupPage { signupInfo | birthday = { birthday | year = selectedYear } } possibleError
                               )
                    )
                ]
                (List.map
                    (\year ->
                        option
                            [ value year, selected (year == toString birthday.year) ]
                            [ text year ]
                    )
                    years
                )
            ]
        ]


onChange : (String -> Msg) -> Attribute Msg
onChange message =
    on "change" (Json.map message targetValue)


viewLandingPage : Html Msg
viewLandingPage =
    div [ class "text-center bg-primary", styleFullPage ]
        [ h1 [ class "text-white" ] [ text "Talk App" ]
        , h2 [ class "text-white" ] [ text "Talk to the World" ]
        , div [ class "row" ]
            [ div [ class "offset-1 col-10" ]
                [ button
                    [ class "btn btn-default form-control"
                    , onClick <| UpdateLoginState <| SignupPage emptySignupInfo Nothing
                    ]
                    [ text "SIGN UP" ]
                ]
            ]
        , div [ class "text-white" ]
            [ text "Already have an account? "
            , u [ onClick <| UpdateLoginState <| LoginPage "" "" True ]
                [ text "Log In" ]
            ]
        ]


styleFullPage : Attribute msg
styleFullPage =
    style
        [ ( "position", "absolute" )
        , ( "left", "0" )
        , ( "right", "0" )
        , ( "top", "0" )
        , ( "bottom", "0" )
        ]


viewForgotPassword : String -> Html Msg
viewForgotPassword email =
    div [ class "pb-4" ]
        [ div [ class "card mb-4" ]
            [ div [ class "card-block" ]
                [ div [ class "row" ]
                    [ div
                        [ class "col-2 text-center"
                        , onClick <| UpdateLoginState LandingPage
                        ]
                        [ text "✖" ]
                    , div [ class "col-7" ] [ text "Forgot Password" ]
                    , div
                        [ class "col-1"
                        , onClick (UpdateLoginState (LoginPage "" "" True))
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
                            UpdateLoginState (ForgotPasswordPage newEmail)
                        )
                    ]
                    []
                ]
            ]
        ]


view : Model -> Html Msg
view model =
    case model.user of
        LoggedIn user ->
            case model.route of
                RouteTalks ->
                    div [] [ viewTalks model.talks, viewBottomMenu model.route ]

                RouteTalk talk ->
                    div [] [ viewTalk talk, viewBottomMenu model.route ]

                RouteMoments ->
                    div []
                        [ div [ class "row" ]
                            [ div [ class "col-12 col-md-6 offset-md-3 pt-2" ]
                                (List.map
                                    (\moment ->
                                        viewMoment
                                            (Dict.get moment.userId model.userById
                                                |> Maybe.withDefault mockUser
                                            )
                                            moment
                                    )
                                    model.moments
                                )
                            ]
                        , viewBottomMenu model.route
                        ]

                RouteSearch ->
                    div []
                        [ viewSearch model.searchUsers
                        , viewBottomMenu model.route
                        ]

                RouteProfile user ->
                    div []
                        [ viewProfile user
                        , viewBottomMenu model.route
                        ]

        LoginPage email password rememberPassword ->
            viewLogin email password rememberPassword

        SignupPage signupInfo possibleError ->
            viewSignup signupInfo possibleError

        LandingPage ->
            viewLandingPage

        ForgotPasswordPage email ->
            viewForgotPassword email


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeRoute route ->
            ( { model | route = route }, Cmd.none )

        LoginUser email password ->
            ( model, loginUser email password )

        GetUser (Ok user) ->
            ( { model | user = LoggedIn user }, Cmd.none )

        GetUser (Err err) ->
            ( { model | user = LoggedIn mockUser }, Cmd.none )

        AddUser (Ok user) ->
            ( { model | userById = Dict.insert user.id user model.userById }
            , Cmd.none
            )

        AddUser (Err error) ->
            ( model, fetchUser )

        UpdateLoginState userLoginState ->
            ( { model | user = userLoginState }, Cmd.none )

        UploadPicture ->
            ( model, uploadPicture () )

        GetPicture picture ->
            case model.user of
                SignupPage signupInfo possibleError ->
                    ( { model | user = SignupPage { signupInfo | picture = picture } possibleError }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        Signup signupInfo ->
            let
                dateString : Date -> String
                dateString date =
                    [ date.year, date.month, date.day ]
                        |> List.map toString
                        |> String.join "-"

                body =
                    Http.multipartBody
                        [ Http.stringPart "email" signupInfo.email
                        , Http.stringPart "password" signupInfo.password
                        , Http.stringPart "name" signupInfo.name
                        , Http.stringPart "birthday" (dateString signupInfo.birthday)
                        , Http.stringPart "isMan" (toString signupInfo.isMan)
                        , Http.stringPart "picture" signupInfo.picture
                        ]

                signupCmd =
                    Http.post "/signup" body decodeUser
                        |> Http.send GetUser
            in
                ( model, signupCmd )


loginUser : String -> String -> Cmd Msg
loginUser email password =
    let
        body =
            Http.multipartBody
                [ Http.stringPart "email" email
                , Http.stringPart "password" password
                ]
    in
        Http.post "/login" body decodeUser
            |> Http.send GetUser


fetchUser : Cmd Msg
fetchUser =
    Http.get "/user" decodeUser |> Http.send AddUser


type Route
    = RouteTalks
    | RouteTalk Talk
    | RouteMoments
    | RouteSearch
    | RouteProfile User


type Msg
    = ChangeRoute Route
    | LoginUser String String
    | GetUser (Result Http.Error User)
    | AddUser (Result Http.Error User)
    | UpdateLoginState UserLoginState
    | UploadPicture
    | GetPicture String
    | Signup SignupInfo


type alias Model =
    { route : Route
    , user : UserLoginState
    , talks : List Talk
    , moments : List Moment
    , searchUsers : List User
    , userById : Dict String User
    }


type alias Date =
    { year : Int
    , month : Int
    , day : Int
    }


type alias SignupInfo =
    { email : String
    , password : String
    , name : String
    , birthday : Date
    , isMan : Bool
    , picture : String
    }


type SignupError
    = InvalidEmail
    | InvalidPassword
    | NoName
    | NoBirthday
    | NoGender
    | NoPicture


type UserLoginState
    = LandingPage
    | LoginPage String String Bool
    | ForgotPasswordPage String
    | SignupPage SignupInfo (Maybe SignupError)
    | LoggedIn User


main : Program Never Model Msg
main =
    program
        { init =
            ( Model
                RouteTalks
                (SignupPage emptySignupInfo Nothing)
                mockTalks
                mockMoments
                (List.repeat 10 mockUser)
                Dict.empty
            , Cmd.none
            )
        , view = view
        , update = update
        , subscriptions = (\_ -> getPicture GetPicture)
        }
