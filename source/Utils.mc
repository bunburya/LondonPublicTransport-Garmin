import Toybox.Lang;
import Toybox.Time;
import Toybox.Graphics;
import Toybox.Math;
import Toybox.System;

// Create a string from an array by joining the array's elements with the given delimiter
function joinArray(arr as Array<String>, delim as String or Char) as String {
    var s = "";
    for (var i = 0; i < arr.size(); i++) {
        s += arr[i];
        if (i < arr.size()-1) {
            s += delim;
        }
    }
    return s;
}

// Parse a string in a format line "2026-01-27T19:04:19Z" to a `Moment`.
function parseDateTime(dt as String) as Moment {
    return Gregorian.moment({
        :year => dt.substring(0, 4).toNumber(),
        :month => dt.substring(5, 7).toNumber(),
        :day => dt.substring(8, 10).toNumber(),
        :hour => dt.substring(11, 13).toNumber(),
        :minute => dt.substring(14, 16).toNumber(),
        :second => dt.substring(17, 19).toNumber()
    });
}

function parseNullableDateTime(dt as String?) as Moment? {
    if (dt == null) {
        return null;
    } else {
        return parseDateTime(dt);
    }
}

// Split a string on a delimiter. By default, empty segments are skipped;
// pass `keepEmpty: true` to preserve them.
function splitString(str as String, delimiter as String, keepEmpty as Boolean) as Array<String> {
    var result = [];
    var delimiterPos = str.find(delimiter);

    while (delimiterPos != null) {
        var word = str.substring(0, delimiterPos);
        if (keepEmpty || word.length() > 0) {
            result.add(word);
        }
        str = str.substring(delimiterPos+delimiter.length(), str.length());
        delimiterPos = str.find(delimiter);
    }

    if (keepEmpty || str.length() > 0) {
        result.add(str);
    }

    return result;
}

// Convert number of seconds to a human-readable string communicating minutes
// and seconds, eg, 72 -> "1m12s".
function secsToStr(totalSecs as Number) as String {
    var mins = Math.floor(totalSecs / 60) as Number;
    var secs = totalSecs % 60;
    return mins + "m" + secs + "s";
}


function eq(obj1, obj2) as Boolean {
    if (obj1 == obj2) {
        // If objects are identical, return true
        return true;
    }
    if (obj1 has :size && obj2 has :size) {
        if (obj1.size() != obj2.size()) {
            // If objects have a size but they are different, return false
            return false;
        }
        if (obj1 instanceof Array && obj2 instanceof Array) {
            for (var i = 0; i < obj1.size(); i++) {
                if (!eq(obj1[i], obj2[i])) {
                    return false;
                }
            }
            return true;

        } else if (obj1 instanceof Dictionary && obj2 instanceof Dictionary) {
            var keys = obj1.keys();
            for (var i = 0; i < keys.size(); i++) {
                var k = keys[i];
                if (!eq(obj1[k], obj2[k])) {
                    return false;
                } 
            }
            return true;

        } 
    } else if (obj1 instanceof String && obj2 instanceof String) {
        
        if (obj1.compareTo(obj2) == 0) {
            return true;
        } else {
            return false;
        }
    }
    return false;
}

function copyArray(array as Array) as Array {
    var copy = [];
    for (var i = 0; i < array.size(); i++) {
        copy.add(array[i]);
    }
    return copy;
}

function formatTime(t as ClockTime or Moment or LocalMoment, inclSecs as Boolean) as String {
    var info;
    if (t instanceof ClockTime) {
        info = t;
    } else {
        info = Gregorian.utcInfo(t, Time.FORMAT_SHORT);
    }
    if (!inclSecs) {
        var min = info.min;
        if (info.sec >= 30) {
            min += 1;
        }
        return Lang.format("$1$:$2$", [
            info.hour.format("%02u"),
            min.format("%02u")
        ]);
    } else {
        return Lang.format("$1$:$2$:$3$", [
            info.hour.format("%02u"),
            info.min.format("%02u"),
            info.sec.format("%02u"),
        ]);
    }
}

function clockTimeToString() as String {
    return formatTime(System.getClockTime(), true);
}

class NotImplementedException extends Lang.Exception {
    function initialize() {
        Lang.Exception.initialize();
    }
}