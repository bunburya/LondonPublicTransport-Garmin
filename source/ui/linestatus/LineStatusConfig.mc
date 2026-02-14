import Toybox.WatchUi;
import Toybox.Application;
import Toybox.Lang;

enum Action {
    MOVE_UP,
    MOVE_DOWN,
    DELETE
}

const ADD_NEW = 1;

class MoveOrDeleteLineDelegate extends WatchUi.Menu2InputDelegate {
    private var _lineId as String;
    private var _selectedLineIds as Array<String>;

    function initialize(lineId as String, selectedLineIds as Array<String>) {
        WatchUi.Menu2InputDelegate.initialize();
        _lineId = lineId;
        _selectedLineIds = selectedLineIds;
    }

    function onSelect(item as MenuItem) as Void {
        var id = item.getId() as Action;
        var idx = _selectedLineIds.indexOf(_lineId);
        if (id == MOVE_UP) {
            if (idx <= 0) {
                // Move item to end of list
                _selectedLineIds = _selectedLineIds.slice(1, null);
                _selectedLineIds.add(_lineId);
            } else {
                // Switch item with previous item
                var prevIdx = idx - 1;
                var prev = _selectedLineIds[prevIdx];
                _selectedLineIds[prevIdx] = _lineId;
                _selectedLineIds[idx] = prev;
            }
        } else if (id == MOVE_DOWN) {
            if (idx >= _selectedLineIds.size() - 1) {
                // Move item to start of list
                var toAdd = _selectedLineIds.slice(0, -1);
                _selectedLineIds = [_lineId];
                _selectedLineIds.addAll(toAdd);
            } else {
                // Switch item with next item
                var nextIdx = idx + 1;
                var next = _selectedLineIds[nextIdx];
                _selectedLineIds[nextIdx] = _lineId;
                _selectedLineIds[idx] = next;
            }
        } else if (id == DELETE) {
            _selectedLineIds.remove(_lineId);
        }
        Application.Storage.setValue("lineStatusSelection", _selectedLineIds);
        WatchUi.popView(SLIDE_LEFT);
    }
}

class LineStatusConfigView extends WatchUi.Menu2 {

    private var _selectedIds as Array<String>;

    function initialize(selectedIds as Array<String>) {
        WatchUi.Menu2.initialize({:title => "Configure Line Status"});
        _selectedIds = selectedIds;
        var sel = Application.Storage.getValue("lineStatusSelection");
        if (sel == null) {
            _selectedIds = [];
        } else {
            _selectedIds = sel as Array<String>;
        }

        for (var i = 0; i < _selectedIds.size(); i++) {
            var line = getLineById(_selectedIds[i]) as Line;
            addItem(new MenuItem(
                line.name,
                line.modeName,
                line.id,
                null
            ));
        }
        addItem(new MenuItem("Add", null, ADD_NEW, null));
    }

    function onShow() {
        var sel = Application.Storage.getValue("lineStatusSelection");
        if (sel != null && !arrayEq(sel, _selectedIds)) {
            // If the selection has changed, reload the menu
            var view = new LineStatusConfigView(sel);
            var delegate = new LineStatusConfigDelegate(sel);
            WatchUi.switchToView(view, delegate, SLIDE_LEFT);
        }
    }
}

class LineStatusConfigDelegate extends WatchUi.Menu2InputDelegate {

    private var _selectedIds as Array<String>;

    function initialize(selected as Array<String>) {
        WatchUi.Menu2InputDelegate.initialize();
        _selectedIds = selected;
    }
    
    function onSelect(item as MenuItem) as Void {
        var id = item.getId() as String?;
        if (id == ADD_NEW) {
            var view = new AddLineStatusView(_selectedIds);
            var delegate = new AddLineStatusDelegate(_selectedIds);
            WatchUi.pushView(view, delegate, SLIDE_LEFT);
        } else {
            var lineName = getLineById(id).name;
            var menu = new WatchUi.Menu2({:title => lineName});
            menu.addItem(new MenuItem(
                "Move Up",
                null,
                MOVE_UP,
                null
            ));
            menu.addItem(new MenuItem(
                "Move Down",
                null,
                MOVE_DOWN,
                null
            ));
            menu.addItem(new MenuItem(
                "Delete",
                null,
                DELETE,
                null
            ));
            var delegate = new MoveOrDeleteLineDelegate(id, _selectedIds);
            WatchUi.pushView(menu, delegate, SLIDE_LEFT);
        }
    }

}