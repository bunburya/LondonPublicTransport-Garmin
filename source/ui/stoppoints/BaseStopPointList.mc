import Toybox.Lang;
import Toybox.WatchUi;

// Show a list of stops.
class BaseStopPointListView extends WatchUi.Menu2 {
    var _stopPoints as Array<StopPoint>;

    function initialize(title as String or ResourceId, stopPoints as Array<StopPoint>) {
        _stopPoints = stopPoints;
        Menu2.initialize({ :title => title });
        for (var i = 0; i < stopPoints.size(); i++) {
            var item = stopPoints[i];
            var subLabel = item.indicator;
            if (subLabel == null && item.towards != null) {
                subLabel = "towards " + item.towards;
            }
            Menu2.addItem(
                new MenuItem(
                    item.name,
                    subLabel,
                    i,
                    {}
                )
            );
        }
    }

    // Called from `onShow` when the list of StopPoints to display is empty. 
    function onEmpty() as Void {}

    function onShow() as Void {
        if (_stopPoints.size() == 0) {
            onEmpty();
        }
    }
}