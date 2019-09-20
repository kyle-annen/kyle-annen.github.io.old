module Main exposing (main)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font


main =
    Element.layout [] mainRow


pageTitle : String
pageTitle =
    "Blogerific"


mainRow : Element msg
mainRow =
    column
        [ width fill
        , height (fill |> maximum 100)
        , centerX
        , spacing 30
        , Background.color colors.orange
        ]
        [ text pageTitle ]


colors =
    { orange = rgb255 251 113 95
    , blue = rgb255 41 190 226
    , green = rgb255 124 193 170
    , pink = rgb255 250 194 193
    , peach = rgb255 251 206 171
    }
