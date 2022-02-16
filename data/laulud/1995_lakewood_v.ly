\header{
  tagline = ""
}

#(set-global-staff-size 10)

%\paper {
%  #(set-paper-size "a6")% 'landscape)
%  between-system-spacing = #-1
%  between-system-padding = #-1
%  %ragged-bottom=##f
%  %ragged-last-bottom=##f
%}

mBreak = { \break }

cfgSong = {
  \key d \major
  \time 4/4
  \autoBeamOff
}

cfgText = {
  \set fontSize = #-2
}

melody = {
  \cfgSong
  \relative c'{
    fis8 e d e fis8. d16 b'8 a | a4 g e2 |
    g8. fis16 e8 fis g e cis'8. b16 | b4 a fis2 | fis4 a d4. fis,8 |
    e8. fis16 g8 a b2 | cis8. b16 a8 g fis8. g16 fis8 e | d2. r4 |
      \time 2/4
    a'4 fis | g8 fis e4 | b' g | a8 r16 g fis4 | fis a | d8. cis16 b8 a |
    g4 fis8 a | e2 | e4. fis8 | g8. e16 g4 | fis g | a8. fis16 a4 |
    gis4. a8 | b e, fis gis | a4 a8 b8 | a2 | e4. fis8 | g8. e16 g4 |
    fis4 g | a8. fis16 a4 | b8. cis16 d8 e | d4 cis | d2 ~ d4 r
      \bar "|."
  }
}

songChords = \chordmode {
  %CHORDS GO HERE
}

verseOne = \lyricmode {
  \cfgText
  %\set stanza = "1."
  Si -- ni -- tae -- vas, liiv ja män -- nid, met -- sa -- tee;
  puu -- de va -- hel hel -- gib ee -- mal jär -- ve -- ke,
  rõõ -- mu -- hääl -- test vas -- tu ka -- jab laas:
  gai -- did koos, sest laa -- ger kut -- sund taas.

  Lake -- wood võ -- lub meid, pal -- ju pik -- ki teid
  mit -- mest il -- ma -- kaa -- rest kok -- ku meid toob.
  Hin -- ge hel -- lu -- se, kest -- va sõp -- ru -- se
  laa -- ger sü -- da -- mes -- se kõi -- gi -- le loob!
  Hin -- ge hel -- lu -- se, kest -- va sõp -- ru -- se
  laa -- ger sü -- da -- mes -- se loob!
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
