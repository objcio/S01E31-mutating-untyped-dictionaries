//: Problem: How to mutate part of a nested untyped dictionary (e.g. [String:Any])
//: Source: http://stackoverflow.com/questions/40261857/remove-nested-key-from-dictionary

var dict: [String:Any] = [
    "countries": [
        "japan": [
            "capital": "tokyo"
        ]
    ]
]

//: Accessing Key Paths: Type casts are required and make this every ugly:
((dict["countries"] as? [String:Any])?["japan"] as? [String:Any])?["capital"]


//: Simple, but verbose solution to mutate the `capital` value:
if var countries = dict["countries"] as? [String:Any],
    var japan = countries["japan"] as? [String: Any] {
    japan["capital"] = "berlin"
    countries["japan"] = japan
    dict["countries"] = countries
}


//: ### Subscript Solution
//: We create a special subscript for nested `[String:Any]` dictionaries that also has a setter:

extension Dictionary {
    subscript(jsonDict key: Key) -> [String:Any]? {
        get {
            return self[key] as? [String:Any]
        }
        set {
            self[key] = newValue as? Value
        }
    }
}

//: Looking up a value got much simpler:
dict[jsonDict: "countries"]?[jsonDict: "japan"]?["capital"]
//: We can also set a new value:
dict[jsonDict: "countries"]?[jsonDict: "japan"]?["capital"] = "amsterdam"


//: We can also add a very similar subscript for `String` values, so that we can mutate the "capital" value by e.g. calling `append`:

extension Dictionary {
    subscript(string key: Key) -> String? {
        get {
            return self[key] as? String
        }
        set {
            self[key] = newValue as? Value
        }
    }
}

dict[jsonDict: "countries"]?[jsonDict: "japan"]?[string: "capital"]?.append("!")
