import Toybox.WatchUi;
import Toybox.Lang;

function statusStr(status as String) as String {
    if (eq(status, "OnTime")) {
        return WatchUi.loadResource(Rez.Strings.OnTime);
    } else if (eq(status, "Delayed")) {
        return WatchUi.loadResource(Rez.Strings.Delayed);
    } else if (eq(status, "Cancelled")) {
        return WatchUi.loadResource(Rez.Strings.Cancelled);
    } else {
        return status;
    }
}

function detailedInfo(dep as Departure, statusStr as String) as String {
    var s = WatchUi.loadResource(Rez.Strings.Destination) + ": " + dep.destinationName + "\n\n";
    s += WatchUi.loadResource(Rez.Strings.Scheduled) + ": " + formatTime(dep.scheduled, false) + "\n";
    if (dep.estimated != null) {
        s += WatchUi.loadResource(Rez.Strings.Estimated) + ": " + formatTime(dep.estimated, false) + "\n";
    }
    s += statusStr + "\n";
    if (dep.cause != null) {
        s += dep.cause + "\n";
    }
    return s;
}


class DeparturesListView extends WatchUi.Menu2 {

    function initialize(stopName as String or ResourceId, departures as Array<Departure>) {
        Menu2.initialize({
            :title => stopName,
            :footer => WatchUi.loadResource(Rez.Strings.Updated) + " " + clockTimeToString()
        });
        if (departures.size() == 0) {
            Menu2.addItem(new MenuItem(WatchUi.loadResource(Rez.Strings.NoDepartures), null, null, {}));
        } else {
            for (var i = 0; i < departures.size(); i++) {
                var departure = departures[i];
                Menu2.addItem(
                    new MenuItem(
                        departure.destinationName, 
                        departure.statusStr(),
                        i,
                        {}
                    )
                );
            }
        }
    }
}

class DeparturesListDelegate extends WatchUi.Menu2InputDelegate {
    private var _departures as Array<Departure>;
    private var _stopPoint as StopPoint;

    function initialize(departures as Array<Departure>, stopPoint as StopPoint) {
        WatchUi.Menu2InputDelegate.initialize();
        _departures = departures;
        _stopPoint = stopPoint;
    }

    function onSelect(item) {
        var id = item.getId() as Number?;
        if (id == null) {
            return;
        }
        var dep = _departures[id];
        var header = statusStr(dep.status);
        var headerColor;
        if (dep.isOnTime() || dep.isAlmostOnTime()) {
            headerColor = TFL_GREEN;
        } else if (dep.isCancelled()) {
            headerColor = TFL_RED;
        } else {
            headerColor = TFL_YELLOW;
        }
        var body = detailedInfo(dep, header);
        var view = new InfoView(header, headerColor, body);
        var delegate = new InfoDelegate(view);
        WatchUi.pushView(view, delegate, SLIDE_LEFT);
        
    }

    function onFooter() as Void {
        WatchUi.switchToView(new DeparturesListLoadingView(_stopPoint), null, SLIDE_IMMEDIATE);
    }
}