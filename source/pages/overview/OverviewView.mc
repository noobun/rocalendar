import Toybox.Graphics;
import Toybox.WatchUi;
using Toybox.Time;
using Toybox.Time.Gregorian;
import Toybox.Lang;
import Toybox.Application;
import Toybox.System;
import Toybox.Communications;
using Toybox.Time.Gregorian;
using Toybox.Time;

class OverviewView extends WatchUi.View {

    var overview_draw = new Rez.Drawables.overview_draw();

    var db as Dictionary = {};
    var now_month = Storage.getValue("now_month") as Number;
    var now_year = Storage.getValue("now_year") as Number;
    var now_day = Storage.getValue("now_day") as Number;

    var selected_mount = now_month;
    var selected_year = now_year;
    var selected_day = now_day;

    var free_day_color as Number = 0;
    var black_cross_color as Number = 0;
    var red_cross_color as Number = 0;

    var diameter as Number = 0;  // Diameter of the screen, round only
    var font_h_XTINY as Number = 0;  // H of the TINY font
    var collon_w as Number = 0;// Width of a collon in the camendar given 7 total

    var rootHight as Number = 0; // Starting point for vertical alligment
    var hight as Number = 0; // Hight of the calendar

    var rootWidth as Number = 0; // Starting point for horizonal alligment
    var width as Number = 0; // Width of the calendar

    function initialize() {
        View.initialize();

        free_day_color = Properties.getValue("free_day_color") as Number;
        black_cross_color = Properties.getValue("black_cross_color") as Number;
        red_cross_color = Properties.getValue("red_cross_color") as Number;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.view_overview(dc));

        // _month = findDrawableById("month") as WatchUi.Text;
        // _month.setText(db[selected_mount-1]["month"]);

        diameter = dc.getHeight(); // Diameter of the screen, round only
        font_h_XTINY = dc.getFontHeight(Graphics.FONT_XTINY); // H of the TINY font
        collon_w = (diameter - font_h_XTINY)/8; // Width of a collon in the camendar given 7 total
        rootHight = diameter/8; // Starting point for vertical alligment
        hight = diameter*3/5; // Hight of the calendar
        rootWidth = diameter/6; // Starting point for horizonal alligment
        width = diameter*3/5; // Width of the calendar

        WatchUi.requestUpdate();
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        db=Application.loadResource(getSupportedYears()[selected_year.toString()]);

        free_day_color = Properties.getValue("free_day_color") as Number;
        black_cross_color = Properties.getValue("black_cross_color") as Number;
        red_cross_color = Properties.getValue("red_cross_color") as Number;
    }

    function drawBackground(dc as Dc) as Void {
        var deadSpace = getDeadSpace(diameter, rootHight+font_h_XTINY);

        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(deadSpace, rootHight+font_h_XTINY, (diameter-deadSpace)*0.9, rootHight+font_h_XTINY);
        
        dc.drawText(
            diameter/2,                      // gets the width of the device and divides by 2
            0.90*diameter,                     // gets the height of the device and divides by 2
            Graphics.FONT_XTINY,                    // sets the font size
            selected_year.toString(),                          // the String to display TODO: Use name not index
            Graphics.TEXT_JUSTIFY_CENTER            // sets the justification for the text
        );
        
        overview_draw.draw( dc );
    }

    function drawForeground(dc as Dc, month as Dictionary<String, Dictionary or String or Number>) as Void {
        var options = {
            :year   => 2025,
            :month  => selected_mount,
            :day    => 1,
            :hour   => 0
        };
        var date = Gregorian.moment(options);
        writeLog("OverviewDelegate:eventHandling", "First day in mount:"+Gregorian.info(date, Time.FORMAT_SHORT).day_of_week, 100);
        writeLog("OverviewView:onUpdate", "End day in mount:"+getDaysInMonth(2025, selected_mount).toString(), 100);
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        var index = 2-(Gregorian.info(date, Time.FORMAT_SHORT).day_of_week-1); // -1 for week start saturday, Force on negative if start day not monday
        var last = getDaysInMonth(2025, selected_mount); // Last day or the month     

        dc.drawText(
            diameter/2,                      // gets the width of the device and divides by 2
            0.03*diameter,                     // gets the height of the device and divides by 2
            Graphics.FONT_XTINY,                    // sets the font size
            monthname[selected_mount-1],                          // the String to display TODO: Use name not index
            Graphics.TEXT_JUSTIFY_CENTER            // sets the justification for the text
        );

        //////////////////////////
        // Draw week days 
        //////////////////////////

        for (var i = 1; i <= 7; i += 1){
            dc.drawText(
                rootWidth + (i-1) * width/6 + font_h_XTINY/2,                      // gets the width of the device and divides by 2
                rootHight,                     // gets the height of the device and divides by 2
                Graphics.FONT_XTINY,                    // sets the font size
                weekdayname[i-1],                          // the String to display
                Graphics.TEXT_JUSTIFY_CENTER            // sets the justification for the text
            );
        }

        //////////////////////////
        // Draw dates
        //////////////////////////
        var weeks_nr = 1;
        var day_nr = 0;
        for (var i = 1; i <= 6; i += 1){ // Weeks
            for (var j = 0; j <= 6; j+=1){ // Days

                if(index<1){ // If index <0 (week not started monday), skip
                    index += 1;
                    continue;
                }
                day_nr++;
                //writeLog("OverviewView:drawForeground", "Idenx day:"+day_nr.toString(), 100);
                // Set Color for Day
                if((j+1)%6==0){
                    dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
                }
                if((j+1)%7==0){
                    dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
                }

                // Draw day number
                dc.drawText(
                        rootWidth + j * width/6 + font_h_XTINY/2, // gets the width of the device and divides by 2
                        rootHight + i * hight/6, // gets the height of the device and divides by 2
                        Graphics.FONT_XTINY,            // sets the font size
                        index,                          // the String to display
                        Graphics.TEXT_JUSTIFY_CENTER    // sets the justification for the text
                    );

                // Determine of an event exists in the current drawing day
                var mark_radius = font_h_XTINY/5;
                var mark_diameter = mark_radius * 2;
                if(month.hasKey(day_nr.toString())==true){
                    var free  = month[day_nr.toString()]["opt"].substring(0, 1);
                    var color  = month[day_nr.toString()]["opt"].substring(1, 2);

                    if("b".equals(color)){
                        dc.setColor(black_cross_color, Graphics.COLOR_TRANSPARENT);
                        dc.fillCircle(rootWidth + j * width/6 + font_h_XTINY/2 - mark_diameter, rootHight + i * hight/6 + 1.1*font_h_XTINY, mark_radius);
                    }

                    if("t".equals(free)){
                        dc.setColor(free_day_color, Graphics.COLOR_TRANSPARENT);
                        dc.fillCircle(rootWidth + j * width/6 + font_h_XTINY/2, rootHight + i * hight/6 + 1.1*font_h_XTINY, mark_radius);
                    }

                    if("r".equals(color)){
                        dc.setColor(red_cross_color, Graphics.COLOR_TRANSPARENT);
                        dc.fillCircle(rootWidth + j * width/6 + font_h_XTINY/2 + mark_diameter, rootHight + i * hight/6 + 1.1*font_h_XTINY, mark_radius);
                    }
                }

                ///////////////////////////////
                // Draw circle for current day
                ///////////////////////////////
                if(now_month == selected_mount && now_day == index){
                    dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
                    dc.setPenWidth(3);
                    dc.drawArc(rootWidth + j * width/6 + font_h_XTINY/2, 
                                rootHight + i * hight/6 + font_h_XTINY/2, 
                                font_h_XTINY/2, 
                                Graphics.ARC_COUNTER_CLOCKWISE, 
                                0, 180);
                    dc.setPenWidth(1);
                }

                index += 1;
                if(index>last){
                    break;
                }
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT); // Reset color
            }
            weeks_nr += 1;
            if(index>last){
                break;
            }
        }
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        //Storage.setValue("selected_mount", selected_mount); // Done in delegate
        
        db=Application.loadResource(getSupportedYears()[selected_year.toString()])[selected_mount-1];

        View.onUpdate(dc);
        drawBackground(dc);
        drawForeground(dc, db);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        db = {};
    }

    function onDataReceived(month, year) as Lang.Boolean {
        selected_mount = month;
        selected_year = year;
        WatchUi.requestUpdate();
        return true;
    }
}
