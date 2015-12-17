\header{
  tagline = ""
}

#(set-global-staff-size 10)

cfgSong = {
  \key f \major
  \time 4/4
  \autoBeamOff
}

cfgText = {
  \set fontSize = #-2
}

melody = {
  \cfgSong
  \relative c''{
    a8. g16 f8 d c d c4
    c8 a' g4 c,8 g' f4
    a8. g16 f8 d c d c c
    c8 a' g e f4. r8
    g8. g16 g8 g g g g4
    g8 g a b c c c bes
    a8 f f f a a c4
    g8 g c c f,4 r8 g16 a
    g4 r8 g16 a g4 r8 g16 a
    g8 f e d c4 c'4
    a8 f f f a a c4
    g8 g c c f,2
    \bar "|."
  }
}

verseOne = \lyricmode {
  \cfgText
  %\set stanza = "1."
  Vän -- dra met -- sas Pär -- nu -- maal,
  juh -- hai -- di, juh -- hai -- da,
  Las -- ti va -- na ka -- ru ma -- ha,
  juh -- hai -- di -- ai -- da.
  Vän -- dra met -- sas Pär -- nu -- maal
  las -- ti va -- na ka -- ru ma -- ha,
  Juh -- hai -- di ja juh -- hai -- da,
  Juh -- hai -- di -- ai da.

  %\set stanza = "Ref:"
  Va -- le -- ri, va -- le -- ra, va -- le -- ra -- la -- la -- la -- la, hei!
  Juh -- hai -- di ja juh -- hai -- da,
  Juh -- hai -- di -- ai -- da.
}

songChords = \chordmode {
  f1 c2 f2 f1 c2 f2
  c1 c1 f1 c2 f2
  r8 c/g c/g r4 c8/g c/g r8
  r2. c4 f1 c2 f2
}

\score {
  {
    <<
      \chords { \set chordChanges = ##t \songChords }
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
