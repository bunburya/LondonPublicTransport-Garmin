import Toybox.WatchUi;
import Toybox.Lang;


class LineStatusConfigView extends DynamicMenuView {
    function initialize(selectedIds as Array<String>) {
        DynamicMenuView.initialize(Rez.Strings.ConfigLineStatus, selectedIds, LINE_STATUS_LINES);
    }

    function getMenuItem(idx as Number) as WatchUi.MenuItem {
        var lineId = _selection[idx];
        var lwm = getLwmById(lineId) as LineWithMode;
        return new MenuItem(
            lwm.line.name,
            lwm.modeName,
            lwm.line.id,
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
    
    function getMoveOrDeleteTitleById(id as String) as String {
        return getLwmById(id).line.name;
    }

}
