module Main exposing (main)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font



-- MAIN


main =
    Element.layout [] pageLayout


pageTitle : String
pageTitle =
    "kyle@nnen.rocks"


tagline : String
tagline =
    "musings of a life long learner"


pageLayout : Element msg
pageLayout =
    column [ height fill, width fill ]
        [ header
        , body
        ]


header : Element msg
header =
    column headerStyle headerContent


headerStyle : List (Attribute msg)
headerStyle =
    [ height (fill |> maximum 80)
    , width fill
    , Background.color colors.orange
    ]


headerContent : List (Element msg)
headerContent =
    [ el [ centerY, padding 10, fonts.title, Font.size 30 ] (text pageTitle)
    , el [ centerY, padding 10 ] (text tagline)
    ]


headerTitle =
    el [ centerY, padding 10, fonts.title, Font.size 30 ] (text pageTitle)


body : Element msg
body =
    column bodyStyle bodyContent


bodyContent : List (Element msg)
bodyContent =
    []


bodyStyle : List (Attribute msg)
bodyStyle =
    [ height fill, width fill, Background.color colors.green ]


fonts =
    { main =
        Font.family
            [ Font.typeface "Helevetica"
            , Font.sansSerif
            ]
    , title =
        Font.family
            [ Font.external
                { name = "Big Shoulders Text"
                , url = "https://fonts.googleapis.com/css?family=Big+Shoulders+Text"
                }
            , Font.sansSerif
            ]
    }


colors =
    { orange = rgb255 251 113 95
    , blue = rgb255 41 190 226
    , green = rgb255 124 193 170
    , pink = rgb255 250 194 193
    , peach = rgb255 251 206 171
    , white = rgb255 255 255 255
    }
