module Pages.Signup exposing (..)

import Html exposing (..)
import Html.Attributes exposing (selected, value, class, style, src, classList, placeholder, type_)
import Html.Events exposing (onClick, onInput, targetValue, on)
import Data exposing (Msg, SignupError, SignupInfo)
import Array exposing (Array)
import Http
import Regex
import Json.Decode as Decode


onChange : (String -> Msg) -> Attribute Msg
onChange message =
    on "change" (Decode.map message targetValue)


isValidName : String -> Bool
isValidName name =
    name |> String.trim |> String.length |> (\length -> 2 <= length && length <= 30)


validateSignup : SignupInfo -> Msg
validateSignup signupInfo =
    if not <| isValidEmail signupInfo.email then
        Data.UpdateLoginState (Data.SignupPage signupInfo (Just Data.InvalidEmail))
    else if not <| isValidPassword signupInfo.password then
        Data.UpdateLoginState (Data.SignupPage signupInfo (Just Data.InvalidPassword))
    else if not <| isValidName signupInfo.name then
        Data.UpdateLoginState (Data.SignupPage signupInfo (Just Data.NoName))
    else if signupInfo.picture == "" then
        Data.UpdateLoginState (Data.SignupPage signupInfo (Just Data.NoPicture))
    else
        Data.Signup signupInfo


isValidEmail : String -> Bool
isValidEmail email =
    Regex.contains (Regex.regex """^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$""") email


isValidPassword : String -> Bool
isValidPassword password =
    String.length password |> (\length -> 6 <= length && length <= 255)


viewSignup : SignupInfo -> Maybe SignupError -> Html Msg
viewSignup signupInfo possibleError =
    div [ class "pb-4" ]
        [ viewSignupError signupInfo possibleError
        , div [ class "card mb-4" ]
            [ div [ class "card-block" ]
                [ div [ class "row" ]
                    [ div
                        [ class "col-2 text-center"
                        , onClick <| Data.UpdateLoginState Data.LandingPage
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
                            Data.UpdateLoginState <|
                                Data.SignupPage { signupInfo | email = newEmail } possibleError
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
                            Data.UpdateLoginState <|
                                Data.SignupPage { signupInfo | password = newPassword } possibleError
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
                            Data.UpdateLoginState <|
                                Data.SignupPage { signupInfo | name = newName } possibleError
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
                                Data.UpdateLoginState
                                    (Data.SignupPage { signupInfo | isMan = True } possibleError)
                            ]
                            [ text " 👤 ♂ " ]
                        , h2
                            [ class "d-inline"
                            , classList [ ( "text-primary", not signupInfo.isMan ) ]
                            , onClick <|
                                Data.UpdateLoginState
                                    (Data.SignupPage { signupInfo | isMan = False } possibleError)
                            ]
                            [ text " 👤 ♀ " ]
                        ]
                    , div [ class "col-6" ]
                        [ h1
                            [ class "d-inline bg-faded float-right"
                            , classList [ ( "p-4", signupInfo.picture == "" ) ]
                            , style [ ( "border-radius", "50%" ) ]
                            , onClick Data.UploadPicture
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
            let
                errorText =
                    case signupError of
                        Data.InvalidEmail ->
                            text "Invalid Email Address"

                        Data.InvalidPassword ->
                            text "Password needs to be at least 6 characters long"

                        Data.NoName ->
                            text "Your name can be from 2 to 30 characters long"

                        Data.NoBirthday ->
                            text "Please enter your birthday"

                        Data.NoGender ->
                            text "Please select your gender"

                        Data.NoPicture ->
                            text "Profile picture is required"

                        Data.SignupHttpError httpError ->
                            case httpError of
                                Http.BadUrl error ->
                                    text ("The url was bad: " ++ error)

                                Http.Timeout ->
                                    text "The request timed out, maybe try again"

                                Http.NetworkError ->
                                    text "There was a network error, make sure you're connected to the internet and try again"

                                Http.BadStatus response ->
                                    -- text ("The server returned a bad status: " ++ toString response)
                                    text "This email is already being used, please use a different email"

                                Http.BadPayload decoderProblem response ->
                                    text ("Bad payload: " ++ decoderProblem ++ ", Response: " ++ toString response)
            in
                div []
                    [ div
                        [ style
                            [ ( "position", "absolute" )
                            , ( "z-index", "2" )
                            , ( "width", "100%" )
                            , ( "top", "25%" )
                            ]
                        ]
                        [ div [ class "modal-content" ]
                            [ div [ class "modal-header" ]
                                [ h5 [ class "modal-title" ]
                                    [ text "Signup Error" ]
                                , button
                                    [ class "close"
                                    , onClick <|
                                        Data.UpdateLoginState <|
                                            Data.SignupPage signupInfo Nothing
                                    ]
                                    [ text "×" ]
                                ]
                            , div [ class "modal-body" ]
                                [ p [] [ errorText ] ]
                            , div [ class "modal-footer" ]
                                [ button
                                    [ class "btn btn-primary btn-block"
                                    , onClick <|
                                        Data.UpdateLoginState <|
                                            Data.SignupPage signupInfo Nothing
                                    ]
                                    [ text "Close" ]
                                ]
                            ]
                        ]
                    , div
                        [ style
                            [ ( "position", "absolute" )
                            , ( "z-index", "1" )
                            , ( "width", "100%" )
                            , ( "height", "100%" )
                            , ( "background", "rgba(0,0,0,0.5)" )
                            ]
                        ]
                        []
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
                                    Data.UpdateLoginState <|
                                        Data.SignupPage { signupInfo | birthday = { birthday | month = selectedMonth } } possibleError
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
                                    Data.UpdateLoginState <|
                                        Data.SignupPage { signupInfo | birthday = { birthday | day = selectedDay } } possibleError
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
                                    Data.UpdateLoginState <|
                                        Data.SignupPage { signupInfo | birthday = { birthday | year = selectedYear } } possibleError
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


years : List String
years =
    List.range 1926 2009 |> List.map toString


days : Int -> List String
days month =
    let
        dayCount =
            monthToDays
                |> Array.get month
                |> Maybe.withDefault 0
    in
        List.range 1 dayCount |> List.map toString


months : List String
months =
    [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec" ]


monthToDays : Array Int
monthToDays =
    Array.fromList
        [ 0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ]
