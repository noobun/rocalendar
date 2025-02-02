import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application;
import Toybox.System;
import Toybox.Communications;
using Toybox.Graphics;
using Toybox.Attention;
import Toybox.System;

class MainMenuInputDelegate extends WatchUi.Menu2InputDelegate {

    var menu;

    function initialize(menu_par) {
        Menu2InputDelegate.initialize();
        menu = menu_par;
    }

    function onSelect(item) {
        if("free_day_color".equals(item.getId())){
            getColorSelectionMenu(item, "free_day_color");
        }if("black_cross_color".equals(item.getId())){
            getColorSelectionMenu(item, "black_cross_color");
        }if("red_cross_color".equals(item.getId())){
            getColorSelectionMenu(item, "red_cross_color");
        }else{
            writeLog("MainMenuInputDelegate", "unknow option selected", 100);
        }
    }

}