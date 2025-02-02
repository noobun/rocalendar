import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application;
import Toybox.System;
import Toybox.Communications;
using Toybox.Graphics;
using Toybox.Attention;
import Toybox.System;

class ColorSelectionMenuDelegate extends WatchUi.Menu2InputDelegate {

    var menu;
    var parent;
    var inner_event_type;

    function initialize(menu_par, ex_item, event_type) {
        Menu2InputDelegate.initialize();
        menu = menu_par;
        parent=ex_item;
        inner_event_type = event_type;
    }

    function onSelect(item) {
        writeLog("ColorSelectionMenuDelegate", "Selected Item for "+inner_event_type+": "+item.getId(), 100);
        if("verde".equals(item.getId())){
            Properties.setValue(inner_event_type, 0x00ff60);
        }else if("rosu".equals(item.getId())){
            Properties.setValue(inner_event_type, 0xff0000);
        }else if("alb".equals(item.getId())){
            Properties.setValue(inner_event_type, 0xffffff);
        }else if("albastru".equals(item.getId())){
            Properties.setValue(inner_event_type, 0x003bff);
        }else if("galben".equals(item.getId())){
            Properties.setValue(inner_event_type, 0xf1ff00);
        }else if("nimic".equals(item.getId())){
            writeLog("ColorSelectionMenuDelegate", "nothing selected", 100);
        }else{
            writeLog("ColorSelectionMenuDelegate", "selection error", 100);

        }
        System.println(Properties.getValue(inner_event_type));
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

}