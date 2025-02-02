import Toybox.Graphics;
import Toybox.WatchUi;
using Toybox.Time;
using Toybox.Time.Gregorian;
import Toybox.Lang;
import Toybox.Application;
import Toybox.System;
import Toybox.Communications;
import Toybox.Attention;
using Toybox.Math;


(:glance )
function vibrateAttention() {
    var vibeData =
    [
        new Attention.VibeProfile(50, 250), // On for two seconds
    ];
    Attention.vibrate(vibeData);
}

(:glance )
function getDeadSpace(diameter, height) as Float {
    var radius = diameter/2;
    var tmp = Math.sqrt(Math.pow(radius, 2) - Math.pow(height, 2));
    return radius-tmp;
}

// (:glance )
// function returnColorBasedOnString(color_str as String) as Graphics.ColorValue{
//     if(color_str.equals("verde")){
//         return Graphics.COLOR_GREEN;
//     }else if(color_str.equals("rosu")){
//         return Graphics.COLOR_RED;
//     }else if(color_str.equals("galben")){
//         return Graphics.COLOR_YELLOW;
//     }else if(color_str.equals("albastru")){
//         return Graphics.COLOR_BLUE;
//     }else if(color_str.equals("alb")){
//         return Graphics.COLOR_WHITE;
//     }else if(color_str.equals("nimic")){
//         return Graphics.COLOR_TRANSPARENT;
//     }else{
//         writeLog("returnColorBasedOnString", "Unknow render color", 100);
//         return Graphics.COLOR_TRANSPARENT;
//     }
// }

(:glance )
function getNextEvent(now_day as Number, db as Array) as Array<Number or String>{
    var days_untill = 0;
    var current_day_crawl = now_day;
    var event = {
                    "name" =>  "Nimic",
                    "desc" =>  "",
                    "free" => false,
                    "cross" => null,
                    "chime" => true
                };
    var found = false;

    for (var generic_i = 0; generic_i < 2; generic_i++){
        var days = db[generic_i]["last"];
        for (var day = current_day_crawl; day<= days; day++){
            if(db[generic_i]["days"].hasKey(current_day_crawl.toString())==true){
                event = db[generic_i]["days"][current_day_crawl.toString()];
                found = true;
                break;
            }
            
            current_day_crawl += 1;
        }

        if(found){break;}

        days_untill += current_day_crawl;
        current_day_crawl = 1;
        
    }

    return [current_day_crawl, days_untill, event];
}

(:glance)
public class SlidingText {

    var placement;
    var direction = 1;
    var length=1;
    var done=false;
    var test;

    var time_to_slide = 0;


    function initialize(int_context as Dc, where as Number) {
        placement = where;
    }

    function drawIt(context as Dc, text as String){
        length = 1.05* context.getTextDimensions(text, Graphics.FONT_SYSTEM_MEDIUM)[0]-context.getWidth();
        time_to_slide = length/35;
        context.drawText(placement, 1, Graphics.FONT_SYSTEM_MEDIUM, text, Graphics.TEXT_JUSTIFY_LEFT);
        done=true;
    }

    public function toggleDirection() as Void {
        direction = -1 * direction;
    }
}