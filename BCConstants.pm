package BCConstants;
use strict;

# These are the colours of the buttons on the "login" screen, but they're weird.
# use constant HERO_COLOuR => '#213c6d';
# use constant VILLAIN_COLOuR => '#c10c0c';

use constant HERO_COLOUR => '#000080';
use constant VILLAIN_COLOUR => '#800000';


###################################################
package BCMainWindow;

# "Profile" menu
use constant MENUITEM_NEWPROF => 101;
use constant MENUITEM_LOADPROF => 102;
use constant MENUITEM_SAVEPROF => 103;

use constant MENUITEM_PREFS => 104;
use constant MENUITEM_EXIT => 105;


# "Help" menu
use constant MENUITEM_MANUAL => 111;
use constant MENUITEM_FAQ => 112;
use constant MENUITEM_LICENSE => 113;
use constant MENUITEM_ABOUT => 114;

# panel that the profile tabs live on
use constant PANEL_PROFILETABS => 121;

###################################################
package ProfileTabs;

use constant PROFILE_NOTEBOOK => 151;


###################################################
package General;

use constant PROFILE_NAMETEXT => 211;

use constant PICKER_ARCHETYPE => 221;
use constant PICKER_ORIGIN => 222;
use constant PICKER_PRIMARY => 223;
use constant PICKER_SECONDARY => 224;


###################################################
package SoD;

use constant USE_SOD => 301;

use constant UP_KEY => 310;
use constant DOWN_KEY => 311;
use constant FORWARD_KEY => 312;
use constant BACK_KEY => 313;
use constant STRAFE_LEFT_KEY => 314;
use constant STRAFE_RIGHT_KEY => 315;
use constant TURN_LEFT_KEY => 316;
use constant TURN_RIGHT_KEY => 317;
use constant MOUSECHORD_SOD => 318;

use constant SPRINT_PICKER => 319;

use constant AUTO_MOUSELOOK => 320;
use constant AUTORUN_KEY => 321;
use constant FOLLOW_KEY => 322;
use constant NON_SOD_KEY => 323;
use constant SPRINT_ONLY_SOD_KEY => 324;
use constant SPRINT_SOD => 325;
use constant SOD_TOGGLE_KEY => 326;
use constant CHANGE_TRAVEL_CAMERA => 327;
use constant BASE_CAMERA_DISTANCE => 328;
use constant TRAVEL_CAMERA_DISTANCE => 329;
use constant CHANGE_TRAVEL_DETAIL => 330;
use constant BASE_DETAIL_LEVEL => 331;
use constant TRAVEL_DETAIL_LEVEL => 332;
use constant DEFAULT_MOVEMENT_MODE => 333;
use constant HIDE_WINDOWS_TELEPORTING => 334;


use constant SEND_SOD_SELF_TELLS => 335;
use constant SS_KEY => 336;
use constant SS_ONLY_WHEN_MOVING => 327;
use constant SS_SJ_MODE => 328;

use constant SJ_KEY => 329;
use constant SJ_SIMPLE_TOGGLE => 330;

use constant FLY_KEY => 331;
use constant FLY_GROUPFLY_KEY => 332;

use constant TP_KEY => 333;
use constant TP_COMBO_KEY => 334;
use constant TP_RESET_KEY => 335;
use constant TP_HOVER_WHEN_TP => 336;
use constant TP_TEAM_COMBO_KEY => 337;
use constant TP_TEAM_RESET_KEY => 338;
use constant TP_GROUP_FLY_WHEN_TP_TEAM => 339;

use constant TEMP_KEY => 341;
use constant TEMP_POWERTRAY => 341;

use constant KHELD_NOVA_KEY => 342;
use constant KHELD_NOVA_POWERTRAY => 343;
use constant KHELD_DWARF_KEY => 344;
use constant KHELD_DWARF_POWERTRAY => 345;
use constant KHELD_HUMAN_KEY => 346;
use constant KHELD_HUMAN_POWERTRAY => 347;

1;
