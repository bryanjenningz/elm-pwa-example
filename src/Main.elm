module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, classList, src, style, placeholder)
import Html.Events exposing (..)
import Dict exposing (Dict)
import Http
import Json.Decode
import Json.Decode.Pipeline
import Data exposing (Moment, User, Language, Talk, Message, Comment)
import MockData exposing (mockMoment, mockPicture, mockUser, mockMoments, mockTalks)


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


viewTalk : Talk -> Html msg
viewTalk talk =
    div []
        [ div []
            (List.map
                (\message ->
                    div [ class "row" ]
                        [ div [ class "col-3" ] [ text message.text ]
                        , div [ class "col-9" ] [ text message.user.name ]
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


view : Model -> Html Msg
view model =
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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeRoute route ->
            ( { model | route = route }, Cmd.none )

        GetUser (Ok user) ->
            ( { model | user = user }, Cmd.none )

        GetUser (Err error) ->
            ( model, getUser )


getUser : Cmd Msg
getUser =
    Http.get "/user" decodeUser |> Http.send GetUser


decodeUser : Json.Decode.Decoder User
decodeUser =
    Json.Decode.Pipeline.decode User
        |> Json.Decode.Pipeline.required "id" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "email" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "age" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "isMan" (Json.Decode.bool)
        |> Json.Decode.Pipeline.required "lastLogin" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "location" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "localTime" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "learning" (decodeLanguage)
        |> Json.Decode.Pipeline.required "native" (decodeLanguage)
        |> Json.Decode.Pipeline.required "corrections" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "savedWords" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "audioLookups" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "translationLookups" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "bookmarks" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "intro" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "interests" (Json.Decode.list Json.Decode.string)
        |> Json.Decode.Pipeline.required "picture" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "moments" (Json.Decode.list decodeMoment)


decodeLanguage : Json.Decode.Decoder Language
decodeLanguage =
    Json.Decode.Pipeline.decode Language
        |> Json.Decode.Pipeline.required "shortName" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "level" (Json.Decode.int)


decodeMoment : Json.Decode.Decoder Moment
decodeMoment =
    Json.Decode.Pipeline.decode Moment
        |> Json.Decode.Pipeline.required "userId" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "pictures" (Json.Decode.list Json.Decode.string)
        |> Json.Decode.Pipeline.required "text" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "likes" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "comments" (Json.Decode.list decodeComment)


decodeComment : Json.Decode.Decoder Comment
decodeComment =
    Json.Decode.Pipeline.decode Comment
        |> Json.Decode.Pipeline.required "userId" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "name" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "text" (Json.Decode.string)


type Route
    = RouteTalks
    | RouteTalk Talk
    | RouteMoments
    | RouteSearch
    | RouteProfile User


type Msg
    = ChangeRoute Route
    | GetUser (Result Http.Error User)


type alias Model =
    { route : Route
    , user : User
    , talks : List Talk
    , moments : List Moment
    , userById : Dict String User
    , searchUsers : List User
    }


main : Program Never Model Msg
main =
    program
        { init =
            ( Model
                RouteTalks
                mockUser
                mockTalks
                mockMoments
                Dict.empty
                (List.repeat 10 mockUser)
            , Cmd.none
            )
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }
