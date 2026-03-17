import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

// Show a list of stops.
class StopPointListOrConfigView extends BaseStopPointListView {

    private var _storageKey as StorageKey;
    private var _configTitle as String;
    private var _modes as Array<String>?;
    private var _lines as Array<String>?;


    function initialize(stopPoints as Array<StopPoint>, configTitle, storageKey, modes, lines) {
        BaseStopPointListView.initialize("Choose Stop", stopPoints);
        _configTitle = configTitle;
        _storageKey = storageKey;
        _modes = modes;
        _lines = lines;

    }

    function onEmpty() as Void {
        WatchUi.switchToView(
            new StopPointsConfigView([], _configTitle, _storageKey, _modes, _lines),
            new StopPointsConfigDelegate([], _storageKey, _modes, _lines),
            SLIDE_IMMEDIATE
        );

    }
}

class StopPointListOrConfigDelegate extends WatchUi.Menu2InputDelegate {

    var _stopPoints as Array<StopPoint>;
    var _storageKey as StorageKey;
    var _configTitle as String or ResourceId;
    var _modes as Array<String>?;
    var _lines as Array<String>?;

    function initialize(stopPoints as Array<StopPoint>, configTitle, storageKey, modes, lines) {
        Menu2InputDelegate.initialize();
        _stopPoints = stopPoints;
        _configTitle = configTitle;
        _storageKey = storageKey;
        _modes = modes;
        _lines = lines;
    }

    function onTitle() as Void {
        var stopPointDicts = Application.Storage.getValue(_storageKey);
        if (stopPointDicts == null) {
            stopPointDicts = [];
        }
        var view = new StopPointsConfigView(stopPointDicts, _configTitle, _storageKey, _modes, _lines);
        var delegate = new StopPointsConfigDelegate(stopPointDicts, _storageKey, _modes, _lines);
        WatchUi.switchToView(view, delegate, SLIDE_IMMEDIATE);
    }
}