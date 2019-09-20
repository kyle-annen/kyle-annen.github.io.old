module Main exposing (main)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font



-- MAIN


main =
    Element.layout [ fonts ] pageLayout


pageTitle : String
pageTitle =
    "Blogerific"


tagline : String
tagline =
    "Gernerally uninteresing musings"


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
    [ height (fill |> maximum 100)
    , width fill
    , Background.color colors.orange
    ]


headerContent : List (Element msg)
headerContent =
    [ el [ centerX, centerY, Font.bold ] (text pageTitle)
    , el [ centerX, centerY, padding 5 ] (text tagline)
    ]


body : Element msg
body =
    column bodyStyle bodyContent


bodyContent : List (Element msg)
bodyContent =
    []


bodyStyle : List (Attribute msg)
bodyStyle =
    [ height fill, width fill, Background.color colors.green ]


fonts : Attribute msg
fonts =
    Font.family
        [ Font.typeface "Helevetica"
        , Font.sansSerif
        ]


colors =
    { orange = rgb255 251 113 95
    , blue = rgb255 41 190 226
    , green = rgb255 124 193 170
    , pink = rgb255 250 194 193
    , peach = rgb255 251 206 171
    , white = rgb255 255 255 255
    }
