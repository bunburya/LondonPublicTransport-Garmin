import Toybox.WatchUi;
import Toybox.Lang;


class ArrivalsConfigView extends DynamicMenuView {

    function initialize(stopPoints as Array) {
        DynamicMenuView.initialize("Configure Arrivals", stopPoints, ARRIVALS_STOPPOINTS);
        System.println("ArrivalsConfigView initialized");
    }

    function getMenuItem(key) as WatchUi.MenuItem {
        var stopPoint = StopPoint.fromDict(key);
        return new MenuItem(
            stopPoint.name,
            stopPoint.indicator,
            stopPoint.id,
            null
        );
    }

    function reloadWithSelection(newSelection as Array<String>) {
        var view = new ArrivalsConfigView(newSelection);
        var delegate = new ArrivalsConfigDelegate(newSelection);
        WatchUi.switchToView(view, delegate, SLIDE_LEFT);

    }

}

class ArrivalsConfigDelegate extends DynamicMenuDelegate {
    function initialize(selection as Array) {
        DynamicMenuDelegate.initialize(selection, ARRIVALS_STOPPOINTS);
    }

    function goToAddItemView(selection as Array) as Void {
        var view = new WatchUi.TextPicker("Tooting");
        var delegate = new StopPointSearchDelegate();
        WatchUi.pushView(view, delegate, SLIDE_IMMEDIATE);
    }
    
    function getMoveOrDeleteLabelById(id as String) as String {
        return getStopPointById(id, ARRIVALS_STOPPOINTS).name;
    }

}