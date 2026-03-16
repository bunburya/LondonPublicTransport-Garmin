import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class SettingsMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        WatchUi.Menu2InputDelegate.initialize();
    }

    function onSelect(item as MenuItem) as Void {
        var id = item.getId();
        var view, delegate;
        if (id == :config_line_status) {
            var selectedIds = Application.Storage.getValue(LINE_STATUS_LINES);
            if (selectedIds == null) {
                selectedIds = [];
            }
            view = new LineStatusConfigView(selectedIds);
            delegate = new LineStatusConfigDelegate(selectedIds);
        } else if (id == :config_arrival_stops) {
            var stopPoints = Application.Storage.getValue(ARRIVALS_STOPPOINTS) as Array?;
            if (stopPoints == null) { stopPoints = []; }
            view = new StopPointsConfigView(
                stopPoints,
                WatchUi.loadResource(Rez.Strings.ConfigArrivalStops),
                ARRIVALS_STOPPOINTS,
                ARRIVALS_MODES,
                ARRIVALS_LINES
            );
            delegate = new StopPointsConfigDelegate(
                stopPoints,
                ARRIVALS_STOPPOINTS,
                ARRIVALS_MODES,
                ARRIVALS_LINES
            );

        } else if (id == :config_departure_stops) {
            var stopPoints = Application.Storage.getValue(DEPARTURES_STOPPOINTS) as Array?;
            if (stopPoints == null) { stopPoints = []; }
            view = new StopPointsConfigView(
                stopPoints,
                WatchUi.loadResource(Rez.Strings.ConfigDepartureStops),
                DEPARTURES_STOPPOINTS,
                DEPARTURES_MODES,
                DEPARTURES_LINES
            );
            delegate = new StopPointsConfigDelegate(
                stopPoints,
                DEPARTURES_STOPPOINTS,
                DEPARTURES_MODES,
                DEPARTURES_LINES
            );
        } else {
            return;
        }
        WatchUi.pushView(view, delegate, SLIDE_RIGHT);
    }
}