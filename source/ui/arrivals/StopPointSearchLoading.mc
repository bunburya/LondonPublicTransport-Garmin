import Toybox.Lang;

class StopPointSearchLoadingView extends BaseLoadingView {
    private var _query as String;
    
    function initialize(query as String) {
        BaseLoadingView.initialize();
        _query = query;
    }

    function onShow() as Void {
        System.println("StopPointSearchLoadingView onShow called");
        getTflApi().searchStopPoints(_query, method(:onReceive));
    }

    function onReceive(responseCode as Number, data as Dictionary) {
        System.println("StopPointSearchLoadingView onReceive called");
        if (!validateResponse(responseCode, data)) {
            return;
        }
        var array = data["matches"] as Array<Dictionary>;
        if (array == null || array.size() == 0) {
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            WatchUi.showToast("No results", null);
            return;
        }
        System.println("array: " + array.toString());
        var stopPoints = [];
        for (var i = 0; i < array.size(); i++) {
            stopPoints.add(StopPoint.fromDict(array[i]));
        }
        WatchUi.switchToView(new BaseStopPointListView("Search Results", stopPoints), null, SLIDE_IMMEDIATE);
        
    }
}