import Toybox.WatchUi;
import Toybox.Application;
import Toybox.Lang;

enum Action {
    MOVE_UP,
    MOVE_DOWN,
    DELETE
}

const ADD_NEW = 1;

class MoveOrDeleteMenuDelegate extends WatchUi.Menu2InputDelegate {
    private var _id as String;
    private var _selection as Array<String>;
    private var _storageKey as String;

    function initialize(id as String, selection as Array<String>, storageKey as String) {
        WatchUi.Menu2InputDelegate.initialize();
        _id = id;
        _selection = selection;
        _storageKey = storageKey;
    }

    function onSelect(item as MenuItem) as Void {
        var itemId = item.getId() as Action;
        var idx = _selection.indexOf(_id);
        if (itemId == MOVE_UP) {
            if (idx <= 0) {
                // Move item to end of list
                _selection = _selection.slice(1, null);
                _selection.add(_id);
            } else {
                // Switch item with previous item
                var prevIdx = idx - 1;
                var prev = _selection[prevIdx];
                _selection[prevIdx] = _id;
                _selection[idx] = prev;
            }
        } else if (itemId == MOVE_DOWN) {
            if (idx >= _selection.size() - 1) {
                // Move item to start of list
                var toAdd = _selection.slice(0, -1);
                _selection = [_id];
                _selection.addAll(toAdd);
            } else {
                // Switch item with next item
                var nextIdx = idx + 1;
                var next = _selection[nextIdx];
                _selection[nextIdx] = _id;
                _selection[idx] = next;
            }
        } else if (itemId == DELETE) {
            _selection.remove(_id);
        }
        Application.Storage.setValue(_storageKey, _selection);
        WatchUi.popView(SLIDE_LEFT);
    }
}

class DynamicMenuView extends WatchUi.Menu2 {

    private var _selectedIds as Array<String>;
    private var _storageKey as String;

    function initialize(title as String, selectedIds as Array<String>, storageKey as String) {
        WatchUi.Menu2.initialize({:title => title});
        _selectedIds = selectedIds;
        _storageKey = storageKey;

        for (var i = 0; i < _selectedIds.size(); i++) {
            var menuItem = getMenuItemById(_selectedIds[i]);
            addItem(menuItem);
        }
        addItem(new MenuItem("Add", null, ADD_NEW, null));
    }

    function onShow() {
        System.println("onShow called");
        var sel = Application.Storage.getValue(_storageKey);
        System.println("sel: " + sel.toString());
        System.println("selectedIds: " + _selectedIds.toString());
        if (sel != null && !arrayEq(sel, _selectedIds)) {
            // If the selection has changed, reload the menu
            System.println("calling reloadWithSelection");
            reloadWithSelection(sel);
        }
    }

    // Function to generate a `MenuItem` from an id (which should be present in
    // the stored selection). This should be overridden by subclasses.
    function getMenuItemById(id as String) as WatchUi.MenuItem {
        throw new NotImplementedException();
    }

    // Function to switch to a new instance of "self" but showing an updated list
    // of selected ids. This should be overridden by subclasses.
    function reloadWithSelection(newSelection as Array<String>) {
        throw new NotImplementedException();
    }
}

class DynamicMenuDelegate extends WatchUi.Menu2InputDelegate {

    var _selectedIds as Array<String>;
    private var _storageKey as String;

    function initialize(selected as Array<String>, storageKey as String) {
        WatchUi.Menu2InputDelegate.initialize();
        _selectedIds = selected;
        _storageKey = storageKey;
    }

    // Function to switch to a view to add a new item to the selection (ie,
    // when the user clicks the "Add" button). This should be overridden by
    // subclasses. It should construct the relevant view and delegate and call
    // `WatchUi.switchToView`.
    function switchToAddItemView(selectedIds as Array<String>) as Void {
        throw new NotImplementedException();
    }
    
    // Function to get the string to be used as the title of the sub-menu to
    // move or delete the item. This should be overridden by subclasses.
    function getMoveOrDeleteTitleById(id as String) as String {
        throw new NotImplementedException();
    }

    function onSelect(item as MenuItem) as Void {
        var id = item.getId() as String?;
        if (id == ADD_NEW) {
            switchToAddItemView(copyArray(_selectedIds));
        } else {
            var title = getMoveOrDeleteTitleById(id);
            var menu = new WatchUi.Menu2({:title => title});
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
            var delegate = new MoveOrDeleteMenuDelegate(id, copyArray(_selectedIds), _storageKey);
            WatchUi.pushView(menu, delegate, SLIDE_LEFT);
        }
    }

}