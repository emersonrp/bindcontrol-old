package BCMainWindow;
use strict;
use Wx;


use constant APPNAME => 'BindControl';
use constant APPVERSION => '0.1';
use constant APPCOPYRIGHT => "(c) 2010 R Pickett <emerson\@hayseed.net>\n\nBased on CityBinder 0.76, Copyright (C) 2005-2006 Jeff Sheets\n\nSpeed-On-Deman binds were originally created by Gnarley's Speed On Demand Binds Program.  Advanced Teleport Binds by DrLetharga.";
use constant APPDESCRIPTION => "BindControl can help you set up custom keybinds in City of Heroes/Villains, including speed-on-demand binds.";

our $aboutDialogInfo = Wx::AboutDialogInfo->new();
$aboutDialogInfo->SetName(APPNAME);
$aboutDialogInfo->SetVersion(APPVERSION);
$aboutDialogInfo->SetCopyright(APPCOPYRIGHT);
$aboutDialogInfo->SetDescription(APPDESCRIPTION);

1;
