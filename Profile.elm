module Profile exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


mockUser : UserProfile
mockUser =
    { id = "id_bryan123"
    , name = "Bryan"
    , picture = "http://s3.amazonaws.com/37assets/svn/765-default-avatar.png"
    , lastLogin = 20
    , age = 99
    , gender = "M"
    , location = "Sunnyvale, CA, USA"
    , learningLanguage = "Chinese"
    , nativeLanguage = "English"
    , corrections = 6
    , savedWords = 2
    , following = True
    , intro = "I'm Bryan"
    , hobbies = [ "Parkour", "Cello" ]
    , moments = []
    }


type alias Date =
    { day : Int
    , month : Int
    , year : Int
    }


type alias Moment =
    { text : String
    , pictures : List String
    , likes : Int
    , comments : List String
    }


type alias UserProfile =
    { id : String
    , name : String
    , picture : String
    , lastLogin : Int
    , age : Int
    , gender : String
    , location : String
    , learningLanguage : String
    , nativeLanguage : String
    , corrections : Int
    , savedWords : Int
    , following : Bool
    , intro : String
    , hobbies : List String
    , moments : List Moment
    }


viewProfile : UserProfile -> Html a
viewProfile user =
    div []
        [ viewProfileHeader user
        , viewProfileInfo user
        , viewProfileInteraction user
        , viewProfileIntro user
        , viewProfileMoments user
        ]


viewProfileHeader : UserProfile -> Html a
viewProfileHeader user =
    div [ style [ ( "display", "flex" ), ( "flex-direction", "column" ), ( "height", "20%" ) ] ]
        [ div [ style [ ( "flex", "1" ), ( "background", "#0dcece" ), ( "margin-bottom", "-30px" ) ] ] []
        , div [ style [ ( "flex", "1" ) ] ]
            [ div [ style [ ( "display", "flex" ), ( "flex-direction", "row" ) ] ]
                [ div [ style [ ( "flex", "5" ) ] ]
                    [ span [ style [ ( "padding", "4px" ), ( "background", "#cccccc" ), ( "border-radius", "4px" ) ] ]
                        [ text (toString user.lastLogin ++ "d") ]
                    ]
                , div [ style [ ( "flex", "2" ) ] ]
                    [ img
                        [ src user.picture
                        , style [ ( "width", "100%" ), ( "border-radius", "50%" ), ( "flex", "1" ) ]
                        ]
                        []
                    ]
                , div [ style [ ( "flex", "5" ), ( "position", "relative" ) ] ]
                    [ span
                        [ style [ ( "position", "absolute" ), ( "right", "0" ), ( "padding", "4px" ), ( "color", "#eeeeee" ), ( "background", "#0275d8" ), ( "border-radius", "4px" ) ] ]
                        [ text (user.gender ++ " " ++ toString user.age) ]
                    ]
                ]
            ]
        ]


viewProfileInfo : UserProfile -> Html a
viewProfileInfo user =
    div []
        [ div [ style styleSpacedCenter ]
            [ text user.name ]
        , div [ style <| styleSpacedCenter ++ [ ( "color", "#aaaaaa" ) ] ]
            [ text ("@" ++ user.id) ]
        , div [ style styleSpacedCenter ]
            [ span
                [ style [ ( "background", "#cccccc" ), ( "padding", "4px" ), ( "border-radius", "4px" ) ] ]
                [ text user.location ]
            ]
        , div [ style [ ( "display", "flex" ), ( "align-items", "center" ), ( "margin", "6px auto" ), ( "height", "50px" ) ] ]
            [ div [ style [ ( "flex", "1" ) ] ] []
            , div [ style styleGrayBox ] [ text user.nativeLanguage ]
            , div [ style [ ( "flex", "0.5" ) ] ] []
            , div [ style styleGrayBox ] [ text ">" ]
            , div [ style [ ( "flex", "0.5" ) ] ] []
            , div [ style styleGrayBox ] [ text user.learningLanguage ]
            , div [ style [ ( "flex", "1" ) ] ] []
            ]
        , div [ style [ ( "display", "flex" ) ] ]
            [ div [ style [ ( "flex", "1" ) ] ] []
            , div [ style styleGrayBox ] [ text <| "✔: " ++ (toString user.corrections) ]
            , div [ style [ ( "flex", "1" ) ] ] []
            , div [ style styleGrayBox ] [ text <| "文: " ++ (toString user.savedWords) ]
            , div [ style [ ( "flex", "1" ) ] ] []
            ]
        ]


styleSpacedCenter : List ( String, String )
styleSpacedCenter =
    [ ( "text-align", "center" )
    , ( "margin", "6px" )
    ]


styleGrayBox : List ( String, String )
styleGrayBox =
    [ ( "flex", "1" )
    , ( "background", "#cccccc" )
    , ( "text-align", "center" )
    , ( "padding", "10px 5px" )
    , ( "border-radius", "4px" )
    ]


viewProfileInteraction : UserProfile -> Html a
viewProfileInteraction user =
    div [] []


viewProfileIntro : UserProfile -> Html a
viewProfileIntro user =
    div [] []


viewProfileMoments : UserProfile -> Html a
viewProfileMoments user =
    div [] []


main : Html a
main =
    viewProfile mockUser
