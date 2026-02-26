import Toybox.WatchUi;
import Toybox.Lang;


class LineStatusConfigView extends DynamicMenuView {
    function initialize(selectedIds as Array<String>) {
        DynamicMenuView.initialize("Configure Line Statuses", selectedIds, LINE_STATUS_LINES);
    }

    function getMenuItem(id) as WatchUi.MenuItem {
        var line = getLineById(id) as Line;
        return new MenuItem(
            line.name,
            line.modeName,
            line.id,
            null
        );
    }

    function reloadWithSelection(newSelection as Array<String>) {
        var view = new LineStatusConfigView(newSelection);
        var delegate = new LineStatusConfigDelegate(newSelection);
        WatchUi.switchToView(view, delegate, SLIDE_LEFT);

    }

}

class LineStatusConfigDelegate extends DynamicMenuDelegate {
    function initialize(selectedIds as Array<String>) {
        DynamicMenuDelegate.initialize(selectedIds, LINE_STATUS_LINES);
    }

    function goToAddItemView(selectedIds as Array) as Void {
        var view = new AddLineStatusView(selectedIds);
        var delegate = new AddLineStatusDelegate(selectedIds);
        WatchUi.pushView(view, delegate, SLIDE_LEFT);
    }
    
    function getMoveOrDeleteTitle(id as String) as String {
        return getLineById(id).name;
    }

}