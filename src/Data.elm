module Data exposing (..)


type alias Moment =
    { userId : String
    , pictures : List String
    , text : String
    , likes : Int
    , comments : List Comment
    }


type alias Comment =
    { userId : String
    , name : String
    , text : String
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
