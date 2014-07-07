\ProvidesPackage{hyperref}[2011/04/06 v1.0 Hyperref: Addition to Tralics]

\def\hyperlink#1#2{\xmlelt{hyperlink}{\XMLaddatt{href}{#1}#2}}
\def\hypertarget#1{\xmlelt{hypertarget}{\XMLaddatt{name}{#1}}}
\def\hyperref#1{\xmlelt{hyperref}{\XMLaddatt{name}{#1}}}
