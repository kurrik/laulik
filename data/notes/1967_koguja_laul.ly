\header{
  tagline = ""
}

mBreak = { }

#(set-global-staff-size 10)

cfgSong = {
  \key f \major
  \time 2/4
  \autoBeamOff
  \partial 4
}

cfgText = {
  \set fontSize = #-2
}

melody = {
  \cfgSong
  \relative c''{
    a8 a a4 f8 f
    f4 c8 f e4 g ~ g r4
      \breathe
    e4 e8 f g4 f8 g a2 ~ a8 r8
      \breathe
    a8 a | a4 f8 f f4 c8 f e4 g ~ g8 r8
      \breathe
    bes8. a16 | g4 g8 f e4 d c2 ~ c8 r8 r4
      \breathe
      \mBreak
    \repeat volta 2 {
      c4 a'8 g f4 c
      d4 bes'8. a16 g4 d
        \breathe
      e4 e8 g c4 c8 bes a2 ~ a8 r8 r4
      c,4 a'8 g f4 c
      d4 bes'8. a16 g4 d
      e4. f8 g4 \times 2/3 { c8 c c }
      f,2 ~ f8 r8 r4
    }
      %\bar "|."
  }
}

songChords = \chordmode {
  s4
  f2 f
  c2 c c c
  f2 f f f
  c2 c c c c c
  f2 f bes bes c c f f
  f2 f bes bes c c f f
}

verseOne = \lyricmode {
  %\set stanza = "1."
  Tu -- le, rän -- da -- me män -- di -- de var -- ju,
  päi -- ke -- ne sil -- mis ja suul.
  Pil -- ved pai -- ta -- vad kuus -- ke -- de har -- ju,
  hõis -- kab lau -- lu -- lind kõr -- gel puul.

  \set stanza = "Ref:"
  Hul -- la -- vas tuu -- les, maan -- teel kui luu -- les,
  laag -- ris -- se mat -- ka -- me nüüd.
  Met -- sa -- de põu -- es, päik -- ses ja kõu -- es
  koon -- dab meid Ko -- gu -- ja hüüd.
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
