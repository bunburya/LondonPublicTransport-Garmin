import Toybox.WatchUi;
import Toybox.Application;
import Toybox.Lang;

class LineStatusSelectDelegate extends WatchUi.BehaviorDelegate {
    
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Lang.Boolean {
        var lineSel = Storage.getValue("lineStatusSelection");
        if (lineSel == null) {
            lineSel = [];
        }
        //var menu = new WatchUi.CheckboxMenu
        return true;
    }
}