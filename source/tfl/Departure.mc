import Toybox.Lang;
import Toybox.Time;

class DepartureScheduledComparator {
    function compare(dep1 as Lang.Object, dep2 as Lang.Object) as Lang.Number {
        var a = dep1 as Departure;
        var b = dep2 as Departure;
        return a.scheduled.compare(b.scheduled);
    }
}


class Departure {
    var platform as String;
    var destinationId as String;
    var destinationName as String;
    var scheduled as Moment;
    var estimated as Moment?;
    var status as String;
    var cause as String?;

    function initialize(
        platform as String,
        destinationId as String,
        destinationName as String,
        scheduled as Moment,
        estimated as Moment?,
        status as String,
        cause as String?    
    ) {
        self.platform = platform;
        self.destinationId = destinationId;
        self.destinationName = destinationName;
        self.scheduled = scheduled;
        self.estimated = estimated;
        self.status = status;
        self.cause = cause;
    }

    static function fromDict(data as Dictionary) as Departure {
        return new Departure(
            data["platformName"],
            data["destinationNaptanId"],
            data["destinationName"],
            parseDateTime(data["scheduledTimeOfDeparture"]),
            parseNullableDateTime(data["estimatedTimeOfDeparture"]),
            data["departureStatus"],
            data["cause"]
        );
    }

    function isOnTime() as Boolean {
        return eq(status, "OnTime");
    }

    function isAlmostOnTime() as Boolean {
        if (estimated == null) {
            return false;
        }
        var diff = estimated.subtract(scheduled) as Duration;
        return diff.lessThan(new Duration(30));
    }

    function isCancelled() as Boolean {
        return status == "Cancelled";
    }

    function statusStr() as String {
        var s;
        if (isOnTime() || isAlmostOnTime()) {
            s = formatTime(scheduled, false);
        } else if (eq(status, "Cancelled")) {
            s = "Cancelled";
        } else {
            if (estimated != null) {
                s = formatTime(estimated, false) + " (sched. " + formatTime(scheduled, false) + ")";
            } else {
                s = status + " (sched. " + formatTime(scheduled, false) + ")";
            }
        }
        if (platform != null && platform.length() > 0) {
            s += " @ " + platform;
        }
        return s;
    }
}