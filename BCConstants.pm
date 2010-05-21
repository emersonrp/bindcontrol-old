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

1;
