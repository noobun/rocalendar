import Toybox.Graphics;
import Toybox.WatchUi;
using Toybox.Time;
using Toybox.Time.Gregorian;
import Toybox.Lang;
import Toybox.Application;
import Toybox.System;
import Toybox.Communications;
import Toybox.Math;

class MonthView extends WatchUi.View {
    hidden var drawMonth;

    var month_draw = new Rez.Drawables.month_draw();

    var selected_mount;
    var selected_year;
    var db = {};

    var scrolled_h;
    var render_h;
    var during_anim = false;

    var diameter;  // Diameter of the screen, round only
    var font_h_SMALL;  // H of the Small font
    var font_h_XTINY;  // H of the xTiny font
    var font_h_TINY; // H or the Tiny font
    var collon_w;// Width of a collon in the camendar given 7 total

    var rootHight; // Starting point for vertical alligment
    var hight; // Hight of the calendar

    var rootWidth; // Starting point for horizonal alligment
    var width; // Width of the calendar

    var eventList;
    var selected = 0;
    var selected_set = false;
    var canvas;

    function anim_finish() as Void{
        during_anim = false;
    }

    function initialize(){
        View.initialize();
        selected_set=false;
    }

    function drawBackground(dc as Dc) as Void {
        month_draw.draw( dc );
    }

    function onLayout(dc) as Void {
        setLayout(Rez.Layouts.view_month(dc));

        selected_mount = Storage.getValue("selected_mount");
        selected_year = Storage.getValue("selected_year");
        db=Application.loadResource(getSupportedYears()[selected_year.toString()])[selected_mount-1];

        drawMonth = new DrawMonth (dc);
        render_h = drawMonth.local_h;

        diameter = dc.getHeight(); // Diameter of the screen, round only
        font_h_XTINY = dc.getFontHeight(Graphics.FONT_XTINY); // H of the TINY font
        font_h_SMALL = dc.getFontHeight(Graphics.FONT_SMALL); // H of the TINY font
        font_h_TINY = dc.getFontHeight(Graphics.FONT_TINY); // H of the TINY font
        collon_w = Math.round((diameter - font_h_XTINY)/8); // Width of a collon in the camendar given 7 total
        rootHight = Math.round(diameter/2); // Starting point for vertical alligment
        hight = Math.round(diameter*3/5); // Hight of the calendar
        rootWidth = Math.round(diameter/6); // Starting point for horizonal alligment
        width = Math.round(diameter*3/5); // Width of the calendar

        scrolled_h = Math.round(diameter/3+1); //- font_h_TINY/2;

        writeLog("MonthView:onLayout", "Executed...", 100);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        writeLog("MonthView:onShow", "Current Working Month NR:"+selected_mount.toString(), 100);
        writeLog("MonthView:onShow", "Current Working Month:"+db, 100);
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        drawBackground(dc);

        writeLog("font_h_SMALL:", font_h_SMALL, 100);

        if(drawMonth==null){
            drawMonth = new DrawMonth (dc);
            render_h = drawMonth.local_h;
        }

        dc.setPenWidth(2);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(0, rootHight - font_h_SMALL, diameter, rootHight - font_h_SMALL);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		dc.drawText(diameter/2, rootHight-2*font_h_SMALL, Graphics.FONT_SYSTEM_SMALL, monthname[selected_mount-1], Graphics.TEXT_JUSTIFY_CENTER);
    	dc.drawText(diameter/2, rootHight-3*font_h_SMALL, Graphics.FONT_XTINY, selected_year.toString(), Graphics.TEXT_JUSTIFY_CENTER);


        dc.setClip(0, Math.round(rootHight - font_h_SMALL), diameter, diameter);

        eventList = drawMonth.drawData(selected_year, selected_mount, db, dc);

        dc.clearClip();
        if(!selected_set and selected_year == Storage.getValue("now_year") and selected_mount == Storage.getValue("now_month")){
            writeLog("MonthView:onUpdate", "Auto scroll enabled, move to next event", 100);
            for(var day=1; day<= getDaysInMonth(selected_year, selected_mount); day+=1){
                if(db.hasKey(day.toString())==true){
                    scroll(-1);
                    if(day >= Storage.getValue("now_day")){
                        selected_set=true;
                        break;
                    }
                }
            }
            selected_set=true;
        }

        writeLog("MonthView:onUpdate:eventList", eventList, 100);
        writeLog("MonthView:onUpdate", "executed", 100);
        
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        writeLog("MonthView:onHide", "Executed...", 100);
        db = {};
        drawMonth = null;
    }

    public function scroll(direction as Number) as Number {
        // direction 1 -> Down, -1 -> Up
        if((drawMonth.local_h >= rootHight - font_h_SMALL && direction == 1 ) || (direction == -1 && scrolled_h <= drawMonth.abs_h * -1 + diameter/2 + drawMonth.itemH)){
            writeLog("MonthView:scroll", "Stop Scroll due to max placement", 10);
        }
        else if(during_anim){
            writeLog("MonthView:scroll", "Animation in progress, skipping", 10);
        }else{
            during_anim = true;
            WatchUi.animate(drawMonth, :local_h, WatchUi.ANIM_TYPE_LINEAR, drawMonth.local_h, drawMonth.local_h+drawMonth.itemH*direction, 0.005, method(:anim_finish));
            scrolled_h += drawMonth.itemH*direction;
            selected+= (-1*direction);
        }
        writeLog("MonthView:scroll", "Selected Event:"+selected, 100);
        writeLog("MonthView:scroll", "scrolled_h: "+scrolled_h.toString()+"| local_h: "+drawMonth.abs_h+" | delta: "+(drawMonth.local_h * -1 + 150).toString(), 10);

        return selected;
    }

    function getCurrentEvent() as Lang.String {
        if(eventList.size()>0){
            writeLog("MonthView:getCurrentEvent", eventList, 100);
            writeLog("MonthView:getCurrentEvent", "Selected:"+selected, 100);
            var event_name = eventList[selected];
            selected = 0;
            return event_name;
        }else{
            return "NU EXISTA EVENIMENTE";
        }
    }
}

// Done as a class so it can be animated.
class DrawMonth extends WatchUi.Drawable
{		
    var db;   
    var local_h; 
    var abs_h;

    var selected_year;
    var selected_mount;

    var free_day_color;
    var black_cross_color;
    var red_cross_color;

    var diameter;  // Diameter of the screen, round only
    var font_h_SMALL;  // H of the Small font
    var font_h_XTINY;  // H of the xTiny font
    var font_h_TINY; // H or the Tiny font
    var itemH;

	function initialize (dc)
	{
        abs_h = 0;

        diameter = dc.getWidth();
        font_h_XTINY = dc.getFontHeight(Graphics.FONT_XTINY); // H of the TINY font
        font_h_SMALL = dc.getFontHeight(Graphics.FONT_SMALL); // H of the TINY font
        font_h_TINY = dc.getFontHeight(Graphics.FONT_TINY); // H of the TINY font
        itemH = Math.round(1.2 * font_h_TINY + font_h_XTINY);
        
        local_h = diameter/2-itemH/2;
        db = db;

        writeLog("MonthView:DrawMonth", "Initialize", 100);
        
        free_day_color = Properties.getValue("free_day_color") as Number;
        black_cross_color = Properties.getValue("black_cross_color") as Number;
        red_cross_color = Properties.getValue("red_cross_color") as Number;
    }
	
	function drawData (year, month, db, dc) as Array
	{
        selected_year = year;
        selected_mount = month;

        var eventList = [];

        writeLog("MonthView:draw", local_h, 100);

        var render_h = local_h;
        var items = 0;
        abs_h = 0;

        dc.setPenWidth(2);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(5, Math.round(dc.getHeight()/2-0.4*itemH), 5, Math.round(dc.getHeight()/2+0.4*itemH));


        for(var day=1; day<= getDaysInMonth(selected_year, selected_mount); day+=1){
            if(db.hasKey(day.toString())==true){
                var event = db[day.toString()];
                render_h = drawEventItem(dc, render_h, event, day);
                eventList.add(event["name"]);
                items += 1;
            }
        }

        if(items == 0){
            // no drawing
            dc.drawText(dc.getWidth()/2, render_h, Graphics.FONT_SYSTEM_SMALL, "FARA EVENIMENTE", Graphics.TEXT_JUSTIFY_CENTER);
        }
        writeLog("MonthView:draw", "executed", 100);

        return eventList;
	}
	
	// highlight is the selected menu item that can optionally show a value.
	function drawEventItem (dc, render_h, event, day) as Number
	{
        var free  = event["opt"].substring(0, 1);
        var color  = event["opt"].substring(1, 2);

        if("b".equals(color)){
            dc.setColor(black_cross_color, Graphics.COLOR_TRANSPARENT);
            dc.fillCircle(diameter/20*4, render_h+itemH*1/4, itemH/5/2);
        }

        if("t".equals(free)){
            dc.setColor(free_day_color, Graphics.COLOR_TRANSPARENT);
            dc.fillCircle(diameter/20*4, render_h+itemH*2/4, itemH/5/2);
        }

        if("r".equals(color)){
            dc.setColor(red_cross_color, Graphics.COLOR_TRANSPARENT);
            dc.fillCircle(diameter/20*4, render_h+itemH*3/4, itemH/5/2);
        }
        dc.drawText(diameter/20*3, render_h+(itemH-font_h_TINY)/2, Graphics.FONT_SYSTEM_TINY, day, Graphics.TEXT_JUSTIFY_RIGHT);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

		dc.drawText(diameter/20*5, render_h, Graphics.FONT_SYSTEM_TINY, event["name"], Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(diameter/20*5, render_h + font_h_TINY*1.1, Graphics.FONT_SYSTEM_XTINY, event["desc"], Graphics.TEXT_JUSTIFY_LEFT);
	
        dc.setPenWidth(1);
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(10, render_h + itemH, dc.getWidth()-10, render_h + itemH);

        abs_h += itemH;
        return render_h+itemH;
    }
}
