import Toybox.Lang;

class StopPointSearchLoadingView extends BaseLoadingView {
    private var _query as String;
    private var _modes as Array<String>; 
    
    function initialize(query as String, modes as Array<String>) {
        BaseLoadingView.initialize();
        _query = query;
        _modes = modes;
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
        //System.println("array: " + array.toString());
        var stopPoints = [];
        for (var i = 0; i < array.size(); i++) {
            var sp = StopPoint.fromDict(array[i]);
            if (sp.hasAnyMode(_modes)) {
                stopPoints.add(sp);
            }
        }
        var delegate = new StopPointSearchResultsDelegate(stopPoints, false, _modes);
        WatchUi.switchToView(new BaseStopPointListView("Search Results", stopPoints), delegate, SLIDE_IMMEDIATE);
        
    }
}