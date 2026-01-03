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
function getSupportedYears(){
    return {
        "2025" => Rez.JsonData.year_2025,
        "2026" => Rez.JsonData.year_2026
    };
}

(:glance)
function getRelativeYears(current as Number, direction as Number){
    var sup_years = getSupportedYears().keys();
    var years_array = [];
    for (var i = 0; i < sup_years.size(); i++){
        years_array.add(sup_years[i].toNumber());
    }
    years_array.sort(null);
    var current_index = years_array.indexOf(current);
    var next_index = current_index+direction;

    //writeLog("generic:getRelativeYear", years_array.slice(next_index%years_array.size(), next_index%years_array.size()).toString(), 100);
    //return years_array.slice(next_index%years_array.size(), next_index%years_array.size())[0];
    return years_array[(next_index%years_array.size()).abs()];
}

var weekdayname = ["Lu", "Ma", "Mi", "Jo", "Vi", "Sm", "Du"];

var monthname = ["Ianuarie", "Februarie", "Martie", "Aprilie", "Mai", "Iunie",
                "Iulie", "August", "Septembrie", "Octombrie", "Noiembrie", "Decembrie"];   

(:glance )
function getDaysInMonth(year as Number, month as Number) as Number {

    // Create a moment for the 1st day of the current month
    var start = Gregorian.moment({
        :year  => year,
        :month => month,
        :day   => 1
    });

    // Create a moment for the 1st day of the next month
    var nextStart;
    if (month == 12) {
        nextStart = Gregorian.moment({
            :year  => year + 1,
            :month => 1,
            :day   => 1
        });
    } else {
        nextStart = Gregorian.moment({
            :year  => year,
            :month => month + 1,
            :day   => 1
        });
    }

    // Duration between them in seconds
    var diff = nextStart.subtract(start);

    // Convert seconds → days
    return diff.value() / Gregorian.SECONDS_PER_DAY;
}

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