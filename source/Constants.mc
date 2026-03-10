import Toybox.Position;
import Toybox.Graphics;
import Toybox.Time;

const APP_NAME = "London Public Transport for Garmin";
const APP_VERSION = "1.0.0";
//const USER_AGENT = APP_NAME + " v" + APP_VERSION;
const USER_AGENT = "Mozilla/5.0 (X11; Linux x86_64; rv:148.0) Gecko/20100101 Firefox/148.0";
const BASE_URL = "https://api.tfl.gov.uk/";

const ARRIVALS_MODES = ["bus", "tube", "tram"];
const ARRIVALS_LINES = null;
const DEPARTURES_MODES = ["overground", "elizabeth-line", "national-rail"];
const DEPARTURES_LINES = [
    "thameslink",
    "elizabeth",
    "liberty",
    "lioness",
    "mildmay",
    "suffragette",
    "weaver",
    "windrush"
];

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

const SECOND = new Duration(1);