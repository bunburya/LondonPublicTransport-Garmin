import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.System;

class MainMenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) {
        var id = item.getId();
        System.println(id);
        if (id == :line_status) {
            WatchUi.pushView(new StatusListLoadingView(), null, WatchUi.SLIDE_LEFT);
        } else if (id == :stop_arrivals) {
            var stopPoints = [
                new StopPoint("490001069C", "Clapham Junction"),
                new StopPoint("490006514S", "Old Church Street"),
                new StopPoint("9400ZZLUCPS", "Clapham South")
            ];
            var delegate = new StopPointListDelegate(stopPoints);
            WatchUi.pushView(new StopPointListView(stopPoints), delegate, WatchUi.SLIDE_LEFT);
        }
    }
}