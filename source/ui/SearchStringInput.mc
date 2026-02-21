import Toybox.Lang;
import Toybox.WatchUi;

class SearchStringInputDelegate extends WatchUi.TextPickerDelegate {

    function initialize() {
        WatchUi.TextPickerDelegate.initialize();
    }

    function onTextEntered(text as String, changed as Boolean) as Boolean {
        if (text.length() == 0) {
            return false;
        }
        System.println("Text: " + text);
        System.println("Changed: " + changed);
        return true;
    }

}