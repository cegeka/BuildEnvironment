# BuildEnvironment

[![Version](http://cocoapod-badges.herokuapp.com/v/BuildEnvironment/badge.png)](http://cocoadocs.org/docsets/BuildEnvironment)
[![Platform](http://cocoapod-badges.herokuapp.com/p/BuildEnvironment/badge.png)](http://cocoadocs.org/docsets/BuildEnvironment)

## Usage

To run the example project; clone the repo, and run `pod install` from the Example directory first.

## Installation

BuildEnvironment is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "BuildEnvironment", :git => ''

## Different build environments

In your application you might need different values depending on the build of your application. Imagine you are creating a test, an acceptance and a production build of your app. You might want to talk to different backends for each build.

You can set this up as follows:
1 Go to your Info.plist and add the property `BEConfiguration` with value `${CONFIGURATION}`
2 Create a `BEConfiguration.plist`. Add a `Debug` and a `Release` property with type Dictionary
3 Add your environment specific properties to this Debug/Release dictionary. Environment independent properties can be added to the root
4 In your code you can access this using: `BEConfig.configuration[@"key_in_configuration_plist"]`

![Example configuration](/Screenshots/beconfiguration.png?raw=true)

You can also add an extra configuration (eg Acceptance), by going to your Project settings and adding a configuration in the
Configurations section. You might need to rerun `pod install` after this.

![New configuration](/Screenshots/new_configurations.png?raw=true)

You can specify which configuration to use by editing your Scheme.

![Specify the build configuration](/Screenshots/specify_build_configuration.png?raw=true)

You could also duplicate a Scheme, set it up as an Acceptance build, and make sure the Scheme is shared. You can then set up your CI server to automatically build this scheme.

## Check software licenses

To automatically check the software licenses during your build, you can use `check_licenses.sh`. This
will check your CocoaPods dependencies. If it finds a dependency that has something other than a MIT, BSD
or Apache license, it will fail the build. 

![Check licenses screenshot](/Screenshots/check_licenses_example.png?raw=true)

* Go to your target, Build phases. Add a new Run Script Build phase
* Enter the following: `${PODS_ROOT}/BuildEnvironment/check_licenses.sh`
* You can also specifiy the licenses you want to allow by adding a parameter: `${PODS_ROOT}/BuildEnvironment/check_licenses.sh -l BSD` By default MIT, BSD and Apache are allowed.
* You can also make exceptions for certain projects that you want to allow anyway: `${PODS_ROOT}/BuildEnvironment/check_licenses.sh -e AFNetworking`

## Author

Jan Sabbe, jan.sabbe@gmail.com

## License

BuildEnvironment is available under the MIT license. See the LICENSE file for more info.

