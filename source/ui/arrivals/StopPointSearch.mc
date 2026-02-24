import Toybox.WatchUi;
import Toybox.Lang;

class StopPointSearchDelegate extends WatchUi.TextPickerDelegate {
    
    function initialize() {
        WatchUi.TextPickerDelegate.initialize();
    }

    function onTextEntered(text as String, changed as Boolean) as Boolean {
        if (text.length() == 0) {
            return false;
        }
        System.println("Text: " + text);
        System.println("Changed: " + changed);
        var view = new StopPointSearchLoadingView(text);
        WatchUi.switchToView(view, null, SLIDE_IMMEDIATE);
        // It seems that when we return from this function, Garmin pops
        // the top view (regrdless of whether we return true or false).
        // So we push this "dummy" view to protect our actual Loading view.
        WatchUi.pushView(new View(), null, SLIDE_IMMEDIATE);
        return true;
    }
}