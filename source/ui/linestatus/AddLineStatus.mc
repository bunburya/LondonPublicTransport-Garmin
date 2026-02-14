import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Application;

// Get all supported lines other than the ones in the dictionary provided.
// Input is a dictionary mapping line ID to `Line` object. Output is an array
// of line IDs (so that order is preserved).
function getOtherLines(lines as Dictionary<String, Line>) as Array<String> {
    var others = [];
    for (var i = 0; i < SUPPORTED_LINES_ARRAY.size(); i++) {
        var line = SUPPORTED_LINES_ARRAY[i];
        if (lines[line.id] == null) {
            others.add(line.id);
        }
    }
    return others;
}

// Menu that allows user to add other lines to the line status feature.
class AddLineStatusView extends WatchUi.Menu2 {

    function initialize(selectedIds as Array<String>) {
        System.println("Selected: " + selectedIds.toString());
        var selectedLines = lineIdsToLines(selectedIds);
        var unselectedLineIds = getOtherLines(selectedLines);
        WatchUi.Menu2.initialize({:title => "Add Line"});
        for (var i = 0; i < unselectedLineIds.size(); i++) {
            var id = unselectedLineIds[i];
            var line = getLineById(id) as Line;
            addItem(new MenuItem(
                line.name,
                line.modeName,
                line.id,
                {}
            ));
        }

        
    }
}

class AddLineStatusDelegate extends WatchUi.Menu2InputDelegate {
    
    private var _selectedIds as Array<String>;

    function initialize(selectedIds as Array<String>) {
        WatchUi.Menu2InputDelegate.initialize();
        _selectedIds = selectedIds;
    }

    function onSelect(item as MenuItem) as Void {
        System.println("item:");
        System.println(item.getId());
        _selectedIds.add(item.getId() as String);
        Application.Storage.setValue("lineStatusSelection", _selectedIds);
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

}