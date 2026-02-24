import Toybox.Lang;
import Toybox.WatchUi;

class StopPointSearchResultsDelegate extends WatchUi.Menu2InputDelegate {
    private var _stopPoints as Array<StopPoint>;

    function initialize(stopPoints as Array<StopPoint>) {
        WatchUi.Menu2InputDelegate.initialize();
        _stopPoints = stopPoints;
    }

    function onSelect(item as MenuItem) as Void {
        var sp = _stopPoints[item.getId() as Number];
        // TODO: search for more detail and display.
    }
}