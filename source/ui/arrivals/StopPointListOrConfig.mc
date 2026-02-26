import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

// Show a list of stops.
class StopPointListOrConfigView extends BaseStopPointListView {

    function initialize(stopPoints as Array<StopPoint>) {
        BaseStopPointListView.initialize("Choose Stop", stopPoints);
    }

    function onEmpty() as Void {
        WatchUi.switchToView(
            new ArrivalsConfigView([]),
            new ArrivalsConfigDelegate([]),
            SLIDE_IMMEDIATE
        );

    }
}

class StopPointListOrConfigDelegate extends WatchUi.Menu2InputDelegate {

    private var _stopPoints as Array<StopPoint>;
    private var _storageKey as StorageKey;

    function initialize(stopPoints, storageKey) {
        Menu2InputDelegate.initialize();
        _stopPoints = stopPoints;
        _storageKey = storageKey;
    }

    function onSelect(item) {
        var id = item.getId() as Number;
        var view = new StopPointArrivalsLoadingView(_stopPoints[id]);
        WatchUi.pushView(view, null, WatchUi.SLIDE_LEFT);
    }

    function onTitle() as Void {
        var stopPointDicts = Application.Storage.getValue(_storageKey);
        if (stopPointDicts == null) {
            stopPointDicts = [];
        }
        var view = new ArrivalsConfigView(stopPointDicts);
        var delegate = new ArrivalsConfigDelegate(stopPointDicts);
        WatchUi.switchToView(view, delegate, SLIDE_IMMEDIATE);
    }
}