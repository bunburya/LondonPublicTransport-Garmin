import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Graphics;

function aboutView() as InfoView {
    var body = WatchUi.loadResource(Rez.Strings.AppName)
        + " (" + WatchUi.loadResource(Rez.Strings.AppNameLong) + ") v"
        + WatchUi.loadResource(Rez.Strings.AppVersion) + "\n\n"
        + WatchUi.loadResource(Rez.Strings.AboutLicence) + "\n\n"
        + WatchUi.loadResource(Rez.Strings.TflAttr);
    return new InfoView(
        WatchUi.loadResource(Rez.Strings.AboutMenuLabel),
        Graphics.COLOR_WHITE,
        body
    );
}