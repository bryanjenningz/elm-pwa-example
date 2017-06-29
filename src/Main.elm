module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, classList, src, style, placeholder)
import Html.Events exposing (..)


mockMoment : Moment
mockMoment =
    { userId = "id_example123"
    , pictures = mockPictures
    , text =
        List.range 1 10
            |> List.map (always "test moment ")
            |> List.foldl (++) ""
    , likes = 2
    , comments = mockComments
    }


mockMoments : List Moment
mockMoments =
    List.repeat 10 mockMoment


mockPicture : String
mockPicture =
    "http://s3.amazonaws.com/37assets/svn/765-default-avatar.png"


mockPictures : List String
mockPictures =
    List.repeat 9 mockPicture


mockComments : List Comment
mockComments =
    List.range 1 3
        |> List.map
            (\i ->
                if i % 2 == 0 then
                    Comment
                        "id_example123"
                        "example name"
                        "test reply 123!!!"
                else
                    Comment
                        "id_abe123"
                        "abe name"
                        "this is just a test reply, I hope this reply is not too long"
            )


type alias Comment =
    { userId : String
    , name : String
    , text : String
    }


type alias Moment =
    { userId : String
    , pictures : List String
    , text : String
    , likes : Int
    , comments : List Comment
    }


type alias Language =
    { shortName : String
    , name : String
    , level : Int
    }


type alias User =
    { id : String
    , name : String
    , email : String
    , age : Int
    , isMan : Bool
    , lastLogin : Int
    , location : String
    , localTime : String
    , learning : Language
    , native : Language
    , corrections : Int
    , savedWords : Int
    , audioLookups : Int
    , translationLookups : Int
    , bookmarks : Int
    , intro : String
    , interests : List String
    , picture : String
    , moments : List Moment
    }


mockUser : User
mockUser =
    { id = "id_example123"
    , name = "example name"
    , email = "example@example.com"
    , age = 99
    , isMan = True
    , lastLogin = 20
    , location = "Pleasantville, Pleasant Country"
    , localTime = "7:38 PM"
    , learning = Language "EN" "English" 2
    , native = Language "CN" "中文" 5
    , corrections = 22
    , savedWords = 34
    , audioLookups = 5
    , translationLookups = 2
    , bookmarks = 0
    , intro =
        List.range 1 10
            |> List.map (\_ -> "this is a test intro")
            |> String.join ", "
    , interests = [ "Music", "Soccer", "Movies" ]
    , picture = mockPicture
    , moments = mockMoments
    }


viewProfile : User -> Html msg
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


viewMoment : User -> Moment -> Html msg
viewMoment user moment =
    div []
        [ div [ class "row" ]
            [ div [ class "col-2" ]
                [ img [ stylePicture, src user.picture ] [] ]
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


type alias Message =
    { user : User
    , time : Int
    , text : String
    , read : Bool
    }


type alias Talk =
    { user : User
    , messages : List Message
    }


viewTalks : List Talk -> Html msg
viewTalks talks =
    div [ class "row" ]
        [ div [ class "col-12 offset-md-3 col-md-6 mt-4" ] <|
            List.map
                (\talk ->
                    div [ class "row mb-4" ]
                        [ div [ class "col-2" ]
                            [ img [ stylePicture, src mockPicture ] [] ]
                        , div [ class "col-8" ]
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
                        , div [ class "col-2" ]
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


mockMessage : Message
mockMessage =
    Message mockUser 10000000 "Hello" True


mockTalks : List Talk
mockTalks =
    List.repeat 10 (Talk mockUser (List.repeat 10 mockMessage))


viewSearch : List User -> Html Msg
viewSearch users =
    div [ class "row col-12 col-md-6 offset-md-3 pt-2" ]
        (List.map
            (\user ->
                div [ class "row mb-4" ]
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


view : Model -> Html Msg
view model =
    case model.route of
        RouteTalks ->
            div [] [ viewTalks mockTalks, viewBottomMenu model.route ]

        RouteTalk talk ->
            div [] [ viewTalk talk, viewBottomMenu model.route ]

        RouteMoments ->
            div []
                [ div [ class "row col-12 col-md-6 offset-md-3 pt-2" ]
                    (List.map2
                        viewMoment
                        (List.repeat (List.length mockMoments) mockUser)
                        mockMoments
                    )
                , viewBottomMenu model.route
                ]

        RouteSearch ->
            div []
                [ viewSearch (List.repeat 10 mockUser)
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


type Route
    = RouteTalks
    | RouteTalk Talk
    | RouteMoments
    | RouteSearch
    | RouteProfile User


type Msg
    = ChangeRoute Route


type alias Model =
    { route : Route
    }


main : Program Never Model Msg
main =
    program
        { init = ( Model RouteTalks, Cmd.none )
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }
