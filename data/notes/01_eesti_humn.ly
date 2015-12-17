\header{
	tagline = ""
}

#(set-global-staff-size 10)

mBreak = {  }

cfgSong = {
	\key a \major
	\time 3/4
	\autoBeamOff
	\partial 4.
}

cfgText = {
	\set fontSize = #-2
}

melody = {
	\cfgSong
	\relative c'{
		e8 cis d |
		e4. a8 b8. e,16 | cis'2 a4 
			\mBreak
		fis8. b16 a4 gis | a2 e4 | 
		b'8. a16 gis8[fis] e[d]
			\mBreak
		cis8 fis e4 e | b'8. a16 gis8[fis] e[d] |
		cis8 fis e4 r8 e8 
			\mBreak
		a8. e16 cis8 e a b | cis2 a4 |
		fis8. b16 a4 gis | a4.\fermata
			\bar "|."
	}
}

songChords = \chordmode {
	%CHORDS GO HERE
}

verseOne = \lyricmode {
	%\cfgText
	%\set stanza = "1."
	Mu i -- sa -- maa, mu õnn ja rõõm,
	kui kau -- nis o -- led sa!
	Ei lei -- a mi -- na ii -- al teal
	see suu -- re lai -- a il -- ma peal,
	mis mull' nii ar -- mas o -- leks ka,
	kui sa, mu i -- sa -- maa!
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