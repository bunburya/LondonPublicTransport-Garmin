import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

// Show a list of stops.
class StopPointListView extends WatchUi.Menu2 {
    private var _stopPoints as Array<StopPoint>;

    function initialize(stopPoints as Array<StopPoint>) {
        _stopPoints = stopPoints;
        Menu2.initialize({ :title => "Choose Stop"});
        for (var i = 0; i < stopPoints.size(); i++) {
            var item = stopPoints[i];
            Menu2.addItem(
                new MenuItem(
                    item.name,
                    null,
                    i,
                    {}
                )
            );
        }
    }

    function onShow() as Void {
        if (_stopPoints.size() == 0) {
            WatchUi.switchToView(
                new ArrivalsConfigView([]),
                new ArrivalsConfigDelegate([]),
                SLIDE_IMMEDIATE
            );
        }
    }
}

class StopPointListDelegate extends WatchUi.Menu2InputDelegate {

    private var _stopPoints as Array<StopPoint>;

    function initialize(stopPoints) {
        Menu2InputDelegate.initialize();
        _stopPoints = stopPoints;
    }

    function onSelect(item) {
        var id = item.getId() as Number;
        var view = new StopPointArrivalsLoadingView(_stopPoints[id]);
        WatchUi.pushView(view, null, WatchUi.SLIDE_LEFT);
    }
}