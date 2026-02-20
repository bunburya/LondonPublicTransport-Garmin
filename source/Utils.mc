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

// Split a string on a delimiter
function splitString(str as String, delimiter as String) as Array<String> {
    var result = [];
    var delimiterPos = str.find(delimiter);
    
    while (delimiterPos != null) {
        var word = str.substring(0, delimiterPos);
        if (word.length() > 0) {
            result.add(word);
        }
        str = str.substring(delimiterPos+delimiter.length(), str.length());
        delimiterPos = str.find(delimiter);
    }

    if (str.length() > 0) {
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

// Compare two arrays by value
function arrayEq(arr1 as Array, arr2 as Array) as Boolean {
    if (arr1.size() != arr2.size()) {
        return false;
    }
    for (var i = 0; i < arr1.size(); i++) {
        if (!arr1[i].equals(arr2[i])) {
            return false;
        }
    }
    return true;
}

function copyArray(array as Array) as Array {
    var copy = [];
    for (var i = 0; i < array.size(); i++) {
        copy.add(array[i]);
    }
    return copy;
}

function localTime() as Time.LocalMoment {
    return Time.Gregorian.localMoment(LONDON, Time.now());
}

function localTimeToString(t as Time.LocalMoment) as String {
    var info = Time.Gregorian.info(t, Time.FORMAT_SHORT);
    return Lang.format("$1$:$2$:$3$", [
        info.hour.format("%02u"),
        info.min.format("%02u"),
        info.sec.format("%02u"),
    ]);
}

class NotImplementedException extends Lang.Exception {
    function initialize() {
        Lang.Exception.initialize();
    }
}