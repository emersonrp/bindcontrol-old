package BCMainWindow;
use strict;

# "Profile" menu
use constant MENUITEM_NEWPROF => 101;
use constant MENUITEM_LOADPROF => 102;
use constant MENUITEM_SAVEPROF => 103;

use constant MENUITEM_PREFS => 104;
use constant MENUITEM_EXIT => 105;


# "Help" menu
use constant MENUITEM_MANUAL => 201;
use constant MENUITEM_FAQ => 202;
use constant MENUITEM_LICENSE => 203;
use constant MENUITEM_ABOUT => 204;

# panel that the profile tabs live on
use constant PANEL_PROFILETABS => 301;

package ProfileTabs;
use constant PROFILE_NOTEBOOK => 101;
use constant PICKER_ARCHETYPE => 201;
use constant PICKER_PRIMARY => 202;
use constant PICKER_SECONDARY => 203;

1;
