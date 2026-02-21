import Toybox.Lang;
import Toybox.Time;
import Toybox.System;
import Toybox.Application;

class ArrivalTtsComparator {
    function compare(arr1 as Lang.Object, arr2 as Lang.Object) as Lang.Number {
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

class StopPoint {
    var id as String;
    var name as String;
    var indicator as String?;

    function initialize(stopId as String, stopName as String, stopIndicator as String?) {
        id = stopId;
        name = stopName;
        indicator = stopIndicator;
    }

    static function fromDict(data as Dictionary) as StopPoint {
        return new StopPoint(data["id"], data["commonName"], data["indicator"]);
    }
}

class StopPointArrivals {
    var stopPoint as StopPoint;
    var arrivals as Array<Arrival> = [];

    function initialize(sp as StopPoint, data as Array<Dictionary>) {
        stopPoint = sp;
        for (var i = 0; i < data.size(); i++) {
            arrivals.add(new Arrival(data[i]));
        }
        arrivals.sort(new ArrivalTtsComparator());
    }
}

function getStopPointById(id as String, storageKey as StorageKey) as StopPoint? {
    var stopPoints = Application.Storage.getValue(storageKey) as Array<Dictionary>?;
    if (stopPoints == null) {
        return null;
    }
    for (var i = 0; i < stopPoints.size(); i++) {
        var d = stopPoints[i];
        if (d["stopId"] == id) {
            return StopPoint.fromDict(d);
        }
    }
    return null;
}

function loadStopPointIds(storageKey as StorageKey) as Array<String> {
    var data = Application.Storage.getValue(storageKey) as Array<Dictionary>?;
    if (data == null) {
        return [];
    } else {
        var ids = [];
        for (var i = 0; i < data.size(); i++) {
            ids.add(data[i]["id"]);
        }
        return ids;
    }
}

function loadStopPoints(storageKey as StorageKey) as Array<StopPoint> {
    var data = Application.Storage.getValue(storageKey) as Array<Dictionary>?;
    if (data == null) {
        return [];
    } else {
        var stopPoints = [];
        for (var i = 0; i < data.size(); i++) {
            stopPoints.add(StopPoint.fromDict(data[i]));
        }
        return stopPoints;
    }
}