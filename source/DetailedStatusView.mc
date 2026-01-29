using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
import Toybox.Lang;

// Factory that creates text pages
class DetailedStatusViewFactory extends WatchUi.ViewLoopFactory {
    private var _statuses as Array<LineStatus>;

    function initialize(statusData as LineStatusData) {
        ViewLoopFactory.initialize();
        _statuses = statusData.statuses; 
    }

    function getSize() {
        return _statuses.size();
    }

    function getView(idx as Number) {
        var lineStatus = _statuses[idx];
        var view = new DetailedStatusView(lineStatus);
        return [view, new WatchUi.BehaviorDelegate()];
    }
}

// Individual text page view
class DetailedStatusView extends WatchUi.View {
    private var _status;

    function initialize(status as LineStatus) {
        View.initialize();
        _status = status;
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        var textArea = new WatchUi.TextArea({
            :text => _status.description + "\n\n" + _status.reason,
            :color => Graphics.COLOR_WHITE,
            :font => [Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_XTINY],
            :locX => WatchUi.LAYOUT_HALIGN_LEFT,
            :locY => WatchUi.LAYOUT_VALIGN_TOP,
            :width => dc.getWidth(),
            :height => dc.getHeight()
        });
        textArea.draw(dc);
    }

    // Helper function to draw text with word wrapping
    function drawWrappedText(dc, text, x, y, maxWidth, font) {
        var words = splitString(text, " ") as Array<String>;
        var line = "";
        var lineHeight = dc.getFontHeight(font);
        var currentY = y;
        
        for (var i = 0; i < words.size(); i++) {
            var testLine = line.length() > 0 ? line + " " + words[i] : words[i];
            var testWidth = dc.getTextWidthInPixels(testLine, font);
            
            if (testWidth > maxWidth && line.length() > 0) {
                // Line is too long, draw current line and start new one
                dc.drawText(x, currentY, font, line, Graphics.TEXT_JUSTIFY_LEFT);
                line = words[i];
                currentY += lineHeight;
            } else {
                line = testLine;
            }
        }
        
        // Draw the last line
        if (line.length() > 0) {
            dc.drawText(x, currentY, font, line, Graphics.TEXT_JUSTIFY_LEFT);
        }
    }


}