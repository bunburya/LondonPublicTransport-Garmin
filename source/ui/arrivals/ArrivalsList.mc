import Toybox.WatchUi;
import Toybox.Lang;

// List the predicted arrivals for a single stop.
class ArrivalsListView extends WatchUi.Menu2 {

    function initialize(data as StopPointArrivals) {
        Menu2.initialize({ :title => data.stopPoint.name, :footer => "Updated " + clockTimeToString()});
        if (data.arrivals.size() == 0) {
            Menu2.addItem(new MenuItem(WatchUi.loadResource(Rez.Strings.NoArrivals), null, null, {}));
        } else {
            for (var i = 0; i < data.arrivals.size(); i++) {
                var arrival = data.arrivals[i];
                Menu2.addItem(
                    new MenuItem(
                        arrival.lineName + " in " + secsToStr(arrival.timeToStation),
                        arrival.destinationName,
                        i,
                        {}
                    )
                );
            }
        }
    }
}

class ArrivalsListDelegate extends WatchUi.Menu2InputDelegate {
    private var _stopPoint as StopPoint;
    
    function initialize(stopPoint as StopPoint) {
        WatchUi.Menu2InputDelegate.initialize();
        _stopPoint = stopPoint;
    }

    function onFooter() as Void {
        WatchUi.switchToView(new ArrivalsListLoadingView(_stopPoint), null, SLIDE_IMMEDIATE);
    }
}
