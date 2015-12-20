\header{
  tagline = ""
}

#(set-global-staff-size 10)

cfgSong = {
  \key c \major
  \time 4/4
}

cfgText = {
  \set fontSize = #-2
}

melody = {
  \cfgSong
  \relative c'{
    \partial 8
  e8 e4 e8 f8 g4 a8 g g f-. f8 g8-. f2
  e4 e8 f g4 a8 g g2 r2
  r4 e8 f g4 a8 g g f-.f g-. f4
  <f a>8 <f a> <e g>4 f8 e d f16 e8. d8 c2. r4
  r4 f8 f a4. a8 a g g f f e e4
  r4 f8 f a4. a8 g g g a b2
    \bar "|."
  }
}

verseOne = \lyricmode {
  \cfgText
  %\set stanza = "1."
  Kes ot -- sib, see lei -- ab, ja mu -- i -- du ei saa,
  Ot -- si -- me Skaut -- lik -- ku teed!
  I -- ga matk al -- gab ü -- he sam -- mu -- ga,
  As -- tu jul -- gelt ja vaa -- ta mis on ees.

  \set stanza = "Ref:"
  Va -- na -- sõ -- na, e -- si -- i -- sa õ -- pe -- tus,
  kos -- tab mei -- le lä -- bi ae -- ga -- de!
}

songChords = \chordmode {
  r8 c1 f1 c1 g2 g2:7 c2 c2:7 f2 gis2 c g c c:7
  f1 c f g
}

\score {
  {
    %\time 4/4
    <<
      \chords { \songChords }
      { \melody }
      \addlyrics { \verseOne }
    >>
  }
  \layout {
    indent = #0
  %ragged-last = ##t
  \context {
      \Score
      \remove "Bar_number_engraver"
    }
  }
  \midi { }
}

\version "2.8.1"
