import Toybox.Graphics;
import Toybox.WatchUi;
using Toybox.Time;
using Toybox.Time.Gregorian;
import Toybox.Lang;
import Toybox.Application;
import Toybox.System;
import Toybox.Communications;

class OverviewView extends WatchUi.View {

    var overview_draw = new Rez.Drawables.overview_draw();

    var db as Dictionary = {};
    var now_month = Storage.getValue("now_month") as Number;
    var current_month = now_month;
    var now_day = Storage.getValue("now_day") as Number;
    var current_day = now_day;

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

    var main_res_dict = [
            Rez.JsonData.main_ianuarie,
            Rez.JsonData.main_februarie,
            Rez.JsonData.main_martie,
            Rez.JsonData.main_aprilie,
            Rez.JsonData.main_mai,
            Rez.JsonData.main_iunie,
            Rez.JsonData.main_iulie,
            Rez.JsonData.main_august,
            Rez.JsonData.main_septembrie,
            Rez.JsonData.main_octombrie,
            Rez.JsonData.main_noiembrie,
            Rez.JsonData.main_decembrie
        ];

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
        // _month.setText(db[current_month-1]["month"]);

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
        db=Application.loadResource(main_res_dict[current_month-1]);

        free_day_color = Properties.getValue("free_day_color") as Number;
        black_cross_color = Properties.getValue("black_cross_color") as Number;
        red_cross_color = Properties.getValue("red_cross_color") as Number;
    }

    function drawBackground(dc as Dc) as Void {
        var deadSpace = getDeadSpace(diameter, rootHight+font_h_XTINY);

        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(deadSpace, rootHight+font_h_XTINY, (diameter-deadSpace)*0.9, rootHight+font_h_XTINY);
        overview_draw.draw( dc );
    }

    function drawForeground(dc as Dc, month as Dictionary<String, Dictionary or String or Number>) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        var index = 2-month["weeks"]["1"]["start_day_index"]; // Force on negative if start day not monday
        var last = month["last"]; // Last day or the month


        dc.drawText(
            diameter/2,                      // gets the width of the device and divides by 2
            0.03*diameter,                     // gets the height of the device and divides by 2
            Graphics.FONT_XTINY,                    // sets the font size
            month["month"],                          // the String to display
            Graphics.TEXT_JUSTIFY_CENTER            // sets the justification for the text
        );

        //////////////////////////
        // Draw week days 
        //////////////////////////
        var weekdayname = ["Lu", "Ma", "Mi", "Jo", "Vi", "Sm", "Du"];

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
        for (var i = 1; i <= 6; i += 1){ // Weeks
            for (var j = 0; j <= 6; j+=1){ // Days

                if(index<1){ // If index <0 (week not started monday), skip
                    index += 1;
                    continue;
                }

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
                if(month["weeks"][weeks_nr.toString()]["days"].hasKey(index.toString())==true){
                    if("black".equals(month["weeks"][weeks_nr.toString()]["days"][index.toString()]["cross"])){
                        dc.setColor(black_cross_color, Graphics.COLOR_TRANSPARENT);
                        dc.fillCircle(rootWidth + j * width/6 + font_h_XTINY/2 - mark_diameter, rootHight + i * hight/6 + 1.1*font_h_XTINY, mark_radius);
                    }

                    if(month["weeks"][weeks_nr.toString()]["days"][index.toString()]["free"]==true){
                        dc.setColor(free_day_color, Graphics.COLOR_TRANSPARENT);
                        dc.fillCircle(rootWidth + j * width/6 + font_h_XTINY/2, rootHight + i * hight/6 + 1.1*font_h_XTINY, mark_radius);
                    }

                    if("red".equals(month["weeks"][weeks_nr.toString()]["days"][index.toString()]["cross"])){
                        dc.setColor(red_cross_color, Graphics.COLOR_TRANSPARENT);
                        dc.fillCircle(rootWidth + j * width/6 + font_h_XTINY/2 + mark_diameter, rootHight + i * hight/6 + 1.1*font_h_XTINY, mark_radius);
                    }
                }

                ///////////////////////////////
                // Draw circle for current day
                ///////////////////////////////
                if(now_month == current_month && now_day == index){
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
        Storage.setValue("current_month", current_month);
        db=Application.loadResource(main_res_dict[current_month-1]);

        writeLog("OverviewView:onUpdate", db["month"]+" loaded.", 100);

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

    function onDataReceived(data) as Lang.Boolean {
        current_month = data;
        WatchUi.requestUpdate();
        return true;
    }
}
