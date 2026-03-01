import Toybox.WatchUi;
import Toybox.Lang;


class ArrivalsConfigView extends DynamicMenuView {

    function initialize(stopPoints as Array) {
        DynamicMenuView.initialize("Configure Arrivals", stopPoints, ARRIVALS_STOPPOINTS);
        System.println("ArrivalsConfigView initialized");
    }

    function getMenuItem(idx as Number) as WatchUi.MenuItem {
        var stopPointDict = _selection[idx] as Dictionary;
        return new MenuItem(
            stopPointDict["name"],
            stopPointDict["indicator"],
            stopPointDict, // Dict itself is the id.
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
        var delegate = new StopPointSearchDelegate(["bus", "tube", "river-bus", "tram"]);
        WatchUi.pushView(view, delegate, SLIDE_IMMEDIATE);
    }

    function getMoveOrDeleteTitleById(id) as String {
        System.println("Checking id " + id);
        return (id as Dictionary)["name"];

    }

}