import Toybox.WatchUi;
import Toybox.Lang;


class ArrivalsConfigView extends DynamicMenuView {

    function initialize(stopPointIds as Array<String>) {
        DynamicMenuView.initialize("Configure Arrivals", stopPointIds, ARRIVALS_STOPPOINTS);
        System.println("ArrivalsConfigView initialized");
    }

    function getMenuItemById(id as String) as WatchUi.MenuItem {
        var stopPoint = getStopPointById(id, ARRIVALS_STOPPOINTS) as StopPoint;
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
    function initialize(selectedIds as Array<String>) {
        DynamicMenuDelegate.initialize(selectedIds, ARRIVALS_STOPPOINTS);
    }

    function goToAddItemView(selectedIds as Array<String>) as Void {
        var view = new WatchUi.TextPicker("test");
        var delegate = new SearchStringInputDelegate();
        WatchUi.pushView(view, delegate, SLIDE_IMMEDIATE);
    }
    
    function getMoveOrDeleteLabelById(id as String) as String {
        return getStopPointById(id, ARRIVALS_STOPPOINTS).name;
    }

}