# agents.md


## Project Overview
This project is a modern iOS application built in Xcode using Swift and SwiftUI.
The architecture follows MVVM.
The app integrates Apple Foundation Models for intelligent features such as summarization, generation, and classification. 
- The Main App will gather context information from different applications but in the begining only from text files in the /Documents/Context directory. 
- The Main app will present a Navigation toolbar at the bottom of the screen to show the following screens.
- tab 1 is a editable Text field called about me 
- tab 2 will be called Gather whic will present a list of Apps to include Notes.app , Journal.app , Photos.app that inforamtion can be gathered from.On selecting any pf these the app will change to show an enable switch for each app and other preferneces to be added later 
- tab 3 will include a list of text notifications that the app will prompt the user to take actions when in the app. 

## Messages Extension 
- The Project will also include a Messages extension target that shows a list of AI generated options in reposne to a Text arriving.
-   The Messages Extension will access the Apple Foundation Models to generate a response. This service will be shared with the Main app and 
The foundation model access portion should be moved into a shared service that will be:
- Implemented behind an `AIService` protocol
- Provided by a concrete `FoundationModelsService`
- Injected via a lightweight `AppContainer` into ViewModels (constructor injection)
- Reused by both the Main app and the Messages extension

---

## Platform & Tooling
- Use the latest stable Swift version supported by Xcode.
- Prefer modern Apple APIs over legacy approaches.
- Target iOS 18+ unless otherwise specified.
- Avoid deprecated APIs and backward-compatible workarounds unless explicitly requested.

---

## Core Development Principles
- Use SwiftUI as the primary UI framework.
- Avoid UIKit unless absolutely necessary.
- Use structured concurrency (`async` / `await`).
- Prefer `@MainActor` and actor isolation where appropriate.
- Prefer value types (`struct`) over reference types (`class`).
- Avoid force unwrapping.
- Use strong typing instead of loosely typed data structures.

---

## SwiftUI Rules
- Use `NavigationStack` instead of `NavigationView`.
- Build fully state-driven UI.
- Keep Views lightweight and declarative.
- Use `.task`, `.refreshable`, and modern modifiers.
- Break UI into small reusable components.
- Do not place business logic in Views.

---

## MVVM Architecture Rules

### Views
- Responsible only for rendering UI and forwarding user actions.
- Bind directly to ViewModel state.
- Contain minimal logic (presentation only).

### ViewModels
- Own all UI state.
- Handle async workflows and orchestration.
- Expose intent-based methods:
  - `load()`
  - `submit()`
  - `summarizeText()`
- Transform service data into UI-ready state.

### Models
- Use strongly typed Swift models.
- Conform to `Codable` where appropriate.

### Services
- Handle:
  - Foundation Models interactions
  - Networking
  - Persistence
- Must be abstracted and testable.
- Never called directly from Views.

---

## State Management
- Prefer modern Observation framework (`@Observable`) when supported.
- Use:
  - `@State`
  - `@Binding`
  - `@Environment`
- Avoid excessive use of `@StateObject`.
- Avoid global mutable singletons.

---

## Foundation Models Integration
- Use Apple Foundation Models APIs for AI capabilities.
- Encapsulate all model interactions inside a dedicated service layer.
- Never call model APIs directly from Views.
- Separate concerns:
  - Prompt construction
  - Model invocation
  - Response parsing
  - UI state updates

- Handle:
  - Availability checks
  - Errors
  - Fallback behavior

- Prefer:
  - Strongly typed request/response models
  - Testable and mockable service design

---

## Dependency Injection
- Use constructor injection for ViewModels.
- Keep dependencies explicit.
- Prefer protocol-based abstractions for services when beneficial.
- Avoid hidden global state.

---

## Networking & Data
- Use `URLSession` with `async` / `await`.
- Use `Codable` for parsing.
- Handle errors explicitly.
- Prefer small, focused service types.

---

## Error Handling
- Do not swallow errors.
- Surface user-friendly messages in UI.
- Preserve underlying technical errors for debugging.
- Represent errors explicitly in ViewModel state.

---

## Testing
- Use XCTest.
- Test ViewModels and Services.
- Mock Foundation Models via protocols or test doubles.
- Focus on:
  - Business logic
  - State transitions
  - Error handling

---

## Code Style
- Produce complete, compilable Swift code.
- Prefer clarity over brevity.
- Use `guard` for early exits.
- Avoid force unwraps.
- Keep functions small and focused.
- Use extensions for organization.
- Prefer immutability.
- Comment only when necessary for clarity.

---

## What to Avoid
- UIKit-first implementations
- Storyboards or XIBs
- Deprecated APIs
- Completion handlers instead of async/await
- Massive Views with embedded logic
- Direct Foundation Models usage in Views
- Singleton-heavy architecture
- Placeholder or incomplete code

---
## Scaffolding Rules
- When asked to create a feature, screen, or app:
  → Always generate full scaffolding.

- Scaffolding must include:
  - SwiftUI View
  - ViewModel
  - Models (if applicable)
  - Service layer (if Foundation Models or networking is involved)
  - Dependency injection setup

- Do not generate isolated files when multiple layers are required.

- Ensure:
  - Code compiles
  - All layers are connected
  - MVVM responsibilities are respected

---

## Scaffolding Trigger Behavior
If the user asks for:
- "create an app"
- "build a feature"
- "generate a screen"
- "scaffold"

Then:
→ Automatically generate full scaffolding.

- Do not default to minimal examples.
- Prefer complete implementations.

---

## Feature Template (MVVM)

Each feature must include:

- View
  - UI layout
  - Binds to ViewModel
  - Sends user actions

- ViewModel
  - Marked with `@Observable` when supported
  - Holds state
  - Handles async logic
  - Exposes intent methods

- Service (if needed)
  - Handles Foundation Models or networking
  - Abstracted for testing

- Models
  - Strongly typed data structures

---

## App Scaffolding Expectations

When generating a new app, include:

- App entry point (`@main`)
- Root View using `NavigationStack`
- At least one fully implemented feature
- Dependency injection setup
- Example Foundation Models integration (if relevant)
- Fully runnable project code
- No placeholders or missing pieces

---


## File & Folder Conventions

Preferred structure:

- App/
- Views/
- ViewModels/
- Models/
- Services/
- Dependencies/
- Utilities/
- Tests/

Alternative feature-based structure:

FeatureName/
- FeatureNameView.swift
- FeatureNameViewModel.swift
- FeatureNameService.swift
- FeatureNameModels.swift

---


## Output Expectations for the Agent
- Always generate complete, compilable Swift code.
- Prefer SwiftUI + MVVM by default.
- Use modern Apple-recommended APIs.
- Prefer Observation framework over older patterns when available.
- Prefer async/await over callbacks.
- Prefer full structure over minimal examples.
- Include all necessary files when generating features or apps.

---

## Default Assumptions
Unless specified otherwise:
- SwiftUI is the UI framework
- MVVM is required
- iOS 18+ is targeted
- Observation framework is preferred
- Foundation Models should be used for AI-related functionality
- Structured concurrency is required

---

## Key Instruction
When multiple valid approaches exist:
→ Always choose the most modern Apple-recommended solution.

