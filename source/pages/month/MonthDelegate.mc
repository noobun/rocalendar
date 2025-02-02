import Toybox.Lang;
import Toybox.WatchUi;
using WatchUi as Ui;
import Toybox.Application;
import Toybox.System;
import Toybox.Communications;
using Toybox.Graphics;
using Toybox.Attention;

class MonthDelegate extends WatchUi.BehaviorDelegate {
    var _view as MonthView;
    var _manager;

    var db as Dictionary= Storage.getValue("db");
    var month as Number = Storage.getValue("now_month");

    function initialize(manager) {
        BehaviorDelegate.initialize();
        _manager = manager;
        _view = manager.getViewByIndex(0, 1);
    }

    function onKey(keyEvent as WatchUi.KeyEvent) as Lang.Boolean {
        eventHandling(keyEvent.getKey());
        return true;
    }

    function onSwipe(swipeEvent as WatchUi.SwipeEvent) as Boolean{
        eventHandling(swipeEvent.getDirection());
        return true;
    }

    function eventHandling(code as Number) as Void{
        if(code==4 || code==3){ // Forward
        
        }
        if(code==5 || code==1){ // Back
            var currentSubLevel = _manager.getSubViewIndex();
            var currentLevel = _manager.getViewIndex();
            if(currentSubLevel==0){
                if(currentLevel==0){
                    WatchUi.popView(WatchUi.SLIDE_LEFT);
                }else{
                    _manager.setView(0, 0);
                    var page = _manager.getCurrentPage();
                    WatchUi.switchToView(page[0], page[1], WatchUi.SLIDE_DOWN);
                }
            }else{
                if(_manager.moveSubPage(-1)){
                    var page = _manager.getCurrentPage();
                    WatchUi.switchToView(page[0], page[1], WatchUi.SLIDE_RIGHT);
                }
            }
        }
        if(code==8 || code==0){ // Down
            _view.scroll(-1);
        }
        if(code==13 || code==2){ // Up
            _view.scroll(1);
        }
    }
}