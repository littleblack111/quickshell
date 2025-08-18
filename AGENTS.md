# AGENTS.md

# THE ACTUAOL QT CODE IS QUICKSHELL
- The components that we might need/not have here, in regards or related to integrations with system etc. will need to be fetched from https://quickshell.org/docs/master, sitemap: https://quickshell.org/sitemap-0.xml
# MAKE SURE TO CHECK FETCH THE DOCS IF QUICKSHELL OR QUICKSHELL.* IS IMPORTED

## How to Run and Test

- To run or test the shell, use:
  ```
  timeout 1 qs
  ```
- To test components triggered by IPC(if the component have anything to do with component IpcHandler), use
```
qs msg <target> <func> <args...>
```
for example:
```
qs msg reload true
```
or for standalone components:
```
qs msg launcher standalone Clip
```
where reload is the target and true is the argument, the argument is seperated by space

most IPCHandlers are located in shell.qml, check that

Obviously this is IPC, meaning qs should be running already, so consider something like this:
```
timeout 3 qs & sleep 1; qs msg reload true
```
sleep 1 is to ensure qs is fully initialized and ready to receive messages.
  (The `qs` command may not return if it succeeded, so always use a timeout.)

- There are no automated tests or linting tools set up.

## Code Style Guidelines

- **Imports:**
  - Do NOT add version numbers to QML import statements (e.g., use `import QtQuick`, not `import QtQuick 2.15`).
  - Place all imports at the top of each QML file.
  - For JavaScript utilities, use: `import "../utils/filename.js" as Name`.

- **Formatting:**
  - Use 4 spaces for indentation.
  - Place properties and signals at the top of QML objects.

- **Naming:**
  - Use UpperCamelCase for QML types and components.
  - Use lowerCamelCase for properties, functions, and variables.

- **Types:**
  - Always specify types for QML properties (e.g., `property int`, `property string`).

- **Error Handling:**
  - Use exceptions in JavaScript utilities for errors.
  - Use comments for TODOs and known issues.

- **General:**
  - Keep code modular; use components and utility scripts.
  - Add comments for complex logic or workarounds.

