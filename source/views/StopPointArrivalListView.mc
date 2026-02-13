import Toybox.WatchUi;
import Toybox.Lang;

// List the predicted arrivals for a single stop.
class StopPointArrivalListView extends WatchUi.Menu2 {

    function initialize(data as StopPointArrivals) {
        Menu2.initialize({ :title => data.stopPoint.name});
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
