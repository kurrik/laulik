\header{
	tagline = ""
}

mBreak = { } %\break }

#(set-global-staff-size 10)

cfgSong = {
	\key c \major
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
		e4 g fis8 g a4 b8. c16 | g2 e4 g |
			\mBreak
		c4 c8. c16 b4 a8. a16 g2 r4 gis4 |
		a4 f8. f16 f4 e8. f16 |
			\mBreak
		g2 e4 g fis e8 d a'4 g8. fis16 |
		g2 r4 g8[fis] |
			\mBreak
		e4 d8 c d4 e8 f e4 e r g |
		a4 gis8 a b4 gis8 e |
			\mBreak
		c'2 r4 c a a8 a d4 c8 a a4 g r a |
			\mBreak
		g4 d8. e16 f4 f8. g16 | e2 r4 g |
		a4 a8 a d4 c8 a |
			\mBreak
		a4 g r c e c8. c16 d4 c8. b16 c2. r4
			\bar "|."
	}
}

songChords = \chordmode {
	
}

verseOne = \lyricmode {
	\cfgText
	%\set stanza = "1."
	Meid lai -- a -- li pil -- lu -- tand tuu -- led,
	on saa -- tus nii ran -- ge ja karm,
	üht hüü -- et ent sü -- da -- mes kuu -- led,
	taas är -- kab su noo -- rus -- lik tarm.
	Suur -- laag -- ris me lii -- tu -- nud rõn -- gaks,
	mis raud -- ne kui vä -- gi -- las -- vöö.
	Me loo -- tus -- te hel -- ki -- vaks lõn -- gaks
	on truu -- dus ja võit -- lus ja töö!
	Me loo -- tus -- te hel -- ki -- vaks lõn -- gaks
	on truu -- dus ja võit -- lus ja töö!
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