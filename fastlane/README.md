# Fastlane Setup Instructions

[Fastlane](http://fastlane.tools) is a tool - primarily designed for iOS & written in Ruby -
that simplifies the configuration of Continuous Deployment pipelines.

By simply adding a few config files to your iOS project you should be able to
build, test, codesign, and deploy test builds from your local command line, or
Jenkins job. Fastlane is also extremely customizable so it should work well with
small hack day projects or complex client projects.

![Fastlane Diagram](http://fastlane.tools/assets/img/diagram.png)

## Setup Instructions

1. If you don't have a Gemfile, create one (e.g. `$ bundle init`).

2. Add fastlane to your Gemfile (e.g. `$ echo "gem \"fastlane\", \"~>0.1\"" >> Gemfile`).

3. Install fastlane (e.g. `$ bundle install` )

4. Configure fastlane by running `$ bundle exec fastlane init`.
Refer to [these instructions](https://github.com/KrauseFx/fastlane/blob/master/GUIDE.md#get-it-up-and-running).
**Important:** When asked for your Apple ID, leave it blank.

  ```bash
  $ bundle exec fastlane init
  INFO [2015-02-26 11:24:39.18]: This setup will help you get up and running in no time.
  INFO [2015-02-26 11:24:39.18]: First, it will move the config files from `deliver` and `snapshot`
  INFO [2015-02-26 11:24:39.18]: into the subfolder `fastlane`.

  INFO [2015-02-26 11:24:39.18]: Fastlane will check what tools you're already using and set up
  INFO [2015-02-26 11:24:39.18]: the tool automatically for you. Have fun!
  Do you want to get started? This will move your Deliverfile and Snapfile (if they exist) (y/n)
  y
   Do you have everything commited in version control? If not please do so! (y/n)
  y
   INFO [2015-02-26 11:24:49.17]: Created new folder './fastlane'.
  INFO [2015-02-26 11:24:49.17]: ------------------------------
  INFO [2015-02-26 11:24:49.17]: To not re-enter your username and app identifier every time you run one of the fastlane tools or fastlane, these will be stored from now on.
  App Identifier (com.krausefx.app): com.detroitlabs.MyApp
  Your Apple ID:
  INFO [2015-02-26 11:25:04.05]: Created new file './fastlane/Appfile'. Edit it to manage your preferred app metadata information.
  Do you want to setup 'deliver', which is used to upload app screenshots, app metadata and app updates to the App Store or Apple TestFlight? (y/n)
  n
   Do you want to setup 'snapshot', which will help you to automatically take screenshots of your iOS app in all languages/devices? (y/n)
  n
   Do you want to use 'sigh', which will maintain and download the provisioning profile for your app? (y/n)
  y
   INFO [2015-02-26 11:25:22.06]: 'deliver' not enabled.
  INFO [2015-02-26 11:25:22.06]: 'snapshot' not enabled.
  INFO [2015-02-26 11:25:22.06]: 'xctool' not enabled.
  INFO [2015-02-26 11:25:22.06]: 'cocoapods' not enabled.
  INFO [2015-02-26 11:25:22.06]: 'sigh' enabled.
  INFO [2015-02-26 11:25:22.06]: Created new file './fastlane/Fastfile'. Edit it to manage your own deployment lanes.
  INFO [2015-02-26 11:25:22.06]: Successfully finished setting up fastlane
  ```

5. Edit your **fastlane/Appfile**, add the DL Enterprise team name if to
provision for distribution via Crashlytics Beta:

  ```ruby
  app_identifier "com.detroitlabs.MyApp"

  # Use DL Enterprise Team to provision for Beta distribution
  team_name "Detroit Labs, LLC (ENT)"
  ```

6. Create a **.xctool-args** file in the root of your project, and add any
xctool arguments that you need as a JSON Array:

  ```json
  [
    "-workspace", "MyApp.xcworkspace",
    "-scheme", "MyApp",
    "-configuration", "Debug",
    "-sdk", "iphonesimulator",
    "-destination", "name=iPhone 5s,OS=8.1",
    "-reporter", "plain",
    "-reporter", "junit:test-reports/coverage.xml"
  ]
  ```

7. Edit your **fastlane/Fastfile** to define your deployment "lanes." You can
define as many lanes as need. You could define lanes for anything you want, such as;

  - distributing test builds to DL QA testers on every merge to the master branch,
  so that they are immediately able to test features & bug fixes as you push them.
  - ship nightly/weekly builds to clients
  - build & test locally, from the command line
  - build, test, and ship an app to the app store, w/ updated screenshots and metadata.

  See the [example Fastfile](Fastfile-example) for a simple "test" & "inhouse" lane setup.

8. In order to deploy from your local machine you may need to add some local
environment variables (i.e. .bash_profile ) depending on which actions you want
to use, locally.

  ```bash
  # Crashlytics (Required if deploying via Crashlytics Beta)
  export CRASHLYTICS_API_KEY="####################"
  export CRASHLYTICS_BUILD_SECRET="####################"

  # HipChat (Required if using HipChat)
  export HIPCHAT_API_TOKEN="####################"
  export HIPCHAT_API_VERSION="1"

  # Apple ID (Required if using Sigh)
  export DELIVER_USER="your.apple.id@email.com"
  ```

9. Once you are all setup, run your lane(s) from the command line to make sure
everything is working:

  ```bash
  $ bundle exec fastlane test inhouse
  ```

  When running locally, you might get prompted the first time for certain steps
  (i.e. sigh).

  If the deploy works, you can add fastlane as an "Execute shell" build step in
  your Jenkins job:

  ```bash
  bundle --path=.bundle && bundle exec fastlane test inhouse
  ```

## ...and beyond!

There are lots of things you can do with fastlane. Check out the
[other available fastlane actions](https://github.com/krausefx/fastlane#actions)
or [write your own](https://github.com/krausefx/fastlane#extensions)!
