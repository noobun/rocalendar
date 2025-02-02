import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Communications;

class ViewManager {

    private var viewStack as Array = [];

    private var currentLevel = 0;
    private var currentSubLevel = 0;

    function initialize(){
        writeLog("ViewManager:initialize", "View Manager Init", 10);

        viewStack = [
            [{"view"=>new OverviewView()}, {"view"=>new MonthView()}]
        ];
        viewStack[0][0]["del"] = new OverviewDelegate(self);
        viewStack[0][1]["del"] = new MonthDelegate(self);
    }

    function getCurrentPage() as Array{
        return [viewStack[currentLevel][currentSubLevel]["view"], viewStack[currentLevel][currentSubLevel]["del"]];
    }

    function getCurrentView() as WatchUi.View{
        return viewStack[currentLevel][currentSubLevel]["view"];
    }

    function getCurrentDelegate() as WatchUi.BehaviorDelegate{
        return viewStack[currentLevel][currentSubLevel]["del"];
    }

    function getViewByIndex(level, subLevel) as WatchUi.View{
        return viewStack[level][subLevel]["view"];
    }

    function getViewIndex() as Number{
        return currentLevel;
    }

    function getSubViewIndex() as Number{
        return currentSubLevel;
    }

    function setView(level as Number, sublevel as Number) as Void{
        currentLevel = level;
        currentSubLevel = sublevel;
    }

    function movePage(direction as Number) as Void{
        // 1  -> Next Page
        // -1 -> Back Page

        currentSubLevel = 0;
        currentLevel = currentLevel+direction;
        if(currentLevel<0){
            currentLevel=viewStack.size()-1;
        }

        if(currentLevel > viewStack.size()-1){
            currentLevel = 0;
        }
        writeLog("ViewManager", "Page: "+currentLevel.toString(), 100);
    }

    function moveSubPage(direction as Number) as Boolean{
        // 1  -> Next Page
        // -1 -> Back Page

        if((viewStack[currentLevel].size()-1)==0){
            writeLog("ViewManager", "No Sublevels", 100);
            return false;
        }else{
            currentSubLevel = currentSubLevel+direction;
            if(currentSubLevel<0){
                currentSubLevel=viewStack[currentLevel].size()-1;
            }

            if(currentSubLevel > viewStack[currentLevel].size()-1){
                currentSubLevel = 0;
            }
            writeLog("ViewManager", "SubPage: "+currentSubLevel.toString(), 100);
            return true;
        }
    }

}