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
  \relative c'{
    f4 f8. c16 a'4 a8. f16 d'4 c2. |
    c4 c8. bes16 a4 a8. f16 g1 |
    e4 e8. c16 g'4 g8. e16 d'4 c2. |
    c4 c8. bes16 a4 g8. g16 a1 |
    f4 f8. c16 a'4 a8. f16 d'4 c2. |
    c4 c8. bes16 a4 bes8. c16 d1 |
    f4 f8 e d8. d16 d4 c4 c8 bes a8. a16 a4 |
    bes4 bes8 a g4 g8 bes a8 a bes4 c2 |
    f4 f8 e d8. d16 d4 |
    c4 c8 bes a8. a16 a4 |
    c8. c16 c4 <bes d>8 <bes d>8 <g e'>4 <f f'>2. r4
      \bar "|."
  }
}

songChords = \chordmode {
  f1 f f c
  c1 c c f
  f1 f f bes
  bes1 f
  c1 f2 f2:7
  bes1 f c f
}

verseOne = \lyricmode {
  \cfgText
  %\set stanza = "1."
  Lin -- na -- dest pää -- se -- me val -- la,
  tuu -- li nüüd haa -- rab me tiib.
  Kut -- sub meid män -- di -- de al -- la
  Lake -- woo -- di va -- len -- dav liiv.
  Met -- sa -- de värv on me vor -- mis,
  rän -- du -- ri ra -- hu -- tus vööl.
  Nae -- ra -- me päi -- ke -- ses,
  hõis -- ka -- me tor -- mi -- des,
  lau -- la -- me pil -- ka -- sel pi -- me -- dal ööl.
  Nae -- ra -- me päi -- ke -- ses,
  hõis -- ka -- me tor -- mi -- des,
  lau -- la -- me tu -- me -- dal ööl.
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
  \midi { \tempo 4 = 90 }
}


\version "2.8.1"
