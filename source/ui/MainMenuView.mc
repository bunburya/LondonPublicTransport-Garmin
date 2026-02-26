import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.System;

class MainMenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) {
        var id = item.getId();
        if (id == :line_status) {
            WatchUi.pushView(new StatusListLoadingView(), null, WatchUi.SLIDE_LEFT);
        } else if (id == :stop_arrivals) {
            var stopPoints = loadStopPoints(ARRIVALS_STOPPOINTS);
            var view = new StopPointListOrConfigView(stopPoints);
            var delegate = new StopPointListOrConfigDelegate(stopPoints, ARRIVALS_STOPPOINTS);
            WatchUi.pushView(view, delegate, WatchUi.SLIDE_LEFT);
        }
    }
}