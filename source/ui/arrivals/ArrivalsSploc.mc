import Toybox.Lang;

class ArrivalsSplocView extends StopPointListOrConfigView {

    function initialize(stopPoints, configTitle) {
        StopPointListOrConfigView.initialize(
            stopPoints,
            configTitle,
            ARRIVALS_STOPPOINTS,
            ARRIVALS_MODES,
            ARRIVALS_LINES
        );
    }

}

class ArrivalsSplocDelegate extends StopPointListOrConfigDelegate {

    function initialize(stopPoints, configTitle) {
        StopPointListOrConfigDelegate.initialize(
            stopPoints,
            configTitle,
            ARRIVALS_STOPPOINTS,
            ARRIVALS_MODES,
            ARRIVALS_LINES
        );
    }

    function onSelect(item) {
        var id = item.getId() as Number;
        var view = new ArrivalsListLoadingView(_stopPoints[id]);
        WatchUi.pushView(view, null, WatchUi.SLIDE_LEFT);
    }

}