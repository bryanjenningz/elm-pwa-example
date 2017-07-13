module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Dict exposing (Dict)
import Json.Decode as Decode
import Json.Encode as Encode
import Array exposing (Array)
import Http
import Regex
import Data exposing (Model, Msg(..), Moment, User, UserToken, Language, Talk, Message, Comment, Date, Route(..))
import MockData exposing (mockMoment, mockPicture, mockUser, mockMoments, mockTalks, mockSignupInfo, emptySignupInfo)
import Decoders exposing (decodeUser, decodeUserToken)
import Ports exposing (uploadPicture, getPicture, saveUserToken)
import Pages.Signup exposing (viewSignup)
import Pages.Login exposing (viewLogin)
import Pages.Profile exposing (viewProfile)
import Pages.Moment exposing (viewMoment, viewLanguageLevel, stylePicture)
import Pages.Talks exposing (viewTalks, viewTalk)
import Pages.Search exposing (viewSearch)


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


viewLandingPage : Html Msg
viewLandingPage =
    div [ class "text-center bg-primary", styleFullPage ]
        [ h1 [ class "text-white" ] [ text "Talk App" ]
        , h2 [ class "text-white" ] [ text "Talk to the World" ]
        , div [ class "row" ]
            [ div [ class "offset-1 col-10" ]
                [ button
                    [ class "btn btn-default form-control"
                    , onClick <| UpdateLoginState <| Data.SignupPage emptySignupInfo Nothing
                    ]
                    [ text "SIGN UP" ]
                ]
            ]
        , div [ class "text-white" ]
            [ text "Already have an account? "
            , u [ onClick <| UpdateLoginState <| Data.LoginPage "" "" True ]
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


view : Model -> Html Msg
view model =
    case model.user of
        Data.LoggedIn user ->
            case model.route of
                Data.RouteTalks ->
                    div [] [ viewTalks model.talks, viewBottomMenu model.route ]

                Data.RouteTalk talk ->
                    div [] [ viewTalk talk, viewBottomMenu model.route ]

                Data.RouteMoments ->
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

                Data.RouteSearch ->
                    div []
                        [ viewSearch model.searchUsers
                        , viewBottomMenu model.route
                        ]

                Data.RouteProfile user ->
                    div []
                        [ viewProfile user
                        , viewBottomMenu model.route
                        ]

        Data.LoginPage email password rememberPassword ->
            viewLogin email password rememberPassword

        Data.SignupPage signupInfo possibleError ->
            viewSignup signupInfo possibleError

        Data.LandingPage ->
            viewLandingPage

        Data.ForgotPasswordPage email ->
            viewForgotPassword email


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeRoute route ->
            ( { model | route = route }, Cmd.none )

        LoginUser email password ->
            ( model, loginUser email password )

        GetUserToken (Ok userToken) ->
            ( { model | user = Data.LoggedIn userToken }, saveUserToken userToken )

        GetUserToken (Err error) ->
            case model.user of
                Data.SignupPage signupInfo _ ->
                    ( { model | user = Data.SignupPage signupInfo (Just (Data.SignupHttpError error)) }, Cmd.none )

                _ ->
                    -- Fail silently because the user switched pages so they probably don't care about the error
                    ( model, Cmd.none )

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
                Data.SignupPage signupInfo possibleError ->
                    ( { model | user = Data.SignupPage { signupInfo | picture = picture } possibleError }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        Signup signupInfo ->
            let
                dateString : Date -> String
                dateString date =
                    [ date.month, date.day, date.year ]
                        |> List.map toString
                        |> String.join "-"

                body =
                    Http.jsonBody <|
                        Encode.object
                            [ ( "email", Encode.string signupInfo.email )
                            , ( "password", Encode.string signupInfo.password )
                            , ( "name", Encode.string signupInfo.name )
                            , ( "birthday", Encode.string (dateString signupInfo.birthday) )
                            , ( "isMan", Encode.bool signupInfo.isMan )
                            , ( "picture", Encode.string signupInfo.picture )
                            ]

                signupCmd =
                    Http.post "/api/signup" body decodeUserToken
                        |> Http.send GetUserToken
            in
                ( model, signupCmd )


loginUser : String -> String -> Cmd Msg
loginUser email password =
    let
        body =
            Http.jsonBody <|
                Encode.object
                    [ ( "email", Encode.string email )
                    , ( "password", Encode.string password )
                    ]
    in
        Http.post "/api/login" body decodeUserToken
            |> Http.send GetUserToken


fetchUser : Cmd Msg
fetchUser =
    Http.get "/user" decodeUser |> Http.send AddUser


type alias Flags =
    { maybeUserToken : Maybe UserToken }


init : Flags -> ( Model, Cmd Msg )
init { maybeUserToken } =
    case maybeUserToken of
        Nothing ->
            ( Model
                Data.RouteTalks
                (Data.SignupPage mockSignupInfo Nothing)
                mockTalks
                mockMoments
                (List.repeat 10 mockUser)
                Dict.empty
            , Cmd.none
            )

        Just userToken ->
            ( Model
                Data.RouteTalks
                (Data.LoggedIn userToken)
                mockTalks
                mockMoments
                (List.repeat 10 mockUser)
                Dict.empty
            , Cmd.none
            )


main : Program Flags Model Msg
main =
    programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = (\_ -> getPicture Data.GetPicture)
        }
