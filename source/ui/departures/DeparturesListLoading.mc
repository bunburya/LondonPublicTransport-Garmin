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

    function onReceive(responseCode, data) {
        var departuresData = [];
        var errorMessage = null;
        if (responseCode == 200) {
            if (data != null) {
                departuresData = data as Array<Dictionary>;
            } else {
                errorMessage = "No data received.";
            }
        } else {
            errorMessage = "Bad HTTP response: " + responseCode;
        }

        if (errorMessage != null) {
            System.println("Error: " + errorMessage);
        }

        var departures = [];

        for (var i = 0; i < departuresData.size(); i++) {
            departures.add(Departure.fromDict(departuresData[i]));
        }

        departures.sort(new DepartureScheduledComparator());

        var view = new DeparturesListView(_stopPoint.name, departures);
        var delegate = new DeparturesListDelegate(departures);
        WatchUi.switchToView(view, delegate, WatchUi.SLIDE_IMMEDIATE);

        WatchUi.requestUpdate();
    }
}
