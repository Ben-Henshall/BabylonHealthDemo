# babylon-health-demo

https://github.com/Babylonpartners/iOS-Interview-Demo/blob/master/demo.md

## Installation

This project uses Carthage to install dependencies. Rather than using the traditional "Carthage update" method, it uses the lightweight method of --no-build.

To update the dependencies, use:
`carthage update --use-submodules --no-build`

The dependencies are built in the BabylonHealthDemo workspace. USE THIS WORKSPACE TO BUILD AND EXECUTE THE PROJECT.

# Design

## SceneCoordinator

A simplified version of the co-ordinator pattern. Unlike the typical co-ordinator implementations, this does not have child co-ordinators and  removes any dependencies between separate ViewControllers.

Any ViewController can be presented, pushed or made into the root ViewController from any other ViewController due to the removal of coupling from ViewControllers to the navigation logic.

All navigation is handled in ViewModels, rather than ViewControllers. This makes it much easier to add unit tests for navigation and moves navigation into business logic, rather than display logic.

The navigation is handled through the SceneCoordinator object which is passed around the app using Dependency Injection.

This pattern was presented to me in the RxSwift book by RayWenderlich.
