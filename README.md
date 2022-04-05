# MapKit-SwiftUI

MapKit, but with SwiftUI!

## Examples

**Example 1: Simple Map**

```swift
import MapKitSwiftUI

struct ContentView: View {

    var body: some View {
        AppleMap(lat: 42.336777, long: -71.097242)
            .displayCompass()
            .pointsOfInterest(include: [.school, .cafe, .park])
            .zoomBoundry(500..<2500)
            .ignoresSafeArea()
    }
    
}
```

Configuring your AppleMap is easy.

**Example 2: Markers**

```swift
let places: [Place] = [
    Place("Coffee! ☕️", lat: 42.33562, long: -71.095651),
    Place("Campus 🫡", lat: 42.336777, long: -71.097242)
]

var body: some View {
    AppleMap(lat: 42.336777, long: -71.097242, annotations: places) {
        Marker(lat: $0.coordinate.latitude, long: $0.coordinate.longitude)
            .title($0.name, subtitle: "Place of interest")
            .color(.systemPurple)
            .glyphImage(systemName: "building.fill")
    }
        .zoomBoundry(500..<2500)
        .boundary(distance: 250)
}
```

Easily add markers or pins to the map by using the `Marker` and `Pin` models

```swift
struct Place {

    let name: String
    let lat: Double
    let long: Double
    
    init(_ name, lat: Double, long: Double) {
        self.name = name
        self.lat = lat
        self.long = long
    }
    
}
```

*Place model I used in example 2 and 3*

**Example 3: Pins**

```swift
import MapKitSwiftUI

struct ContentView: View {

    let places: [Place] = [
        Place("Coffee! ☕️", lat: 42.33562, long: -71.095651),
        Place("Campus 🫡", lat: 42.336777, long: -71.097242)
    ]

    var body: some View {
        AppleMap(lat: 42.336777, long: -71.097242, annotations: places) {
            Pin(lat: $0.coordinate.latitude, long: $0.coordinate.longitude)
                .title($0.name)
                .color(.systemBlue)
        }
            .zoomBoundry(500..<2500)
            .boundary(distance: 250)
    }
    
}
```

Pins are very similar to Markers
