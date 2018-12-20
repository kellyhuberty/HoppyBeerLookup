# Hoppy: BreweryDB Lookup for iOS

## Install Instructions

1. Clone project and switch branch to `master` if necessary.
2. Open the **Hoppy.xcworkspace** in Xcode 10.1. **Ensure that it is the workspace file, as the regular project file will not build an app that will run.**
3. Click "run" in your preferred simulator.

## To run tests

HoppyTests is set as the test target of Hoppy.app. To run tests open the workspace as you would for building and go to Product → Test (⌘ U).

## Third Party Libraries.

Hoppy includes the following third-party libraries:

* Alamofire
* Mockingjay [See Footnote 4]

All other code is original work by Kelly Huberty. 

## Testing Considerations.

The key provided by BreweryDB is a testing key. Because of this they note that the data set it returns is much more limited. Anecdotally, I've noticed the following queried yield great testing results:
* "Sierra Nevada"
* "Porter"
* "Stout"
* "ESB"
* "Breckenridge"

Your mileage may very.

## Footnotes and notes on code.

1. The code is included using Cocoapods. Typically, a project is committed without it's cocoapod dependencies to refer to it's original creator. In the interest of making Installation as easy as possible, this project contains it's cocoapod dependencies within it's GitHub repo. **Run `pod install` at your own risk, as the only version that is garenteed to work is the one installed right now.**
2. The project contains it's own breweryDB key for convenience of running.
3. For reasons I couldn’t explain, the Objective-c names for Swift symbols were not importing back to the bridging header Swift Interface cleanly if I defined them in the Objective-C header.
4. Originally I was going to use Mockingjay to test network requests, but I found my current tests adequate for now, and ran out of time to do this. Mockingjay is still included to encourage future development.

## Future plans...

I'm not planning on taking this much further, but if I do my next steps would be...

* Fully test the service layer. I feel like the most bang for the testing buck would be to test the Service and Network Layers.
* Use Mockingjay and JSON files to test the parser more thoroughly.
* Fix small selection state issues with how the split view controller reassembles itself after rotation.
* Add more data?
* Centralize the Fonts and Colors to a single place.


