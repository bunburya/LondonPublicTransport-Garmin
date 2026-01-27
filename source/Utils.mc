import Toybox.Lang;

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

function typeOf(obj) {
    switch (obj) {
        case instanceof Array: return "Array";
        case instanceof Boolean: return "Boolean";
        case instanceof ByteArray: return "ByteArray";
        case instanceof Char: return "Char";
        case instanceof Dictionary: return "Dictionary";
        case instanceof Double: return "Double";
        case instanceof Float: return "Float";
        case instanceof InvalidOptionsException: return "InvalidOptionsException";
        case instanceof InvalidValueException: return "InvalidValueException";
        case instanceof Long: return "Long";
        case instanceof Method: return "Method";
        case instanceof Number: return "Number";
        case instanceof String: return "String";

        case instanceof Exception: return "Exception";
        default: return null;
        
    }
}

class Iter {
    
}