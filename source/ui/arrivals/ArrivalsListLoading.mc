import Toybox.WatchUi;
import Toybox.Lang;

// Display a loading screen and load the list of arrival predictions
// for a single stop.
class ArrivalsListLoadingView extends BaseLoadingView {
    private var _tflApi as TflApi;
    private var _stopPoint as StopPoint;

    function initialize(stopPoint as StopPoint) {
        BaseLoadingView.initialize();
        _tflApi = new TflApi();
        _stopPoint = stopPoint;
        _tflApi.getStopPointArrivals(_stopPoint.id, method(:onReceive));
    }

    function onReceive(responseCode, data) {
        var arrivalsData = [];
        var errorMessage = null;
        if (responseCode == 200) {
            if (data != null) {
                arrivalsData = data as Array<Dictionary>;
            } else {
                errorMessage = "No data received.";
            }
        } else {
            errorMessage = "Bad HTTP response: " + responseCode;
        }

        if (errorMessage != null) {
            System.println("Error: " + errorMessage);
        }

        var stopPointArrivals = new StopPointArrivals(_stopPoint, arrivalsData);

        var listView = new ArrivalsListView(stopPointArrivals);
        WatchUi.switchToView(listView, new WatchUi.Menu2InputDelegate(), WatchUi.SLIDE_IMMEDIATE);

        WatchUi.requestUpdate();
    }
}
