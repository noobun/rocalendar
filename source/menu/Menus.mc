import Toybox.Lang;
import Toybox.WatchUi;
using WatchUi as Ui;
import Toybox.Application;
import Toybox.System;
import Toybox.Communications;
using Toybox.Graphics;
using Toybox.Attention;

function getMainMenu() {
    var menu = new WatchUi.Menu2({:title=>"ROcalendar"});
    var delegate;
    
    menu.addItem(
        new MenuItem(
            "Culoare Zi Libera",
            "",
            "free_day_color",
            {}
        )
    );
    menu.addItem(
        new MenuItem(
            "Culoare Cruce Neagra",
            "",
            "black_cross_color",
            {}
        )
    );
    menu.addItem(
        new MenuItem(
            "Culoare Cruce Rosie",
            "",
            "red_cross_color",
            {}
        )
    );

    // Create a new Menu2InputDelegate
    delegate = new MainMenuInputDelegate(menu); // a WatchUi.Menu2InputDelegate

    // Push the Menu2 View set up in the initializer
    WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);
    return true;
}

function getColorSelectionMenu(parent, event_name) {
    var menu = new WatchUi.Menu2({:title=>"Selectie Culoare"});
    var delegate;
    var item = parent;

    menu.addItem(
        new MenuItem(
            "VERDE",
            "",
            "verde",
            {}
        )
    );
    menu.addItem(
        new MenuItem(
            "ROSU",
            "",
            "rosu",
            {}
        )
    );
    menu.addItem(
        new MenuItem(
            "ALBASTRU",
            "",
            "albastru",
            {}
        )
    );
    menu.addItem(
        new MenuItem(
            "GALBEN",
            "",
            "galben",
            {}
        )
    );
    menu.addItem(
        new MenuItem(
            "ALB",
            "",
            "alb",
            {}
        )
    );

    // Create a new Menu2InputDelegate
    delegate = new ColorSelectionMenuDelegate(menu, item, event_name); // a WatchUi.Menu2InputDelegate

    // Push the Menu2 View set up in the initializer
    WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);
    return true;
}
