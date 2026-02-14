import Toybox.WatchUi;
import Toybox.Lang;

class StatusListLoadingView extends BaseLoadingView {
    private var _tflApi as TflApi;

    function initialize() {
        BaseLoadingView.initialize();
        _tflApi = new TflApi();
        _tflApi.getModeLineStatuses(["tube"], method(:onReceive));
    }

    function onReceive(responseCode, data) {
        var lineStatusData = [];
        var errorMessage = null;
        if (responseCode == 200) {
            if (data != null) {
                data = data as Array<Dictionary>;
                lineStatusData = lineStatusDataArray(data);
            } else {
                errorMessage = "No data received.";
            }
        } else {
            errorMessage = "Bad HTTP response: " + responseCode;
        }

        if (errorMessage != null) {
            System.println("Error: " + errorMessage);
            System.println(data);
        }

        var listView = new StatusListView(lineStatusData);
        var delegate = new StatusListDelegate(lineStatusData);
        WatchUi.switchToView(listView, delegate, WatchUi.SLIDE_IMMEDIATE);

        WatchUi.requestUpdate();
    }
}
