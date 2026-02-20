import Toybox.WatchUi;
import Toybox.Lang;


class LineStatusConfigView extends DynamicMenuView {
    function initialize(selectedIds as Array<String>) {
        DynamicMenuView.initialize("Configure Line Statuses", selectedIds, "lineStatusSelection");
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
        var view = new LineStatusConfigView(newSelection);
        var delegate = new LineStatusConfigDelegate(newSelection);
        WatchUi.switchToView(view, delegate, SLIDE_LEFT);

    }

}

class LineStatusConfigDelegate extends DynamicMenuDelegate {
    function initialize(selectedIds as Array<String>) {
        DynamicMenuDelegate.initialize(selectedIds, "lineStatusSelection");
    }

    function switchToAddItemView(selectedIds as Array<String>) as Void {
        var view = new AddLineStatusView(selectedIds);
        var delegate = new AddLineStatusDelegate(selectedIds);
        WatchUi.pushView(view, delegate, SLIDE_LEFT);
    }
    
    function getMoveOrDeleteTitleById(id as String) as String {
        return getLineById(id).name;
    }

}