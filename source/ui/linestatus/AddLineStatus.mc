import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Application;

// Get all supported lines other than the ones in the dictionary provided.
// Input and output are dictionaries mapping line ID to `Line` object.
function getOtherLines(lines as Dictionary<String, Line>) as Dictionary<String, Line> {
    var others = {};
    var allLineIds = SUPPORTED_LINES.keys() as Array<String>;
    for (var i = 0; i < allLineIds.size(); i++) {
        var lineId = allLineIds[i];
        if (lines[lineId] == null) {
            others[lineId] = SUPPORTED_LINES[lineId];
        }
    }
    return others;
}

// Menu that allows user to add other lines to the line status feature.
class AddLineStatusView extends WatchUi.Menu2 {

    function initialize(selectedIds as Array<String>) {
        System.println(selectedIds);
        var selectedLines = lineIdsToLines(selectedIds);
        var unselectedLines = getOtherLines(selectedLines);
        var unselectedIds = unselectedLines.keys();
        WatchUi.Menu2.initialize({:title => "Add Line"});
        for (var i = 0; i < unselectedIds.size(); i++) {
            var id = unselectedIds[i];
            var line = unselectedLines[id];
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