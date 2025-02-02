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

        Storage.setValue("current_month", now.month);

        manager = new ViewManager();
        return manager.getCurrentPage();
    }

    function onAppUpdate(){
        
    }

    function onAppInstall(){

    }

    (:glance) function getGlanceView() {
        var glance_res_dict = [
            Rez.JsonData.db_glance_ianuarie,
            Rez.JsonData.db_glance_februarie,
            Rez.JsonData.db_glance_martie,
            Rez.JsonData.db_glance_aprilie,
            Rez.JsonData.db_glance_mai,
            Rez.JsonData.db_glance_iunie,
            Rez.JsonData.db_glance_iulie,
            Rez.JsonData.db_glance_august,
            Rez.JsonData.db_glance_septembrie,
            Rez.JsonData.db_glance_octombrie,
            Rez.JsonData.db_glance_noiembrie,
            Rez.JsonData.db_glance_decembrie
        ];
        var now_month = Gregorian.info(Time.now(), Time.FORMAT_SHORT).month;

        var glance_database = [];
        glance_database.add(Application.loadResource(glance_res_dict[now_month-1]));

        if(now_month < 12){
            glance_database.add(Application.loadResource(glance_res_dict[now_month]));
        }

        Storage.setValue("db_glance", glance_database);

        var glanceView = new OverviewGlanceView();
        return [ glanceView, new OverviewGlanceDelegate(glanceView) ];
    }  
}