import Toybox.WatchUi;
import Toybox.Lang;

class MainMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Lang.Symbol) {
        if (item == :line_status) {
            WatchUi.pushView(new StatusListLoadingView(), null, WatchUi.SLIDE_LEFT);
        } else if (item == :stop_arrivals) {
            WatchUi.pushView(new StopPointArrivalsLoadingView("490001069C", "Clapham Junction"), null, WatchUi.SLIDE_LEFT);
        }
    }
}