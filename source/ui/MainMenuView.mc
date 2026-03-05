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
        } else if (id == :arrivals) {
            var stopPoints = loadStopPoints(ARRIVALS_STOPPOINTS);
            var view = new StopPointListOrConfigView(
                stopPoints,
                "Configure Arrivals",
                ARRIVALS_STOPPOINTS,
                ARRIVALS_MODES,
                ARRIVALS_LINES
            );
            var delegate = new StopPointListOrConfigDelegate(
                stopPoints,
                "Configure Arrivals",
                ARRIVALS_STOPPOINTS,
                ARRIVALS_MODES,
                ARRIVALS_LINES
            );
            WatchUi.pushView(view, delegate, WatchUi.SLIDE_LEFT);
        } else if (id == :departures) {
            var stopPoints = loadStopPoints(DEPARTURES_STOPPOINTS);
            var view = new StopPointListOrConfigView(
                stopPoints,
                "Configure Departures",
                DEPARTURES_STOPPOINTS,
                DEPARTURES_MODES,
                DEPARTURES_LINES
            );
            var delegate = new StopPointListOrConfigDelegate(
                stopPoints,
                "Configure Departures",
                DEPARTURES_STOPPOINTS,
                DEPARTURES_MODES,
                DEPARTURES_LINES
            );
            WatchUi.pushView(view, delegate, WatchUi.SLIDE_LEFT);
        }
    }
}