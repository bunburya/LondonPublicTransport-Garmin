import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

function statusDescription(lineStatusData as LineStatusData) as String {
    var mostSevere = lineStatusData.mostSevereStatus();
    if (mostSevere == null) {
        return "No Status Available";
    }
    if (lineStatusData.statuses.size() == 1) {
        return mostSevere.description;
    } 
    return mostSevere.description + " (+" + (lineStatusData.statuses.size()-1) + ")";
}

class StatusListView extends WatchUi.Menu2 {

    private var _data as Array<LineStatusData>;

    function initialize(lineStatuses as Array<LineStatusData>) {
        Menu2.initialize({ :title => "Line Status"});
        _data = lineStatuses;
        for (var i = 0; i < _data.size(); i++) {
            var item = lineStatuses[i];
            Menu2.addItem(
                new MenuItem(
                    item.name,
                    statusDescription(item),
                    i,
                    {}
                )
            );
        }
    }
}

