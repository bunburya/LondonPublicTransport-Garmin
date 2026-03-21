import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application;

class AddStopPointConfirmLoadingView extends BaseLoadingView {
    private var _storageKey as StorageKey;
    private var _stopPoint as StopPoint;
    // If _isLeaf is true, this stop point will be considered as a "leaf node",
    // and we will always just prompt to add it rather than displaying a
    // sub-menu of its children to add.
    private var _isLeaf as Boolean;
    private var _modes as Array<String>;
    
    function initialize(
        storageKey as StorageKey,
        stopPoint as StopPoint,
        isLeaf as Boolean,
        modes as Array<String>
    ) {
        BaseLoadingView.initialize();
        _storageKey = storageKey;
        _stopPoint = stopPoint;
        _isLeaf = isLeaf;
        _modes = modes;
    }

    function onShow() {
        getTflApi().getStopPoint(_stopPoint.id, method(:onReceive));
    }

    function onReceive(responseCode as Number, data as Dictionary) {
        if (!validateResponse(responseCode, data)) {
            return;
        }
        var stopPoint = StopPoint.fromDict(data);
        System.println("stopPoint lines: " + stopPoint.lines.toString());
        var children = data["children"] as Array<Dictionary>;
        if (children != null && children.size() == 1) {
            stopPoint = StopPoint.fromDict(children[0]);
            _isLeaf = true;
        }
        if ((!_isLeaf) && (children != null) && (children.size() != 0) && stopPoint.hasAnyMode(["bus"])) {
            // We have a "parent" StopPoint which is just a grouping of "child"
            // StopPoints, which are the ones we actually want. Show show a new
            // menu to display the children to the user and allow them to choose.
            // (This is only relevant for buses.)
            var stopPoints = filterStopPointsByModes(StopPoint.fromDictArray(children), _modes);
            var view = new BaseStopPointListView(Rez.Strings.ChooseStop, stopPoints);
            var delegate = new StopPointSearchResultsDelegate(stopPoints, _storageKey, true, _modes);
            WatchUi.switchToView(view, delegate, SLIDE_IMMEDIATE);
        } else {
            var view = new WatchUi.Confirmation(stopPoint.listDisplay());
            var delegate = new AddStopPointConfirmDelegate(_storageKey, stopPoint);
            WatchUi.switchToView(view, delegate, SLIDE_IMMEDIATE);
        }
    }


}

class AddStopPointConfirmDelegate extends WatchUi.ConfirmationDelegate {
    private var _storageKey as StorageKey;
    private var _stopPoint as StopPoint;

    function initialize(storageKey as StorageKey, stopPoint as StopPoint) {
        WatchUi.ConfirmationDelegate.initialize();
        _storageKey = storageKey;
        _stopPoint = stopPoint;
        System.println("AddStopPointConfirmDelegate initialised");
    }

    function onResponse(response as WatchUi.Confirm) as Boolean {
        if (response == WatchUi.CONFIRM_YES) {
            addStopPoint(_stopPoint, _storageKey);
            return true;
        }
        return false;
    }
}