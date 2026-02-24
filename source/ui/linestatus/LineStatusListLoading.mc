import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Application;

class StatusListLoadingView extends BaseLoadingView {
    private var _tflApi as TflApi;
    private var _lineIds as Array<String>;

    function initialize() {
        BaseLoadingView.initialize();
        _tflApi = new TflApi();
        _lineIds = Application.Storage.getValue(LINE_STATUS_LINES);
    }

    function onReceive(responseCode, data) {
        if (!validateResponse(responseCode, data)) {
            return;
        }
        var lineStatusData = [];
        data = data as Array<Dictionary>;
        var lineStatusDict = lineStatusDataDict(data);
        for (var i = 0; i < _lineIds.size(); i++) {
            lineStatusData.add(lineStatusDict[_lineIds[i]]);
        }
        var listView = new LineStatusListView(lineStatusData);
        var delegate = new LineStatusListDelegate(lineStatusData);
        WatchUi.switchToView(listView, delegate, WatchUi.SLIDE_IMMEDIATE);
        WatchUi.requestUpdate();
    }

    function onShow() {
        if (_lineIds == null || _lineIds.size() == 0) {
            // If no lines configured, switch straight to the config view.
            var view = new LineStatusConfigView([]);
            var delegate = new LineStatusConfigDelegate([]);
            WatchUi.switchToView(view, delegate, WatchUi.SLIDE_IMMEDIATE);
        } else {
            _tflApi.getLineStatuses(_lineIds, method(:onReceive));
        }
        WatchUi.requestUpdate();
    }
}
