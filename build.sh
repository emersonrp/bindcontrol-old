#!/bin/bash
pp.bat \
	-n -c -z 9 \
	--gui \
	-M attributes.pm \
	-l C:/strawberry/perl/site/lib/Alien/wxWidgets/msw_2_8_10_uni_gcc_3_4/lib/mingwm10.dll \
	-l C:/strawberry/perl/site/lib/Alien/wxWidgets/msw_2_8_10_uni_gcc_3_4/lib/wxmsw28u_adv_gcc_custom.dll \
	-l C:/strawberry/perl/site/lib/Alien/wxWidgets/msw_2_8_10_uni_gcc_3_4/lib/wxmsw28u_core_gcc_custom.dll \
	-l C:/strawberry/perl/site/lib/Alien/wxWidgets/msw_2_8_10_uni_gcc_3_4/lib/wxbase28u_gcc_custom.dll \
	-a Icons \
	-a BindControl.ico \
	-a BindControl.exe.manifest \
	-o BindControl.exe BindControl.pl
upx BindControl.exe
