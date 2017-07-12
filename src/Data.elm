module Data exposing (..)

import Dict exposing (Dict)
import Http


type Msg
    = ChangeRoute Route
    | LoginUser String String
    | GetUserToken (Result Http.Error UserToken)
    | AddUser (Result Http.Error User)
    | UpdateLoginState UserLoginState
    | UploadPicture
    | GetPicture String
    | Signup SignupInfo


type Route
    = RouteTalks
    | RouteTalk Talk
    | RouteMoments
    | RouteSearch
    | RouteProfile User


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
    | SignupHttpError Http.Error


type UserLoginState
    = LandingPage
    | LoginPage String String Bool
    | ForgotPasswordPage String
    | SignupPage SignupInfo (Maybe SignupError)
    | LoggedIn UserToken


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
    , birthday : String
    , isMan : Bool
    , lastLogin : String
    , location : String
    , localTime : String
    , learningLanguage : Language
    , nativeLanguage : Language
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


type alias UserToken =
    { user : User
    , token : String
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
