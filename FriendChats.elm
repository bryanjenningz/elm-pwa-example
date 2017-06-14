module FriendChats exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


type alias Date =
    { year : Int
    , month : Int
    , day : Int
    }


type alias MessagePreview =
    { message : String
    , date : Date
    }


type alias FriendChatPreview =
    { picture : String
    , name : String
    , lastMessage : MessagePreview
    , unreadMessages : Int
    }


friendChats : List FriendChatPreview
friendChats =
    [ { picture = "http://s3.amazonaws.com/37assets/svn/765-default-avatar.png"
      , name = "Bryan"
      , lastMessage = MessagePreview "Hello" (Date 2017 6 14)
      , unreadMessages = 1
      }
    ]


viewFriendChats : List FriendChatPreview -> Html msg
viewFriendChats friendChats =
    div [] <|
        List.map
            (\chat ->
                div [ style [ ( "display", "flex" ) ] ]
                    [ div [ style [ ( "flex", "1" ) ] ]
                        [ img [ style [ ( "width", "100%" ), ( "border-radius", "50%" ) ], src chat.picture ] [] ]
                    , div [ style [ ( "flex", "3" ) ] ]
                        [ div [] [ text chat.name ]
                        , div [] [ text chat.lastMessage.message ]
                        ]
                    , div [ style [ ( "flex", "1" ) ] ]
                        [ div [] [ text (toString chat.unreadMessages) ]
                        , viewDate chat.lastMessage.date
                        ]
                    ]
            )
            friendChats


viewDate : Date -> Html msg
viewDate { year, month, day } =
    div []
        [ text <| String.join "/" <| List.map toString [ year, month, day ] ]


main : Html msg
main =
    viewFriendChats friendChats
