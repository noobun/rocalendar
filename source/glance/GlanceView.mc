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
    var free_day_color as Number = 0;
    var black_cross_color as Number = 0;
    var red_cross_color as Number = 0;

    var untill_prompt as String="";

    var slidingText;

    var event as String="";

    var db as Array=[];

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
        var now_month = Gregorian.info(Time.now(), Time.FORMAT_SHORT).month;
        db=[Application.loadResource(glance_res_dict[now_month-1])];

        if(now_month < 12){
            db.add(Application.loadResource(glance_res_dict[now_month]));
        }

        var now = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var now_day = now.day;

        free_day_color = Properties.getValue("free_day_color") as Number;
        black_cross_color = Properties.getValue("black_cross_color") as Number;
        red_cross_color = Properties.getValue("red_cross_color") as Number;

        var payload = getNextEvent(now_day, db);
        var days_untill = payload[1];
        event= payload[2];
        var current_day_crawl = payload[0];

        var untill_days = days_untill+current_day_crawl-now_day;
        if(untill_days == 0){
            untill_prompt = "astazi";
        }else if(untill_days == 1){
            untill_prompt = "maine";
        }else{
            untill_prompt = "in "+untill_days.toString()+" zile";
        }
    }

    function onHide() as Void {
        writeLog("glanceView:onHide", "Cleanup", 100);
        db = [];
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var font_h_XTINY = dc.getFontHeight(Graphics.FONT_XTINY); 
        var font_h_TINY = dc.getFontHeight(Graphics.FONT_TINY); 

        dc.drawText(0, 0.5*dc.getHeight()-font_h_TINY/2, Graphics.FONT_SYSTEM_TINY, untill_prompt, Graphics.TEXT_JUSTIFY_LEFT);

        if("black".equals(event["cross"])){
            dc.setColor(black_cross_color, Graphics.COLOR_TRANSPARENT);
            dc.fillCircle(dc.getWidth()-3*font_h_XTINY, 0.5*dc.getHeight(), font_h_XTINY/2);
        }

        if(event["free"]==true){
            dc.setColor(free_day_color, Graphics.COLOR_TRANSPARENT);
            dc.fillCircle(dc.getWidth()-2*font_h_XTINY, 0.5*dc.getHeight(), font_h_XTINY/2);
        }

        if("red".equals(event["cross"])){
            dc.setColor(red_cross_color, Graphics.COLOR_TRANSPARENT);
            dc.fillCircle(dc.getWidth()-font_h_XTINY, 0.5*dc.getHeight(), font_h_XTINY/2);
        }
    } 
}