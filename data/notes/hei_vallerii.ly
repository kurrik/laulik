\header{
  % title="Hei Vallerii"
  % composer="COMPOSER"
}


cfgSong = {
  \key g \major
  \time 3/4
}

cfgText = {
  \set fontSize = #-1
}


melody = {
  \cfgSong
  \relative c''{
    \partial 4
    b4 a8 g4. e4  d e4. b8 d4 e4. d8 fis2.
    d4 d4. d8 a'2. b4 b4. a8 g2
    b4 a g e d e4. b8 d e4. d4 fis2.
    d4 d4. d8 a'2 b4 g2.( g2)
    g4 e8 e4. e4 c' c4. c8 b4 b a g2
    b4 a a4. a8 fis4 fis a g g a b2.
    e,4 e4. e8 c'2. <b d>4 <b d>4. <a c>8 <g b>2.
    d4 d4. d8 a'2 b4 g2.( g2) \skip 4 \bar "|."
  }
}


songChords = \chordmode {
  r4 g2. g g d
  d2. d g g
  g2. g g d
  d2. d g g:7
  c2. c g g
  d2. d g g:7
  c2. c g g
  d2. d g g
}

verseOne = \lyricmode {
  \cfgText
  %\set stanza = "1."
  Ma me -- re -- mees vah -- va, mul jul -- ge on rind,
  Hei val -- le -- rii, hei val -- le -- raa.
  Ei üh -- te -- gi tor -- mi mis ko -- hu -- taks mind,
  Hei val -- le -- rii, hur -- raa.
  Mul sa -- da -- mas oo -- ta -- mas kau -- ni -- tar neid,
  Tal' üt -- len ``Sa o -- led mu ai -- nu -- ke leid,''
  Hei val -- le -- rii, hei val -- le -- raa,
  Hei val -- le -- rii, hur -- raa.
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
  \midi { \tempo 4 = 120 }
}


\version "2.8.1"
