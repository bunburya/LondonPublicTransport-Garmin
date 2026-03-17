import Toybox.WatchUi;
import Toybox.Application;
import Toybox.Lang;

enum Action {
    MOVE_UP,
    MOVE_DOWN,
    DELETE
}

const ADD_NEW = -1;

class MoveOrDeleteMenuDelegate extends WatchUi.Menu2InputDelegate {
    private var _referenceItem; // The item we are trying to move
    private var _selection as Array; // The currently configured items
    private var _storageKey as StorageKey;

    function initialize(item, selection as Array, storageKey as StorageKey) {
        WatchUi.Menu2InputDelegate.initialize();
        _referenceItem = item;
        _selection = selection;
        _storageKey = storageKey;
    }

    function onSelect(item as MenuItem) as Void {
        var itemId = item.getId() as Action;
        var idx = _selection.indexOf(_referenceItem);
        if (itemId == MOVE_UP) {
            if (_selection.size() <= 1) {
                return;
            } else if (idx <= 0) {
                // Move item to end of list
                _selection = _selection.slice(1, null);
                _selection.add(_referenceItem);
            } else {
                // Switch item with previous item
                var prevIdx = idx - 1;
                var prev = _selection[prevIdx];
                _selection[prevIdx] = _referenceItem;
                _selection[idx] = prev;
            }
        } else if (itemId == MOVE_DOWN) {
            if (_selection.size() <= 1) {
                return;
            } else if (idx >= _selection.size() - 1) {
                // Move item to start of list
                var toAdd = _selection.slice(0, -1);
                _selection = [_referenceItem];
                _selection.addAll(toAdd);
            } else {
                // Switch item with next item
                var nextIdx = idx + 1;
                var next = _selection[nextIdx];
                _selection[nextIdx] = _referenceItem;
                _selection[idx] = next;
            }
        } else if (itemId == DELETE) {
            _selection.remove(_referenceItem);
        }
        Application.Storage.setValue(_storageKey, _selection);
        WatchUi.popView(SLIDE_LEFT);
    }
}

class DynamicMenuView extends WatchUi.Menu2 {

    var _selection as Array;
    private var _storageKey as StorageKey;

    function initialize(title as String or ResourceId, selection as Array, storageKey as StorageKey) {
        WatchUi.Menu2.initialize({:title => title});
        _selection = selection;
        _storageKey = storageKey;

        for (var i = 0; i < _selection.size(); i++) {
            var menuItem = getMenuItem(i);
            addItem(menuItem);
        }
        addItem(new MenuItem(Rez.Strings.Add, null, ADD_NEW, null));
    }

    function onShow() {
        //System.println("DynamicMenuView onShow called");
        //System.println("storageKey: " + _storageKey.toString());
        var sel = Application.Storage.getValue(_storageKey);
        //System.println("new selection: " + sel);
        //System.println("previous selection: " + _selection.toString());
        if (sel != null && !eq(sel, _selection)) {
            // If the selection has changed, reload the menu
            //System.println("calling reloadWithSelection");
            reloadWithSelection(sel);
        }
    }

    // Function to generate a `MenuItem` from the index of the relevant item in `_selection`.
    // This should be overridden by subclasses.
    function getMenuItem(idx as Number) as WatchUi.MenuItem {
        throw new NotImplementedException();
    }

    // Function to switch to a new instance of "self" but showing an updated list
    // of selected ids. This should be overridden by subclasses.
    function reloadWithSelection(newSelection as Array<String>) {
        throw new NotImplementedException();
    }
}

class DynamicMenuDelegate extends WatchUi.Menu2InputDelegate {

    var _selection as Array;
    private var _storageKey as StorageKey;

    function initialize(selection as Array, storageKey as StorageKey) {
        WatchUi.Menu2InputDelegate.initialize();
        _selection = selection;
        _storageKey = storageKey;
    }

    // Function to switch to a view (or push a view) to add a new item to the
    // selection (ie, when the user clicks the "Add" button). This should be
    // overridden by subclasses. It should construct the relevant view and
    // delegate and call `WatchUi.switchToView` (or `WatchUi.pushView` if apt).
    function goToAddItemView(selection as Array) as Void {
        throw new NotImplementedException();
    }
    
    // Function to get the string to be used as the title of the sub-menu to
    // move or delete the item. This should be overridden by subclasses.
    function getMoveOrDeleteTitleById(id) as String {
        throw new NotImplementedException();
    }

    function onSelect(item as MenuItem) as Void {
        var id = item.getId() as String?;
        if (id == ADD_NEW) {
            goToAddItemView(copyArray(_selection));
        } else {
            var title = getMoveOrDeleteTitleById(id);
            var menu = new WatchUi.Menu2({:title => title});
            menu.addItem(new MenuItem(
                Rez.Strings.MoveUp,
                null,
                MOVE_UP,
                null
            ));
            menu.addItem(new MenuItem(
                Rez.Strings.MoveDown,
                null,
                MOVE_DOWN,
                null
            ));
            menu.addItem(new MenuItem(
                Rez.Strings.Delete,
                null,
                DELETE,
                null
            ));
            var delegate = new MoveOrDeleteMenuDelegate(id, copyArray(_selection), _storageKey);
            WatchUi.pushView(menu, delegate, SLIDE_LEFT);
        }
    }

}