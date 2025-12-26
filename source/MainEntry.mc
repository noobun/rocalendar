import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Communications;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Time.Gregorian;
using Toybox.Time;

class MainEntry extends Application.AppBase {
    var manager;

    function initialize() {
        AppBase.initialize();
        writeLog("MainEntry:initialize", "Init done.", 100);
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
        
    }

    function onBackgroundData(data) {
        writeLog("MainEntry:OnBackgroundData", data, 100);
    }

    // Return the initial view of your application here
    function getInitialView(){
        //register for temporal events if they are supported

        var now = Gregorian.info(Time.now(), Time.FORMAT_SHORT);

        Storage.setValue("now_year", now.year);
        Storage.setValue("now_month", now.month);
        Storage.setValue("now_day", now.day);

        Storage.setValue("selected_month", now.month);
        Storage.setValue("selected_year", now.year);
        Storage.setValue("selected_day", now.day);

        manager = new ViewManager();
        return manager.getCurrentPage();
    }

    function onAppUpdate(){
        
    }

    function onAppInstall(){

    }

    (:glance) function getGlanceView() {
        var glanceView = new OverviewGlanceView();
        return [ glanceView, new OverviewGlanceDelegate(glanceView) ];
    }  
}