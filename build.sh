#!/bin/bash
wxpar.bat --gui \
	-a BindControl.exe.manifest \
	-a icons/Help.png \
\
	-X utf8 \
	-X unicore \
	-X utf8_heavy \
	-X warnings \
	-o BindControl.exe BindControl.pl
