import Toybox.WatchUi;
import Toybox.Lang;

class DeparturesListView extends WatchUi.Menu2 {

    function initialize(stopName as String, departures as Array<Departure>) {
        Menu2.initialize({ :title => stopName});
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

class DeparturesListDelegate extends WatchUi.Menu2InputDelegate {
    private var _departures as Array<Departure>;

    function initialize(departures as Array<Departure>) {
        WatchUi.Menu2InputDelegate.initialize();
        _departures = departures;
    }

    function onSelect(item) {
        var dep = _departures[item.getId() as Number];
        var header;
        if (dep.status == "OnTime") {
            header = "On Time";
        } else {
            header = dep.status;
        }
        var headerColor;
        if (dep.isOnTime() || dep.isAlmostOnTime()) {
            headerColor = TFL_GREEN;
        } else if (dep.isCancelled()) {
            headerColor = TFL_RED;
        } else {
            headerColor = TFL_YELLOW;
        }
        var body = "Destination: " + dep.destinationName + "\n";
        body += "Scheduled: " + formatTime(dep.scheduled, false) + "\n";
        if (dep.estimated != null) {
            body += "Estimated: " + formatTime(dep.estimated, false) + "\n";
        }
        body += dep.status + "\n";
        if (dep.cause != null) {
            body += dep.cause + "\n";
        }
        var view = new InfoView(header, headerColor, body);
        var delegate = new InfoDelegate(view);
        WatchUi.pushView(view, delegate, SLIDE_LEFT);
        
    }
}