import Toybox.Position;
import Toybox.Graphics;

const APP_NAME = "London Public Transport for Garmin";
const APP_VERSION = "1.0.0";
const USER_AGENT = APP_NAME + " v" + APP_VERSION;
const BASE_URL = "https://api.tfl.gov.uk/";
const LONDON = new Position.Location({
    :latitude => 51.477979,
    :longitude => 0,
    :format => :degrees
});

enum StorageKey {
    LINE_STATUS_LINES,
    ARRIVALS_STOPPOINTS,
    DEPARTURES_STOPPOINTS,
    BIKEPOINTS
}

enum TflColor {
    TFL_RED = Graphics.createColor(255, 220, 36, 31),
    TFL_YELLOW = Graphics.createColor(255, 255, 200, 10),
    TFL_GREEN = Graphics.createColor(255, 0, 125, 50)
}