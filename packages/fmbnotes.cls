\NeedsTeXFormat{LaTeX2e}  % Sets the LaTeX version for the class to work.
\ProvidesClass{fmbnotes}[2020/11/20 LaTeX class by Federico Melo Barrero to format my class notes]

% Base class: Article.
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}  % Any non-defined option will be passed to the article document class.
\ProcessOptions\relax
\LoadClass[10pt,letterpaper,twoside]{article}


%% Required packages
\RequirePackage{fmbdalgo}

\RequirePackage[backend=biber, style=authoryear]{biblatex}  % Citations.

\RequirePackage{enumitem}  % Customize enumerate, itemize and description environments.
\RequirePackage{epigraph}  % Inspirational quotes at the beggining of chapters.
\RequirePackage{fancyhdr}  % Headers, footers and page numbers.
\RequirePackage{fmbmath}  % My personal package. Contains macros and packages for the class to work.
\RequirePackage{fmbboxes}  % Package with my personalized boxes.
\RequirePackage{hyperref}  % Hyperlinks to refs.
\RequirePackage{hyphenat}  % Manage hyphenation.
\RequirePackage{multicol}  % Multiple columns
\RequirePackage{pdfpages}  % Include pdf files in the document
\RequirePackage{sectsty}  % Customize titles.
\RequirePackage{caption}  % Captions for non-float figures and tables.
% Included below: geometry, tocbibind, placeins, longtable, tcolorbox, 


%%% 0. Relative inputs and images helpers

% \setinputbase, \inputfrombase and \inputlist

% Usage:
% \setinputbase{algorithms/design}
% \inputlist{recursion/fibonacci, dp/knapsack, greedy/kruskal}

% Expands to:
% \input{algorithms/design/recursion/fibonacci}
% \input{algorithms/design/dp/knapsack}
% \input{algorithms/design/greedy/kruskal}

\newcommand*{\inputbase}{}
\newcommand*{\setinputbase}[1]{%
    \renewcommand*{\inputbase}{#1}%
}

\newcommand*{\inputfrombase}[1]{%
    \input{\inputbase/#1}%
}

\ExplSyntaxOn
\NewDocumentCommand{\inputlist}{m}
 {
  \clist_map_inline:nn { #1 }
   {
    \group_begin:
    \inputfrombase{##1}
    \group_end:
   }
 }
\ExplSyntaxOff


%% \setimagebase, \inlineimage and \floatimage
%
% Usage:
%
% \setimagebase{algorithms/design/images}
%
% \inlineimage[width=.8\linewidth]
%     {recursion_tree}
%     [Recursion tree for Merge Sort.]
%     [fig:merge-sort-tree]
%
% \floatimage[width=.8\linewidth]
%     {recursion_tree}
%     [Recursion tree for Merge Sort.]
%     [fig:merge-sort-tree]

\newcommand*{\imagebase}{}

\newcommand*{\setimagebase}[1]{%
    \renewcommand*{\imagebase}{#1}%
}

% \inlineimage[<graphics options>]{<file>}[<caption>][<label>]
\NewDocumentCommand{\inlineimage}{O{} m o o}{%
    \begingroup
    \begin{center}
        \includegraphics[#1]{\imagebase/#2}
        \IfValueT{#3}{\captionof{figure}{#3}}
        \IfValueT{#4}{\label{#4}}
    \end{center}
    \endgroup
}

% \floatimage[<graphics options>]{<file>}[<caption>][<label>]
\NewDocumentCommand{\floatimage}{O{} m o o}{%
    \begingroup
    \begin{figure}
        \centering
        \includegraphics[#1]{\imagebase/#2}
        \IfValueT{#3}{\caption{#3}}
        \IfValueT{#4}{\label{#4}}
    \end{figure}
    \endgroup
}

%%% 1. Text format

%\renewcommand{\familydefault}{\sfdefault}  % Text in Sans-serif.
%\setlength{\parindent}{0.5in}  % Indentation length.
%\setlength{\parskip}{0em}  % Space between paragraphs.
%\renewcommand{\baselinestretch}{2}  % Interlineado.
\usepackage{parskip}  % Add space between paragraphs and remove indentation, without getting unexpected vertical spacing.
\newcommand*{\concept}[1]{{\bfseries\textcolor{green!37!black}{#1}}}  % Green boldface


%%% 2. Page layout
\RequirePackage[margin=1in]{geometry}  % All sides with one inch margin (LaTeX default is 1.875 in, used in books).
\pagestyle{fancy}
\fancyhead{}  % Remove default header.
\fancyfoot{}  % Remove default footer.
\fancyhead[OL]{\textbf{\thepage} \quad \textcolor{green!50!black}{\(\bullet\)}  \quad \textsf{\titulo} \hbox{  } \S\thesection}  % Left header on odd pages.
\fancyhead[OR]{}  % Right header on odd pages.
\fancyhead[EL]{}  % Left header on even pages.
\fancyhead[ER]{\textsf{Federico Melo Barrero} \quad \textcolor{green!50!black}{\(\bullet\)} \quad \textbf{\thepage}}  % Right header on even pages.

%% Float barriers

\RequirePackage{placeins}  % Defines command \FloatBarrier so floats cannot bypass a certain point.
\let\Oldsection\section
\renewcommand{\section}{\FloatBarrier\Oldsection}  % Floats stay within the section they are placed.
\let\Oldsubsection\subsection
\renewcommand{\subsection}{\FloatBarrier\Oldsubsection}  % Floats stay within the subsection they are placed.
\let\Oldsubsubsection\subsubsection
\renewcommand{\subsubsection}{\FloatBarrier\Oldsubsubsection}  % Floats stay within the subsubsection they are placed.


%% Customization of itemize environment

\renewcommand{\labelitemi}{\( \bullet \)}  % Item level 1: Bullet.
\renewcommand{\labelitemii}{\( \circ \)}  % Item level 2: Circunference.
\renewcommand{\labelitemiii}{\( \diamond \)}  % Item level 3: Diamond.
\renewcommand{\labelitemiv}{\(\triangleright\)}  % Item level 4: Triangle (right).


%% Customization of longtable environment

\RequirePackage{longtable}
\setlength\LTleft{0pt}  % Longtables aligned to the left.
\setlength\LTright\fill
\setlength{\LTpre}{0pt}  % No extra space before longtables (default is \bigskipamount)
\setlength{\LTpost}{0pt}  % No extra space after longtables.


%%% 3. Cover, table of contents, parts and sections

\allsectionsfont{\sffamily}  %All headers in sans-serif.
\RequirePackage[nottoc,notlot,notlof]{tocbibind}  % Index, table of contents and bibliography.


%% Counters 

\renewcommand*\thepart{\rom{\arabic{part}}}  % Part counter with nice-looking roman numbers.
\renewcommand*\thesection{\arabic{section}}  % Section counter.
\renewcommand*\thesubsection{\arabic{section}.\arabic{subsection}}% Subsection counter.
\renewcommand*\thesubsubsection{\arabic{section}.\arabic{subsection}.\arabic{subsubsection}}  % Subsubsection counter.

%% Customization of section

% Section box
\RequirePackage[theorems,skins]{tcolorbox}  % Colored and framed text boxes.
\newtcbox{\section@box}{
	enhanced,
  	fontupper=\sffamily\Large\bfseries,
  	capture=minipage,
  	width=\textwidth,
 	colback=green!45!black,
 	coltext=white,
 	colframe=green!45!black,
	boxsep=0mm,
    top=2mm,
    bottom=2mm,
    boxrule=0.4mm,
    halign=center,
    valign=center,
    height=0.7cm,
    drop fuzzy shadow south,
    sharp corners=northwest}

% New section style
\renewcommand*{\section}{\@startsection{section}{1}{\z@}{-3.5ex \@plus -1ex \@minus -.2ex}{2.3ex \@plus.2ex}{\section@box}}

% The tcolorbox used for section titles breaks the normal \@afterheading
% page-break penalty, so we guard manually: require at least 4 lines of space
% before typesetting the title; otherwise LaTeX breaks to the next page first.
\RequirePackage{needspace}
\let\section@boxed\section
\renewcommand*{\section}{\needspace{4\baselineskip}\section@boxed}

\addto\extrasspanish{\renewcommand*{\sectionautorefname}{sección}}% Section label name for autoref inserted in babel package


%% Cover and table of contents

\NewDocumentCommand{\portada}{ m O{}}{%
	\begin{titlepage} 
		\begin{center}
		\vspace*{\fill}
			{\huge \bfseries \textcolor{green!50!black}{Apuntes de}}\\
			[0.2cm]
			{\Huge\bfseries\sffamily #1 }\\
			[0.3 cm]
			{\huge\bfseries\sffamily \textcolor{cyan!50!black}{#2}}\\
			[5cm]
			{\huge \bfseries Federico Melo Barrero}\\
			[0.1cm]
			{\large \href{mailto:f.melo@uniandes.edu.co}{f.melo@uniandes.edu.co}}\\
			[5cm] 	
			{\noindent \Large Copyright \copyright\mbox{ }2022, 2026 Federico Melo Barrero.}\\
			[1cm]
			{\small Todos los derechos reservados.}\\
			{\small Ninguna parte de este documento, incluyendo el diseño de la portada, figuras e imágenes, puede ser reproducida, registrada, almacenada o transmitida en manera alguna ni por ningún medio, ya sea electrónico, eléctrico, fotoquímico, mecánico, electroóptico, magnético, de grabación, de fotocopia o cualquier otro sin permiso previo y por escrito del autor. }
		\vspace*{\fill}
		\end{center}		
	\end{titlepage}

	\hypersetup{%
%	    colorlinks=true,	    
	    linkcolor=black,
	    linkbordercolor=white
	    }
	
	\pagestyle{empty}
	\tableofcontents
	\clearpage
	\pagestyle{fancy}
	
	\hypersetup{%
	    colorlinks=false,
	    linkbordercolor={cyan!40!black},% hyperlink borders will be red
	    linkcolor={cyan!40!black}, % Cyan for internal links.
	    pdfborderstyle={/S/U/W 0.6}% border style will be underline of width 1pt
	    %citecolor={blue!50!black}, % Blue for external hyperlinks.
	    %urlcolor={blue!80!black}% Dark blue for citations.
	}%
}