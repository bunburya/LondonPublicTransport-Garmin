import Toybox.WatchUi;
import Toybox.Lang;

// View the arrival predictions for a single stop.
class StopPointArrivalsLoadingView extends BaseLoadingView {
    private var _tflApi as TflApi;
    private var _stopId as String;
    private var _stopName as String;

    function initialize(stopId as String, stopName as String) {
        BaseLoadingView.initialize();
        _tflApi = new TflApi();
        _stopId = stopId;
        _stopName = stopName;
        _tflApi.getStopPointArrivals(_stopId, method(:onReceive));
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

        var listView = new StopPointArrivalsView(_stopId,_stopName, arrivalsData);
        WatchUi.switchToView(listView, null, WatchUi.SLIDE_IMMEDIATE);

        WatchUi.requestUpdate();
    }
}
