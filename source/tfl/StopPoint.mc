import Toybox.Lang;
import Toybox.Time;

class Arrival {
    var platform as String;
    var direction as String;
    var lineId as String;
    var lineName as String;
    var modeName as String;
    var destinationId as String;
    var destinationName as String;
    var towards as String;
    var timeToStation as Number;
    var expectedArrival as Moment;


    function initialize(data as Dictionary) {
        platform = data["platformName"];
        direction = data["direction"];
        lineId = data["lineId"];
        lineName = data["lineName"];
        modeName = data["modeName"];
        destinationId = data["destinationNaptanId"];
        destinationName = data["destinationName"];
        towards = data["towards"];
        timeToStation = data["timeToStation"];
        expectedArrival = parseDateTime(data["expectedArrival"]);
    }
}

class StopPointArrivals {
    var stopPointId as String;
    var stationName as String;
    var arrivals as Array<Arrival> = [];

    function initialize(id as String, name as String, data as Array<Dictionary>) {
        stopPointId = id;
        stationName = name;
        for (var i = 0; i < data.size(); i++) {
            arrivals.add(new Arrival(data[i]));
        }
    }
}