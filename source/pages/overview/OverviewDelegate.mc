import Toybox.Lang;
import Toybox.WatchUi;
using WatchUi as Ui;
import Toybox.Application;
import Toybox.System;
import Toybox.Communications;
using Toybox.Graphics;
using Toybox.Attention;

class OverviewDelegate extends WatchUi.BehaviorDelegate {
    var httpreq;
    var variableValue = 0;

    private var _view as OverviewView;
    private var _manager;

    var db = Storage.getValue("db");
    var now_month = Storage.getValue("now_month");
    var month = Storage.getValue("now_month");

    function initialize(manager) {
        BehaviorDelegate.initialize();
        _manager = manager;
        _view = manager.getViewByIndex(0, 0);
    }

    function onKey(keyEvent as WatchUi.KeyEvent) as Lang.Boolean {
        eventHandling(keyEvent.getKey());
        return true;
    }

    function onSwipe(swipeEvent) {
        eventHandling(swipeEvent.getDirection());
        return true;
    }

    function onMenu() as Boolean {
        getMainMenu();
        return true;
    }

    function eventHandling(code){
        if(code==4 || code==3){ // Forward
            Storage.setValue("current_month", month);

            if(_manager.moveSubPage(1)){
                var page = _manager.getCurrentPage();
                WatchUi.switchToView(page[0], page[1], WatchUi.SLIDE_LEFT);
            }
        }
        if(code==5 || code==1){ // Back
            var currentSubLevel = _manager.getSubViewIndex();
            var currentLevel = _manager.getViewIndex();

            if(month!=now_month){
                _view.onDataReceived(now_month);
                month = now_month;
            }else{
                if(currentSubLevel==0){
                    if(currentLevel==0){
                        WatchUi.popView(WatchUi.SLIDE_LEFT);
                    }else{
                        _manager.setView(0, 0);
                        var page = _manager.getCurrentPage() as Array;
                        WatchUi.switchToView(page[0], page[1], WatchUi.SLIDE_DOWN);
                    }
                }else{
                    if(_manager.moveSubPage(-1)){
                        var page = _manager.getCurrentPage() as Array;
                        WatchUi.switchToView(page[0], page[1], WatchUi.SLIDE_RIGHT);
                    }
                }
            }
        }
        if(code==8 || code==0){ // Down
            month = month + 1;
            if(month > 12){
                month = 1;
            }
        }
        if(code==13 || code==2){ // Up
            month = month - 1;
            if(month < 1){
                month = 12;
            }
        }
        _view.onDataReceived(month);
    }

    function vibrateAttention() {
        var vibeData =
        [
            new Attention.VibeProfile(50, 250), // On for two seconds
        ];
        Attention.vibrate(vibeData);
    }
}