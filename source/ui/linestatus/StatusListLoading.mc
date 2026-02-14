import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Application;

class StatusListLoadingView extends BaseLoadingView {
    private var _tflApi as TflApi;
    private var _lineIds as Array<String>;

    function initialize() {
        BaseLoadingView.initialize();
        _tflApi = new TflApi();
        _lineIds = Application.Storage.getValue("lineStatusSelection");
        if (_lineIds == null) {
            // If no lines configured, switch straight to the config view.
            var view = new LineStatusConfigView([]);
            var delegate = new LineStatusConfigDelegate([]);
            WatchUi.switchToView(view, delegate, SLIDE_IMMEDIATE);
        } else {
            _tflApi.getLineStatuses(_lineIds, method(:onReceive));
        }
    }

    function onReceive(responseCode, data) {
        var lineStatusData = [];
        var errorMessage = null;
        if (responseCode == 200) {
            if (data != null) {
                data = data as Array<Dictionary>;
                var lineStatusDict = lineStatusDataDict(data);
                for (var i = 0; i < _lineIds.size(); i++) {
                    lineStatusData.add(lineStatusDict[_lineIds[i]]);
                }
            } else {
                errorMessage = "No data received.";
            }
        } else {
            errorMessage = "Bad HTTP response: " + responseCode;
        }

        if (errorMessage == null) {
            var listView = new LineStatusListView(lineStatusData);
            var delegate = new LineStatusListDelegate(lineStatusData);
            WatchUi.switchToView(listView, delegate, WatchUi.SLIDE_IMMEDIATE);
        } else {
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            WatchUi.showToast(errorMessage, null);
        }
        WatchUi.requestUpdate();
    }
}
