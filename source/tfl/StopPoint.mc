import Toybox.Lang;
import Toybox.Time;
import Toybox.System;
import Toybox.Application;

class StopPoint {
    var id as String;
    var name as String;
    var indicator as String?;
    var towards as String?;
    var modes as Array<String>;
    var lines as Array<TflLine>;
    var parentId as String?;

    function initialize(
        id as String,
        name as String,
        indicator as String?,
        towards as String?,
        modes as Array<String>?,
        lines as Array<TflLine>?,
        parentId as String?
    ) {
        self.id = id;
        self.name = name;
        self.indicator = indicator;
        self.towards = towards;
        self.modes = modes;
        self.lines = lines;
        self.parentId = parentId;
    }

    static function fromDict(data as Dictionary) as StopPoint {
        //System.println("fromDict called on data: " + data.toString());
        var name = data["name"];
        if (name == null) {
            name = data["commonName"];
        }
        var linesData = data["lines"] as Array<Dictionary>?;
        var lines = null;
        if (linesData != null) {
            lines = [];
            for (var i = 0; i < linesData.size(); i++) {
                var d = linesData[i];
                lines.add(new TflLine(d["id"], d["name"]));
            }
        }
        return new StopPoint(
            data["id"],
            name,
            data["indicator"],
            data["towards"],
            data["modes"],
            lines,
            data["topMostParentId"]
        );
    }

    static function fromDictArray(data as Array<Dictionary>) as Array<StopPoint> {
        var stopPoints = [];
        for (var i = 0; i < data.size(); i++) {
            stopPoints.add(StopPoint.fromDict(data[i]));
        }
        return stopPoints;
    }

    function toDict() as Dictionary {
        var dict = {
            "id" => id,
            "name" => name,
        };
        if (indicator != null) {
            dict["indicator"] = indicator;
        }
        if (towards != null) {
            dict["towards"] = towards;
        }
        if (modes != null) {
            dict["modes"] = modes;
        }
        if (lines != null) {
            var lineArray = [];
            for (var i = 0; i < lines.size(); i++) {
                var line = lines[i];
                lineArray.add({"id" => line.id, "name" => line.name});
            }
            dict["lines"] = lineArray;
        }
        return dict;
    }

    function toString() as String {
        return "StopPoint(" + toDict() + ")";
    }

    function hasAnyMode(modesToSearch as Array<String>) as Boolean {
        for (var i = 0; i < modesToSearch.size(); i++) {
            for (var j = 0; j < modes.size(); j++) {
                if (eq(modes[j], modesToSearch[i])) {
                    return true;
                }
            }
        }
        return false;
    }

    function hasAnyLine(linesToSearch as Array<String>) as Boolean {
        System.println("hasAnyLine called");
        System.println("lines: " + lines);
        System.println("linesToSearch: " + linesToSearch.toString());
        for (var i = 0; i < linesToSearch.size(); i++) {
            for (var j = 0; j < lines.size(); j++) {
                if (eq(lines[j].id, linesToSearch[i])) {
                    return true;
                }
            }
        }
        return false;
    }
}

function filterStopPointsByModes(stopPoints as Array<StopPoint>, modes as Array<String>) as Array<StopPoint> {
    var filtered = [];
    for (var i = 0; i < stopPoints.size(); i++) {
        if (stopPoints[i].hasAnyMode(modes)) {
            filtered.add(stopPoints[i]);
        }
    }
    return filtered;
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
        if (eq(d["id"], id)) {
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

function addStopPoint(stopPoint as StopPoint, storageKey as StorageKey) {
    var data = Application.Storage.getValue(storageKey) as Array<Dictionary>?;
    if (data == null) {
        data = [];
    }
    data.add(stopPoint.toDict());
    Application.Storage.setValue(storageKey, data);
}