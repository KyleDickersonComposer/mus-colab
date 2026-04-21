% No default LilyPond footer (Barry Book style; keeps snippets free of branding).
\header {
  tagline = ##f
}

% Shared layout for block examples (no house jazz fonts; tweak freely).
#(set-global-staff-size 15)

\paper {
  indent = 0\mm
  line-width = 175\mm
  ragged-right = ##f
}

\layout {
  indent = 0\mm
  ragged-right = ##f
  \context {
    \StaffGroup
    \remove "System_start_delimiter_engraver"
  }
  \override Score.SystemStartBar.stencil = ##f
}
