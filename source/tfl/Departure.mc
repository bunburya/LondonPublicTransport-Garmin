import Toybox.Lang;
import Toybox.Time;

class Departure {
    var platform as String;
    var destinationId as String;
    var destinationName as String;
    var scheduled as Moment;
    var estimated as Moment?;
    var status as String;

    function initialize(platform as String, destinationId as String, destinationName as String, scheduled as Moment, estimated as Moment?, status as String) {
        self.platform = platform;
        self.destinationId = destinationId;
        self.destinationName = destinationName;
        self.scheduled = scheduled;
        self.estimated = estimated;
        self.status = status;
    }

    static function fromDict(data as Dictionary) as Departure {
        return new Departure(
            data["platformName"],
            data["destinationNaptanId"],
            data["destinationName"],
            parseDateTime(data["scheduledTimeOfDeparture"]),
            parseNullableDateTime(data["estimatedTimeOfDeparture"]),
            data["Status"]
        );
    }
}