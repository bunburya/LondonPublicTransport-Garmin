import Toybox.WatchUi;
import Toybox.Lang;


class ArrivalsConfigView extends DynamicMenuView {
    function initialize(selectedIds as Array<String>) {
        DynamicMenuView.initialize("Configure Arrivals", selectedIds, "arrivalsStopPointSelection");
    }

    function getMenuItemById(id as String) as WatchUi.MenuItem {
        var line = getLineById(id) as Line;
        return new MenuItem(
            line.name,
            line.modeName,
            line.id,
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
        DynamicMenuDelegate.initialize(selectedIds, "arrivalsStopPointSelection");
    }

    function switchToAddItemView(selectedIds as Array<String>) as Void {
        // TODO
    }
    
    function getMoveOrDeleteLabelById(id as String) as String {
        return getStopPointById(id, "arrivalsStopPointSelection").name;
    }

}