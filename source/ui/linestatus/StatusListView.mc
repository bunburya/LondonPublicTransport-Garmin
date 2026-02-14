import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

function statusDescription(lineStatusData as LineStatusData) as String {
    var mostSevere = lineStatusData.mostSevereStatus();
    if (mostSevere == null) {
        return "No status available";
    }
    if (lineStatusData.statuses.size() == 1) {
        return mostSevere.description;
    } 
    return mostSevere.description + " (+" + (lineStatusData.statuses.size()-1) + ")";
}

class StatusListView extends WatchUi.Menu2 {

    private var _data as Array<LineStatusData>;

    function initialize(data as Array<LineStatusData>) {
        Menu2.initialize({ :title => "Line Status"});
        _data = data;
        for (var i = 0; i < _data.size(); i++) {
            var item = data[i];
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

class StatusListDelegate extends WatchUi.Menu2InputDelegate {

    private var _data as Array<LineStatusData>;

    function initialize(data) {
        Menu2InputDelegate.initialize();
        _data = data;
    }

    function onSelect(item) {
        var id = item.getId() as Number;
        var factory = new DetailedStatusViewFactory(_data[id]);
        var viewLoop = new WatchUi.ViewLoop(factory, {:wrap => true});
        var viewLoopDelegate = new WatchUi.ViewLoopDelegate(viewLoop);
        WatchUi.pushView(viewLoop, viewLoopDelegate, WatchUi.SLIDE_LEFT);
    }

    function onTitle() as Void {
        var selectedIds = Application.Storage.getValue("lineStatusSelection");
        if (selectedIds == null) {
            selectedIds = [];
        }
        var view = new LineStatusConfigView(selectedIds);
        var delegate = new LineStatusConfigDelegate(selectedIds);
        pushView(view, delegate, SLIDE_LEFT);
    }
}