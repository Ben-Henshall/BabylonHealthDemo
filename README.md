# babylon-health-demo

[Technical demo spec can be found here](https://github.com/Babylonpartners/iOS-Interview-Demo/blob/master/demo.md)

[A git repo containing this project can be found here] 
(https://github.com/Ben-Henshall/BabylonHealthDemo)

## Installation

This project uses Carthage to install dependencies. Rather than using the traditional "Carthage update" method, it uses the lightweight method of `--no-build`.

To pull the currently used versions of the library, use:
`carthage checkout`

To update the dependencies, use:
`carthage update --use-submodules --no-build`

The dependencies are built in the BabylonHealthDemo workspace. *USE THIS WORKSPACE TO BUILD AND EXECUTE THE PROJECT.*

## Design

### SceneCoordinator
A simplified version of the co-ordinator pattern. Unlike the typical co-ordinator implementations, this does not have child co-ordinators and  removes any dependencies between separate ViewControllers.

Any ViewController can be presented, pushed or made into the root ViewController from any other ViewController due to the removal of coupling from ViewControllers to the navigation logic.

All navigation is handled in ViewModels, rather than ViewControllers. This makes it much easier to add unit tests for navigation and moves navigation into business logic, rather than display logic.

The navigation is handled through the SceneCoordinator object which is passed around the app using Dependency Injection.

### DataManager
The DataManager class handles the retrieval of data from both a persistence store and the API. It retrieves a cached version of the data requested, then follows up with results from the API when the network request has completed.

The flow of data within DataManager is delegated to two services:
#### RealmPersistenceMangager
Two functions:  

* Retrieves existing, cached data from a Realm database.  
* Caches passed data into the Realm database.

When caching data, the PersistenceManager converts internal model objects into Realm objects. This reduces the amount of Realm specific code throughout the codebase therefore reducing coupling.

#### APIService
Pulls data from the JSONPlaceholder API and parses into model objects.

## Unit tests

Due to time constraints, I have been unable to add as many tests as I would have liked.  
I have included a few unit tests for PostVM, demonstrating how I would unit test using TestSchedulers and RxBlocking.  
I have also included basic mock implementations for DataManager and NavigationHandler, which can be used in tests to simulate live data flow.

## TODOs
All TODO comments left in the code were due to time constraints.

- Add integration test scheme
