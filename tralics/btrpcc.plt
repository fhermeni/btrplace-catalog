\ProvidesPackage{btrpcc}

\usepackage[english]{babel}
\usepackage{latexsym}
\usepackage{amsmath}
\usepackage{amssymb}
\usepackage{graphicx}
\usepackage{listings}
\usepackage{url}
\usepackage{subfig}
\usepackage{array}
\usepackage{multirow}
\usepackage{hyperref}
\usepackage{makeidx}
\usepackage{ifthen}
\usepackage{float}
%\usepackage{mfirstuc}
%\usepackage{multind}

%%Various macros
%\renewcommand*{\indexname}{Constraints Index}
\addto\captionsenglish{\renewcommand{\indexname}{Constraints Index}}

\newcommand{\imply}{\Rightarrow}
%%% Let's go for the macros
\newcommand{\btrp}{BtrPlace}
\newcommand{\st}[1]{\texttt{#1}}
\newcommand{\cstr}[1]{\texttt{#1}}
\def\cstrref#1{\xmlelt{hyperref}{\XMLaddatt{name}{#1}\texttt{#1}}}
\newcommand{\card}[1]{|#1|}


\newcommand{\etal}{{\it et al.}}
\newcommand{\etc}{{\it etc.}}
\newcommand{\ie}{\emph{i.e.}}
\newcommand{\eg}{{\em e.g.}}
\newcommand{\todo}[1]{\textbf{TODO: #1}}
\newcommand{\checked}{\xmlelt{symbol}{\XMLaddatt{id}{checkMark}}}

\newboolean{showFullVersion}

\setboolean{showFullVersion}{false}

\DeclareOption{fullVersion}{\setboolean{showFullVersion}{true}}
\DeclareOption{shortVersion}{\setboolean{showFullVersion}{false}}
\ProcessOptions

\newcommand{\addcontentsline}[3]{}

\ifthenelse{\boolean{showFullVersion}}
{\newcommand{\fullVersion}[1]{#1}}
{\newcommand{\fullVersion}[1]{ }}

%%Command for constraint indexation

\makeatletter
\newcommand{\classification}[4]
{
\xmlelt{cstrClassification}{
\@for\i:=#2\do{%
\index{By User!{\i}!#1}%
\xmlelt{cstrIndex}{\XMLaddatt{type}{By User}\XMLaddatt{id}{\i}#1}%
}%
\@for\i:=#3\do{%
\index{By Element!{\i}!#1}%
\xmlelt{cstrIndex}{\XMLaddatt{type}{By Element}\XMLaddatt{id}{\i}#1}%
}%
\@for\i:=#4\do{%
\index{By Concern!{\i}!#1}%
\xmlelt{cstrIndex}{\XMLaddatt{type}{By Concern}\XMLaddatt{id}{\i}#1}%
}%
}
}
\makeatother


\lstset{
        basicstyle=\ttfamily,
        aboveskip={1.5\baselineskip},
        commentstyle=\it,
        showstringspaces=false,
        stringstyle=\tt,
        frame=lines,
        captionpos=b
}

\newfloat{myListing}{thp}{lop}
\floatname{myListing}{Listing}

\newfloat{reconfiguration}{thp}{lop}
\floatname{reconfiguration}{Reconfiguration}

\newfloat{reconfPlan}{thp}{lop}[chapter]
\floatname{reconfPlan}{Figure}

\makeatletter
\let\c@reconfiguration\c@figure
\let\c@myListing\c@figure
\let\c@reconfPlan\c@figure
\makeatother


\newcommand{\oline}[1]{\xmlelt{overline}{#1}}
\newcommand{\emulatedWith}[4]{}
%\cstrref{#2}: #3 \xmlelt{symbol}{\XMLaddatt{id}{equivalent}} #4}

\newcommand{\myEquiv}{\xmlelt{symbol}{\XMLaddatt{id}{equivalent}}}

\newcommand{\tuparrow}{\xmlelt{symbol}{\XMLaddatt{id}{uparrow}}}
\newcommand{\tdownarrow}{\xmlelt{symbol}{\XMLaddatt{id}{downarrow}}}
\newcommand{\tforall}{\xmlelt{symbol}{\XMLaddatt{id}{forall}}}
\newcommand{\tin}{\xmlelt{symbol}{\XMLaddatt{id}{in}}}
\newcommand{\allNodes}{\xmlelt{symbol}{\XMLaddatt{id}{allNodes}}}


\newcommand{\printInheritanceGraph}[1]
{
\begin{figure}[htb]%
\centering%
\includegraphics[width=.75\textwidth]{img/inheritance}%
\caption{Inheritance graph between the constraints.}\label{#1}%
\end{figure}%
}


\newcommand{\printListOfInheritances}{
\IfFileExists{_all_.inh}{\input{_all_.inh}}{\typeout{Unknown inheritance.inh. Run ...}}
}

\newcommand{\printListOfInheritance}[1]{
\IfFileExists{#1.inh}{\input{#1.inh}}{\typeout{Unknown inheritance.inh. Run ...}}
}