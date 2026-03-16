import Toybox.WatchUi;
import Toybox.Lang;


class StopPointsConfigView extends DynamicMenuView {

    private var _title as String;
    private var _storageKey as StorageKey;
    private var _modes as Array<String>?;
    private var _lines as Array<String>?;


    function initialize(
        stopPoints as Array,
        title as String,
        storageKey as StorageKey,
        modes as Array<String>?,
        lines as Array<String>?
    ) {
        DynamicMenuView.initialize(title, stopPoints, storageKey);
        _title = title;
        _storageKey = storageKey;
        _modes = modes;
        _lines = lines;
    }

    function getMenuItem(idx as Number) as WatchUi.MenuItem {
        var stopPointDict = _selection[idx] as Dictionary<String>;
        return new MenuItem(
            stopPointDict["name"],
            stopPointDict["indicator"],
            stopPointDict, // Dict itself is the id.
            null
        );
    }

    function reloadWithSelection(newSelection as Array) {
        var view = new StopPointsConfigView(newSelection, _title, _storageKey, _modes, _lines);
        var delegate = new StopPointsConfigDelegate(newSelection, _storageKey, _modes, _lines);
        WatchUi.switchToView(view, delegate, SLIDE_LEFT);
    }

}

class StopPointsConfigDelegate extends DynamicMenuDelegate {
    private var _storageKey as StorageKey;
    private var _modes as Array<String>?;
    private var _lines as Array<String>?;


    function initialize(
        selection as Array,
        storageKey as StorageKey,
        modes as Array<String>?,
        lines as Array<String>?
    ) {
        DynamicMenuDelegate.initialize(selection, storageKey);
        _storageKey = storageKey;
        _modes = modes;
        _lines = lines;
    }

    function goToAddItemView(selection as Array) as Void {
        var view = new WatchUi.TextPicker("Waterl");
        var delegate = new StopPointSearchDelegate(_storageKey, _modes, _lines);
        WatchUi.pushView(view, delegate, SLIDE_IMMEDIATE);
    }

    function getMoveOrDeleteTitleById(id) as String {
        return (id as Dictionary)["name"];
    }

}