\version "2.24.0"

% Full-bleed pages: inherit general staff tweaks from book-example.ily, then match
% The Barry Book real-book chart width (19.15 cm) and tighten vertical spacing
% between *systems* so TeX + LilyPond do not each add a huge gap.

\include "lily/book-example.ily"

\paper {
  % Same line width as barry-book/source/real-book-chart.ily (paper-width there).
  line-width = 19.15\cm
  indent = 0\mm

  % Defaults are generous; these values are in staff-space units (NR spacing).
  system-system-spacing =
    #'((basic-distance . 5)
       (minimum-distance . 4)
       (padding . 0.5))

  % Keep header markup from floating too far above the first staff.
  markup-system-spacing =
    #'((basic-distance . 4)
       (minimum-distance . 3)
       (padding . 0.5))
}
