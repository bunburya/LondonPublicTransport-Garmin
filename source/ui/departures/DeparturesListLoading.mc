import Toybox.WatchUi;
import Toybox.Lang;


// Display a loading screen and load the list of departure predictions
// for a single stop.
class DeparturesListLoadingView extends BaseLoadingView {
    private var _stopPoint as StopPoint;

    function initialize(stopPoint as StopPoint) {
        BaseLoadingView.initialize();
        _stopPoint = stopPoint;
        getTflApi().getStopPointDepartures(_stopPoint.id, method(:onReceive));
    }

    function onReceive(responseCode as Number, data as Array) {
        if (!validateResponse(responseCode, data)) {
            return;
        }
        
        var departures = [];
        for (var i = 0; i < data.size(); i++) {
            var d = data[i] as Dictionary;
            if (d["scheduledTimeOfDeparture"] != null) {
                departures.add(Departure.fromDict(d));
            }
        }

        departures.sort(new DepartureScheduledComparator());

        var view = new DeparturesListView(_stopPoint.name, departures);
        var delegate = new DeparturesListDelegate(departures, _stopPoint);
        WatchUi.switchToView(view, delegate, WatchUi.SLIDE_IMMEDIATE);

        WatchUi.requestUpdate();
    }
}
