import Toybox.WatchUi;
import Toybox.Lang;

class StatusListLoadingView extends WatchUi.View {
    private var _tflApi as TflApi;

    function initialize() {
        View.initialize();
        _tflApi = new TflApi();
        _tflApi.getModeLineStatuses(["tube"], method(:onReceive));
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            dc.getWidth() / 2,
            dc.getHeight() / 2,
            Graphics.FONT_MEDIUM,
            "Loading...",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
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
        }

        var listView = new StatusListView(lineStatusData);
        var delegate = new StatusListDelegate(lineStatusData);
        WatchUi.switchToView(listView, delegate, WatchUi.SLIDE_IMMEDIATE);

        WatchUi.requestUpdate();
    }
}
