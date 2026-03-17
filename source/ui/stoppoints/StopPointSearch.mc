import Toybox.WatchUi;
import Toybox.Lang;

class StopPointSearchDelegate extends WatchUi.TextPickerDelegate {
    private var _storageKey as StorageKey;
    private var _modes as Array<String>?;
    private var _lines as Array<String>?;
    
    function initialize(storageKey as StorageKey, modes as Array<String>?, lines as Array<String>?) {
        WatchUi.TextPickerDelegate.initialize();
        _storageKey = storageKey;
        _modes = modes;
        _lines = lines;
    }

    function onTextEntered(text as String, changed as Boolean) as Boolean {
        if (text.length() == 0) {
            return false;
        }
        var view = new StopPointSearchLoadingView(text, _storageKey, _modes, _lines);
        WatchUi.switchToView(view, null, SLIDE_IMMEDIATE);
        // It seems that when we return from this function, Garmin pops
        // the top view (regrdless of whether we return true or false).
        // So we push this "dummy" view to protect our actual Loading view.
        WatchUi.pushView(new View(), null, SLIDE_IMMEDIATE);
        return true;
    }
}