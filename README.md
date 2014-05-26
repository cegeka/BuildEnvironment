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

## Automatically increment bundle version

You can use update_version.sh to automatically increment the CFBundleVersion in your Info.plist. This script will put a timestamp in the version.
1 Edit your build scheme and add a Pre-Action to the Build step. You can add a Run script action here.
2 Make sure 'Provile build settings from' dropdown is filled in with your default target
3 Enter the following `"${PODS_ROOT}/BuildEnvironment/update_version.sh"

## Upload to HockeyApp

You can use upload_to_hockeyapp.sh to setup your Xcode build server to automatically sign and upload apps to HockeyApp.
1 Edit your build schemes and duplicate your default one.
2 Mark it as shared, and add a post-action to the Archive step. Add a "New Run Script Action". Make sure 'Provide build settings from' dropdown is filled in.
3 Enter `"${PODS_ROOT}"/BuildEnvironment/upload_to_hockeyapp.sh`. If you want to see the log of this script, add `exec > /tmp/log_hockeyapp.txt 2>&1` at the top. This will log it on your build server in `/tmp/log_hockeyapp.txt`
4 Next go to your Target configuration then Build settings. Add a user-defined setting `HOCKEYAPP_API_TOKEN` which should contain your Api token. Also add a `HOCKEYAPP_APP_ID` user-defined setting which contains your App ID.
5 Make sure your Code Signing and Provisioning Profile settings are correct. Also make sure the same provisioning profile and signing certificate are available on the XCode server. 

![Add post action](/Screenshots/post_action_upload.png?raw=true)
![Add user defined setting](/Screenshots/user_defined_action.png?raw=true)

## Check software licenses

To automatically check the software licenses during your build, you can use `check_licenses.sh`. This
will check your CocoaPods dependencies. If it finds a dependency that has something other than a MIT, BSD
or Apache license, it will fail the build. 

![Check licenses screenshot](/Screenshots/check_licenses_example.png?raw=true)

1 Go to your target, Build phases. Add a new Run Script Build phase
2 Enter the following: `"${PODS_ROOT}"/BuildEnvironment/check_licenses.sh`
3 You can also specifiy the licenses you want to allow by adding a parameter: `"${PODS_ROOT}"/BuildEnvironment/check_licenses.sh -l BSD` By default MIT, BSD and Apache are allowed.
4 You can also make exceptions for certain projects that you want to allow anyway: `"${PODS_ROOT}"/BuildEnvironment/check_licenses.sh -e AFNetworking`

## Check outdated dependencies

You can also check if all your cocoapod dependencies are outdated. Integrating `check_outdated.sh` in your build will generate a build warning if a dependency has a newer version.

1 Go to your target, Build phases. Add a new Run Script Build phase
2 Enter the following: `"${PODS_ROOT}"/BuildEnvironment/check_outdated.sh`

![Check outdated screenshot](/Screenshots/check_outdated_warnings.png?raw=true)

## Author

Developed in the [Cegeka European App Factory](http://europeanappfactory.com/) 
* Jan Sabbe

## License

BuildEnvironment is available under the MIT license. See the LICENSE file for more info.

