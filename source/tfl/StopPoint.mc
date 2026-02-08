import Toybox.Lang;
import Toybox.Time;
import Toybox.System;

class ArrivalTtsComparator {
    function compare(arr1 as Lang.Object, arr2 as Lang.Object) as Lang.Number {
        System.println("arr1: " + arr1);
        System.println("arr2: " + arr2);

        var a = arr1 as Arrival;
        var b = arr2 as Arrival;

        return (a.timeToStation - b.timeToStation);
    }
}

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

    function toString() as String {
        return lineName + " to " + destinationName + " " + secsToStr(timeToStation);
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
        System.println("About to sort.");
        arrivals.sort(new ArrivalTtsComparator());
    }

    
}