\header{
  tagline = ""
}

#(set-global-staff-size 10)

cfgSong = {
  \key c \major
  \time 4/4
  \autoBeamOff
  %\partial 4
}

cfgText = {
  \set fontSize = #-2
}

melody = {
  \cfgSong
  \relative c'{
    c4 e g g | a b c g | c8. b16 c8. b16 c4 a | g r4 r2 |
    a4. g8 a4 b | c a g e | c8. b16 c8. d16 e4 d | c r4 r2 |
    g'4. g8 d4 d | e fis g d | e fis g4. g8 |
      a4. a8 b4 r4 | c4. b8 a4 a |
    g4 a b g | a4. b8 a4 g | fis e d r | a'4. g8 fis4 d |
      g4 a b g |
    a4. b8 c4 c | b8[a] g[b] a4 r | a4. g8 a4 b |
      c4 a g e | c8. b16 c8. d16 e4 d c2
      \bar "|."
  }
}

songChords = \chordmode {
  %CHORDS GO HERE
}

verseOne = \lyricmode {
  \cfgText
  %\set stanza = "1."
  Ka -- le -- vi -- te jul -- gel sam -- mul
  as -- tub ma -- lev tä -- na -- ne,
  skau -- di -- pois -- te noo -- rus -- ram -- mul
  rõk -- kab laul nüüd Ees -- ti -- le!

  Kal -- ju -- kin -- del mees -- te ta -- he,
  suu -- re laag -- ri hoog ja ind,
  see toob me -- he kõr -- val me -- he,
  te -- ra -- sest saab sõp -- rus -- ring.
  Ees -- ti maast ja ees -- ti mee -- lest
  kõ -- ne -- leb siin ees -- ti keel.
  Ees -- ti li -- pu või -- du -- mas -- ti
  viib kord mei -- e me -- he -- meel.
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
