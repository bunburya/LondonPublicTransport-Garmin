import Toybox.Lang;

class DeparturesSplocView extends StopPointListOrConfigView {

    function initialize(stopPoints, configTitle) {
        StopPointListOrConfigView.initialize(
            stopPoints,
            configTitle,
            DEPARTURES_STOPPOINTS,
            DEPARTURES_MODES,
            DEPARTURES_LINES
        );
    }

    function onSelect(item) {
        var id = item.getId() as Number;
        var view = new DeparturesListLoadingView(_stopPoints[id]);
        WatchUi.pushView(view, null, WatchUi.SLIDE_LEFT);
    }
}

class DeparturesSplocDelegate extends StopPointListOrConfigDelegate {

    function initialize(stopPoints, configTitle) {
        StopPointListOrConfigDelegate.initialize(
            stopPoints,
            configTitle,
            DEPARTURES_STOPPOINTS,
            DEPARTURES_MODES,
            DEPARTURES_LINES
        );
    }

    function onSelect(item) {
        var id = item.getId() as Number;
        var view = new DeparturesListLoadingView(_stopPoints[id]);
        WatchUi.pushView(view, null, WatchUi.SLIDE_LEFT);
    }

}