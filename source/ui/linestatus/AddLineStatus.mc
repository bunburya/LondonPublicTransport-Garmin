import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Application;

// Get all supported lines other than the ones in the dictionary provided.
// Input is a dictionary mapping line ID to `Line` object. Output is an array
// of line IDs (so that order is preserved).
function getOtherLines(lines as Dictionary<String, LineWithMode>) as Array<String> {
    var others = [];
    for (var i = 0; i < SUPPORTED_LWMS.size(); i++) {
        var lwm = SUPPORTED_LWMS[i];
        if (lines[lwm.line.id] == null) {
            others.add(lwm.line.id);
        }
    }
    return others;
}

// Menu that allows user to add other lines to the line status feature.
class AddLineStatusView extends WatchUi.Menu2 {

    function initialize(selectedIds as Array<String>) {
        var selectedLines = lineIdsToLwms(selectedIds);
        var unselectedLineIds = getOtherLines(selectedLines);
        WatchUi.Menu2.initialize({:title => "Add Line"});
        for (var i = 0; i < unselectedLineIds.size(); i++) {
            var id = unselectedLineIds[i];
            var lwm = getLwmById(id) as LineWithMode;
            addItem(new MenuItem(
                lwm.line.name,
                lwm.modeName,
                lwm.line.id,
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
        _selectedIds.add(item.getId() as String);
        Application.Storage.setValue(LINE_STATUS_LINES, _selectedIds);
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

}