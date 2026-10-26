# In-Class Activity 10: Signup Form App

- **Track**: Undergraduate
- **Task**: Task A (Local AI Signup Coach Simulation)
- **Author**: Adi Tauqir

## Pre-Coding
For the pre-coding architecture, the local tip coach utilizes a fixed category labeled `password_help` that maintains a preset collection of advisory strings in a local list (`_demoTips`) rather than issuing network requests to an external service. Upon tapping the action button, `_fetchLocalTip()` increments an internal counter and applies modulo arithmetic (`_tipIndex % _demoTips.length`) to sequentially cycle through the tips. To protect user confidentiality and security, the tip feature operates completely decoupled from form state, deliberately never accessing, reading, or transmitting values entered into `_passwordController`, `_emailController`, or `_nameController`.

## Test Cases
- **Empty Form Submission**: I attempted submission with all fields blank and verified that all three inline error messages appeared ("Please enter your name", "Please enter your email", and "Please enter a password"), ensuring submission was blocked without displaying a SnackBar.
- **Malformed Email Validation**: I entered a valid name, an invalid email address lacking an `@` symbol ("hello"), and a password, and verified that the email field displayed "Please enter a valid email" and blocked submission.
- **Password Length Constraint**: I entered a password containing fewer than 6 characters ("123") and verified that the validator displayed "Password must be at least 6 characters" and blocked submission.
- **Valid Form Submission**: I entered valid credentials ("Adi Tauqir", "noorwastaken@adi.com", "myverygoodpassword123#") and verified that all validators passed and the green confirmation SnackBar successfully appeared.
- **Local Tip Display Flow**: I tapped "Get a signup tip" and verified that the simulated loading indicator ("Loading demo tip...") displayed briefly before rendering the preset demo tip labeled to indicate no live AI was called.
- **Error State and Retry Flow**: I exercised the simulated error state on the tip action, verified that the error message ("Could not load tip. Tap retry.") and retry action appeared, then tapped "Retry" and verified that the tip loaded successfully.

## Track-Based Critical Thinking

### Why must the app keep form validation local even when it can ask an AI for a tip? Give one example of a bad decision if AI were allowed to approve signup.
Form validation must remain strictly local within the `Form` widget's `_formKey.currentState!.validate()` invocation and its synchronous `validator` callbacks (such as `value.trim().isEmpty` for name, `!value.contains('@')` for email, and `value.length < 6` for password). These local validators execute synchronously, deterministically, and offline without external failure modes. In contrast, `_fetchLocalTip()` is asynchronous (`Future.delayed`) and designed purely for optional advisory assistance. If account signup approval were delegated to an external or simulated AI model instead of local validators, the non-deterministic model could make a catastrophic decision: for example, hallucinating approval on an empty password input because the name field appeared friendly, or rejecting a valid email address because it did not recognize a novel top-level domain, thereby bypassing `_formKey` constraints and erroneously triggering the success `SnackBar`.

### Which fixed local category selects the tip, and what form information does the feature deliberately ignore? Why?
The tip simulation exclusively references the static local category `password_help`, declared inside `_fetchLocalTip()` to select recommendations from the `_demoTips` list via `_demoTips[_tipIndex % _demoTips.length]`. It deliberately ignores all values stored in `_nameController.text`, `_emailController.text`, and `_passwordController.text`. When the user taps the `ElevatedButton` to invoke `_fetchLocalTip()`, the method takes no arguments referencing these text controllers. This strict architectural boundary prevents sensitive credentials—particularly plaintext from `_passwordController` and personally identifiable information from `_emailController`—from ever being processed, logged, or exposed to advice logic, ensuring complete privacy and isolation between user inputs and the coaching mechanism.
