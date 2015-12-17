\header{
  tagline = ""
}

#(set-global-staff-size 10)

cfgSong = {
  \key f \major
  \time 4/4
  \autoBeamOff
  \partial 4
}

cfgText = {
  \set fontSize = #-2
}

melody = {
  \cfgSong
  \relative c'{
    c8 c | f e d4 g8 f e4
    a4 f2 c8 c | a'8 g f4 bes8 a g4
    c2. f,8 f | d' c bes4 bes8. a16 g4
    a4 f2 f8 f | a g f4 a8. g16 f4
    g2. c,8. c16
      \bar "||"
    a'4. c8 g4 c, | f2 e4 c8. c16
    bes'4. c8 a4 bes8[c] |
    g2. c,8. c16 | a'4. a8 f4 g8[a] |
    bes2 d4 d8. d16 | c4. c8 c[bes] a[g] |
      \break
    %f2. c8. c16 |
    <<
      \new Voice = "1" { \voiceOne \autoBeamOff f2. c8. c16 a'4. a8 f4 g8[a] bes2 d4 d8. d16 c4. c8 c8[bes] a[g] f2. \bar "|." }
        \addlyrics { laul. Ka -- jab jär -- ve -- delt ja laan -- test
  jul -- ge te -- ras -- pois -- te laul. }

      \new Voice = "2" { \voiceTwo \autoBeamOff s2. c8. c16 f4. f8 ees4 ees4 d2 bes4 bes8. bes16 c4. c8 c4 d8[e] f2. }

    >>

      \bar "|."
  }
}

songChords = \chordmode {
  %CHORDS GO HERE
}

verseOne = \lyricmode {
  \cfgText
  %\set stanza = "1."
  Su -- vi sä -- ten -- dab si -- ni -- sel tae -- val,
  ka -- sed kan -- na -- vad ro -- he -- list rüüd.
  Met -- sa ra -- da -- de look -- le -- val pae -- lal
  jäl -- le sam -- mu -- me laag -- ris -- se nüüd.

  Kau -- gel lin -- na -- dest ja maan -- teest,
  mar -- sib ma -- lev, sel -- jas paun.
  Ka -- jab jär -- ve -- delt ja laan -- test
  jul -- ge te -- ras -- pois -- te laul.
  Ka -- jab jär -- ve -- delt ja laan -- test
  jul -- ge te -- ras -- pois -- te laul.
}

lastLine = \lyricmode {
  jär -- ve -- delt ja laan -- test
  jul -- ge te -- ras -- pois -- te laul.
}

\score {
  {
    <<
      %\chords { \set chordChanges = ##t \songChords }
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
    \context {
      \Lyrics
      fontSize = #-2
    }
  }
  \midi { \tempo 4 = 90 }
}


\version "2.8.1"
