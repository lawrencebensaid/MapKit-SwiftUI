# MapKit-SwiftUI

MapKit, but with SwiftUI!

Easily add an AppleMap to your app.

```swift
import MapKitSwiftUI

struct ContentView: View {

    var body: some View {
        AppleMap(lat: 42.336777, long: -71.097242)
            .zoomBoundry(500..<2500)
            .boundary(distance: 250)
            .pointsOfInterest(include: [.school, .cafe])
    }
    
}
```
