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

        var maxWidth = dc.getWidth();
        var maxHeight = dc.getHeight();

        var header = getHeader(maxWidth, maxHeight);
        var body = getBody(maxWidth, maxHeight);
        
        header.draw(dc);
        body.draw(dc);
    }

    function getHeader(width as Number, height as Number) as WatchUi.Text {
        var color;
        if (_status.internalSeverity < 9) {
            color = Graphics.COLOR_RED;
        } else if (_status.internalSeverity < 17) {
            color = Graphics.COLOR_ORANGE;
        } else {
            color = Graphics.COLOR_GREEN;
        }
        return new WatchUi.Text({
            :text => "\n" + _status.description,
            :color => color,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_TOP,
            :width => width,
            :height => height,
            :justification => Graphics.TEXT_JUSTIFY_CENTER
        });
    }

    function getBody(width as Number, height as Number) as WatchUi.TextArea {
        return new TextArea({
            :text => _status.reason,
            :color => Graphics.COLOR_WHITE,
            :font => [Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_XTINY],
            :locX => WatchUi.LAYOUT_HALIGN_LEFT,
            :locY => WatchUi.LAYOUT_VALIGN_TOP,
            :width => width,
            :height => height,
            :justification => Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        });
    }


}