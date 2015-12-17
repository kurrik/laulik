\header{
  tagline = ""
}

#(set-global-staff-size 10)

mBreak = { \break }

cfgSong = {
  \key c \major
  \time 2/4
  \autoBeamOff
}

cfgText = {
  \set fontSize = #-2
}

melody = {
  \cfgSong
  \relative c'{
    e4 e8. d16
    c4 d8 e
    f8. f16 f8 e
    d2
    f4 f8. e16
    d4 e8. f16
    a4 a8 gis
    g2
      \mBreak
    e4 e8. d16
    c4 d8 e
    f4 f8. g16
    a2
    g4. a8
    g4 d
    f2
    e4 s4
      \mBreak
    \repeat volta 2 {
      c4. c8
      e2(e4) \times 2/3 { c8[d e] }
      f2
      a4 a8 a
      g4. a8
      b8[g] a[b]
      c4 \breathe
      <<
      { c8. c16 c8 }
      \new Voice = "countries" {
        \autoBeamOff
        \relative c''{
          c8. c16 c8 r8 r4
        }
      } >>
    }
      %\bar "|."
  }
}

songChords = \chordmode {
  c1
  g1:7
  g1:7
  f2 c
  c1
  f1
  g1:7
  g2:7 c2
  c2 c1
  f1
  g1:7
  c1
}

verseOne = \lyricmode {
  \set stanza = "1."
  Jäl -- le me män -- gi -- me Jär -- ve -- met -- sa raal.
  Sõp -- ru -- ses vee -- da -- me päe -- vad siin maal.
  Laag -- ri -- sse koon -- du -- nud hul -- ga -- ni koos,
  Ees -- ti noo -- red kau -- gelt!

  \set stanza = "Ref:"
  Kand -- ku tuul
  \set ignoreMelismata = ##t
  siit mei -- e lau -- lu,
  kost -- ku siin ja ü -- le ko -- gu maa!
  U. S. A.!
}

verseTwo = \lyricmode {
  \set stanza = "2."
  Pu -- hub nüüd ko -- du -- maal
  va -- ba -- du -- se tuul.
  Kuu -- le kuis si -- nu -- le
  lau -- lab me huul,
  ko -- du -- le uh -- ked ja a -- la -- ti truud,
  '' \skip 8 '' \skip 4 '' !
}

verseThree = \lyricmode {
  \set stanza = "3."
  Meel -- de meil jää -- gu siit
  lõk -- ke tu -- le kuld.
  Hoi -- a -- me i -- ga -- vest sõp -- ru -- se tuld,
  oo -- ta -- me päe -- vi kus jäl -- le -- gi koos,
  '' \skip 8 '' \skip 4 '' !
}

\score {
  {
    <<
      \chords { \set chordChanges = ##t \songChords }
      { \melody }
      \addlyrics { \verseOne }
    %\addlyrics { \verseTwo }
    %\addlyrics { \verseThree }
    \new Lyrics = "kanada" \lyricsto countries
      { Ka -- na -- da! }
    \new Lyrics = "rootsimaa" \lyricsto countries
      { Root -- si -- maa! }
    \new Lyrics = "austraalia" \lyricsto countries
      { Aust -- raa -- lia! }
    \new Lyrics = "kanada" \lyricsto countries
      { Sak -- sa -- maa! }
    \new Lyrics = "kanada" \lyricsto countries
      { EES -- TI -- MAA! }
    >>
  }

  \layout {
    indent = #0
    %ragged-last = ##t
    \context {
      \Lyrics
      fontSize = #-2
    }
    \context {
      \Score
      \remove "Bar_number_engraver"
    }
  }
  \midi { \tempo 4 = 90 }
}


\version "2.8.1"
