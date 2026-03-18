import Toybox.Position;
import Toybox.Graphics;
import Toybox.Time;
import Toybox.Application;

const APP_NAME = Application.loadResource(Rez.Strings.AppName);
const APP_VERSION = Application.loadResource(Rez.Strings.AppVersion);
const USER_AGENT = APP_NAME + "(" + Application.loadResource(Rez.Strings.AppNameLong) + ") v" + APP_VERSION;
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
