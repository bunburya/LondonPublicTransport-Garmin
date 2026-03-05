import Toybox.Lang;

class StopPointSearchLoadingView extends BaseLoadingView {
    private var _query as String;
    private var _storageKey as StorageKey;
    private var _modes as Array<String>?;
    private var _lines as Array<String>?; 
    
    function initialize(
        query as String,
        storageKey as StorageKey,
        modes as Array<String>?,
        lines as Array<String>?    
    ) {
        BaseLoadingView.initialize();
        _query = query;
        _storageKey = storageKey;
        _modes = modes;
        _lines = lines;
    }

    function onShow() as Void {
        System.println("StopPointSearchLoadingView onShow called");
        getTflApi().searchStopPoints(_query, _modes, _lines, method(:onReceive));
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
        //System.println("array: " + array.toString());
        var stopPoints = [];
        for (var i = 0; i < array.size(); i++) {
             stopPoints.add(StopPoint.fromDict(array[i]));
        }
        var delegate = new StopPointSearchResultsDelegate(stopPoints, _storageKey, false, _modes);
        WatchUi.switchToView(new BaseStopPointListView("Search Results", stopPoints), delegate, SLIDE_IMMEDIATE);
        
    }
}