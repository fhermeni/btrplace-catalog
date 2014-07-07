-------
BtrPlace Constraint Catalog
-------
Author: Fabien Hermenier
Contact: fabien.hermenier@inria.fr

The BtrPlace Constraint Catalog aims at consolidating
the different constraints that are related to the management of
virtual machines and servers in a virtualized infrastructure.


Content
--------
This folder contains the sources of the and the scripts that
are necessary to build the catalog either in the PDF or
in the HTML format.

The catalog itself is written using LaTex. Figures are
stored as SVG images.

For a PDF catalog, figures are converted into PDF and
the catalog is compiled using standard LaTeX tools;

For the HTML catalog, figures are converted into PNG.
The LaTeX files are then converted into XML using Tralics.
Finally, the XML is converted using several XSLT stylesheet
to provide HTML files.

