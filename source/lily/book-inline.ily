% Inline / paragraph-sized fragments: staff and layout only.
\header {
  tagline = ##f
}

#(set-global-staff-size 12)

\layout {
  indent = 0\mm
  ragged-right = ##t
  % No barline before inline music examples.
  \override Score.SystemStartBar.stencil = ##f
}
