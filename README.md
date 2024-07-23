# Tech Task

This repo contains my completed Tech Task for an anon company. It is built using Swift and UIKit (a requirment of the task). It also makes heavy use of Swift Concurrency, notably `async`/`await` and `actors`.

To anonymize the test, dummy data is returned from a local server that is started at launch of the app.

The app can be run by building the `TechTask` scheme.

## Architecture 

This project is divided up into several modules. It relies on a combination of feature and service modules. Feature modules host cohesive sets of user facing functionality (in this particular case, each screen is a feature module), and services contain cohesive chunks of repeatable logic used throughout the app. Features may not know about other features to avoid coupling but features may rely upon services at their boundaries. 

Modules rely on a VIPER-esque style architecture, with use cases that handle business logic and interact with adaptions of other dependencies. 

All modules are created with the `Factory` pattern located in the `Public API` folder of their module.

There is also a lone UI module containing some repeated views and UI concepts (i.e sizing and colours).

### Feature Modules

The list of feature modules are as follows:
- Home
- Add Savings Goals
- Savings
- Round Up

### Service Modules
The list of service modules are as follows:
- Auth
    - Contains information about the account and where the auth token is located. This information is refresh each time the app is launched.
- Networking
    - Contains the networking layer.
- Currency
    - Contains currency adaption logic which happens across the app.
- Local Server 
    - Used for UI testing.


## Testing

The project looks to take advantage of several forms of testing that make up a mobile test pyramid. It leans heavily on code level unit tests that test the behaviours of the various modules but also has a level of UI test coverage ensuring the happy paths are working.

### Unit testing
Each module contains its own test target. These can be run by testing individual modules, or by testing the `TechTask` project as a whole to run all of them

### UI Testing
Also included in the project are app test harnesses for each of the feature modules. These are sample apps that are used to run UI tests against. Each feature module is passed a modifiable base URL at the point of initialization, and in the test harnesses, it is swapped out to point at a local web server (`LocalServer`) where fake requests are returned.

## Design decisions
- The rounding up actually happens in the `Home` feature module (`RoundUpUseCase`), which is then passed to the `RoundUp` module. I did this so the users transaction state doesn't change, so that when they see Round Up screen, there isn't a chance that new transactions have appeared and invalidate the amount they have chosen to round up.
- I've made an assumption that outgoings that go to another savings account shouldn't be included in the round up calculation. Neither should any incoming transactions.
- The auth token for the user you want to test with should be placed in the `DefaultAuthTokenController` file in the `Auth` module.

## Known limitations
- No refreshing of the home screen.
- App needs to be restarted if auth token is out of date.
- UI tests mostly test happy paths and aren't a complete suite.
- UI tests may fail if something else on the host machine is running on port `15411`.

