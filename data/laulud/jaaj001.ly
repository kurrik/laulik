\header{
  % title="Jää Jumalaga Mann"
  % composer="COMPOSER"
}


cfgSong = {
  \key g \major
  \time 2/4
}

cfgText = {
  %\set fontSize = #-1
}

melody = {
  \cfgSong
  \relative c''{
    b16 b b a g g g e d d d e d8 d
    c'8 c16 b a a a g fis g fis e d8 d16 d
    b16 d d d d8 d c16 e e e e8 e
    d16 d fis fis fis fis e fis a8 g g a
    b16 b b a g8 e c16 e e e e8 e
    d16 d fis fis fis fis e fis a8 g g4 \bar "|."
  }
}


songChords = \chordmode {
  g2 g
  d2:7 d
  g2 c
  d2 g
  g2 c
  d2:7 g
}

verseOne = \lyricmode {
  \cfgText
  %\set stanza = "1."
  E -- si -- me -- ne tüü -- ri -- mees ei raat -- si ii -- al juu -- a,
  Kõik o -- ma kop -- kad ta -- hab ko -- du -- maa -- le tuu -- a,
  Jää Ju -- ma -- la -- ga Mann sest tuu -- les o -- li ramm ja
  rei -- su si -- hiks o -- li mei -- le Rot -- ter -- dam.
  Jää Ju -- ma -- la -- ga Mann sest tuu -- les o -- li ramm ja
  rei -- su si -- hiks o -- li mei -- le Rot -- ter -- dam.
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
    ragged-last = ##t
  }
  \midi { \tempo 4 = 90 }
}


\version "2.8.1"
