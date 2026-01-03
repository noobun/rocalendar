import Toybox.Graphics;
import Toybox.WatchUi;
using Toybox.Time;
using Toybox.Time.Gregorian;
import Toybox.Lang;
import Toybox.System;
import Toybox.Lang;
import Toybox.WatchUi;
using WatchUi as Ui;
import Toybox.Application;
import Toybox.System;
import Toybox.Communications;
using Toybox.Graphics;
using Toybox.Attention;

(:glance)
class OverviewGlanceView extends WatchUi.GlanceView
{
    var slidingText;

    function initialize() {
        GlanceView.initialize(); 
    }

    function onLayout(dc){
        
    }

    function animCallback() as Void{
        if(slidingText.length > 0){
            if(slidingText.direction == 1){
                WatchUi.animate(slidingText, :placement, WatchUi.ANIM_TYPE_LINEAR, -slidingText.length, 0, slidingText.time_to_slide, method(:animCallback));
            }else{
                WatchUi.animate(slidingText, :placement, WatchUi.ANIM_TYPE_LINEAR, 0, -slidingText.length, slidingText.time_to_slide, method(:animCallback));
            }
            slidingText.toggleDirection();
        }else{
            writeLog("GlanceView:animCallback", "Suspended due to text fitting", 100);
        }
    }

    function onShow() as Void {
        var now = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var years = getSupportedYears();
        var event = null;
        var days_untill=-1;
        var supported_years = Properties.getValue("supportedyears") as Number;
        var res=null;

        for (var i = 0; i < 1+supported_years; i++) { // Loop in supported years
            var y_key = (now.year+i).toString();
            if (y_key.toNumber() < now.year){ // if supported year < current year, skip
                continue;
            }
            

            res = Application.loadResource(years[y_key]); // load supported year
            
            for(var mo=1; mo<=12; mo+=1){ // Loop inside months
                if(mo<now.month and y_key.toNumber()<=now.year){ // IF supported month < current month, skip
                    continue;
                }
                var days_keys_str = res[mo-1].keys();
                var days_keys = [];
                for (var k =0; k < days_keys_str.size(); k++){
                    days_keys.add(days_keys_str[k].toNumber());
                }
                days_keys.sort(null); 
                for (var j = 0; j < days_keys.size(); j++) { // Loop inside days

                        var d_key = days_keys[j];
                        if(d_key<now.day and mo<=now.month and y_key.toNumber()<=now.year){ // If supported day < current day, skip
                            continue;
                        }

                        writeLog("GlanceView:onShow", "Now:"+now.year.toString()+"."+now.month.toString()+"."+now.day.toString(), 100);
                        writeLog("GlanceView:onShow", "Event at :"+(now.year+i).toString()+"."+mo.toString()+"."+d_key, 100);
                        
                        days_untill =  Gregorian.moment({:year => now.year+i, :month => mo, :day => d_key}).subtract(Gregorian.moment({:year => now.year, :month => now.month, :day => now.day})).value()/Gregorian.SECONDS_PER_DAY;
                        event = res[mo-1][d_key.toString()]; // Event found
                        break;
                    
                }
                if(event){break;}
            }
            res = null;
            if(event){break;}
        }

        if(event != null){
            if(days_untill == 0){
                event["untill_prompt"] = "astazi";
            }else if(days_untill == 1){
                event["untill_prompt"] = "maine";
            }else{
                event["untill_prompt"] = "in "+days_untill.toString()+" zile";
            }
            Storage.setValue("glance_event", event);
        }else{
            Storage.setValue("glance_event", null);
        }

        writeLog("GlanceView:onUpdate", event.toString(), 100);
    }

    function onHide() as Void {
        writeLog("glanceView:onHide", "Cleanup", 100);
    }

    function onUpdate(dc) {
        var free_day_color = Properties.getValue("free_day_color") as Number;
        var black_cross_color = Properties.getValue("black_cross_color") as Number;
        var red_cross_color = Properties.getValue("red_cross_color") as Number;

        var font_h_XTINY = dc.getFontHeight(Graphics.FONT_XTINY); 
        var font_h_TINY = dc.getFontHeight(Graphics.FONT_TINY); 

        var event = Storage.getValue("glance_event") as Dictionary;
        if(event != null){
            var free  = event["opt"].substring(0, 1);
            var color  = event["opt"].substring(1, 2);

            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(0, 0.5*dc.getHeight()-font_h_TINY/2, Graphics.FONT_SYSTEM_TINY, event["untill_prompt"], Graphics.TEXT_JUSTIFY_LEFT);

            if("b".equals(color)){
                dc.setColor(black_cross_color, Graphics.COLOR_TRANSPARENT);
                dc.fillCircle(dc.getWidth()-3*font_h_XTINY, 0.5*dc.getHeight(), font_h_XTINY/2);
            }

            if("t".equals(free)){
                dc.setColor(free_day_color, Graphics.COLOR_TRANSPARENT);
                dc.fillCircle(dc.getWidth()-2*font_h_XTINY, 0.5*dc.getHeight(), font_h_XTINY/2);
            }

            if("r".equals(color)){
                dc.setColor(red_cross_color, Graphics.COLOR_TRANSPARENT);
                dc.fillCircle(dc.getWidth()-font_h_XTINY, 0.5*dc.getHeight(), font_h_XTINY/2);
            }
        }else{
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(0, 0.5*dc.getHeight()-font_h_TINY/2, Graphics.FONT_SYSTEM_TINY, "no event", Graphics.TEXT_JUSTIFY_LEFT);
        }
    } 
}