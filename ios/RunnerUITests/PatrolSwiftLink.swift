// Intentionally minimal.
//
// RunnerUITests is otherwise pure Objective-C (RunnerUITests.m). Firebase's
// precompiled Swift binaries force-load `swiftCompatibility56`, which recent
// Xcode no longer ships as a standalone library. An Objective-C-only target
// never links the Swift runtime that provides those force-load symbols, so the
// XCUITest build fails at link time with:
//   Undefined symbols: __swift_FORCE_LOAD_$_swiftCompatibility56
//
// Including a single Swift file forces the target to link the Swift runtime,
// which resolves the force-load symbols. The file needs no contents beyond a
// Foundation import.
import Foundation
