# Studio Ghibli Films App

## What the app does
This iOS app is a simple **Studio Ghibli film guide** built with **SwiftUI**.  
It demonstrates the **Model–View–ViewModel (MVVM)** pattern and includes:

- A list of Studio Ghibli films with posters/banners
- Detailed view for each film (title, original titles, synopsis, director, producer, year, runtime, Rotten Tomatoes score)
- User feedback for loading states (`ProgressView`)
- Robust error handling for API/network failures (no crashes, friendly retry option)
- Clean, styled UI with gradients and card-like containers

## API
The app consumes the **Studio Ghibli API**:  
👉 [Films endpoint](https://ghibliapi.vercel.app/films)

## How to run the app

### Requirements
- **Xcode 15 (or later)**
- **iOS 17 target (or later)**
- Swift 5.9 (bundled with Xcode 15)

### Steps
1. Clone this repository
2. Open the project in Xcode
3. In Xcode, select a Simulator (e.g., iPhone 15).
4. Build & Run the project

The app will launch in the simulator and fetch films from the Studio Ghibli API.

## Notes
This project was built for a coursework assignment to demonstrate:
- SwiftUI layout
- Async/await for API calls
- MVVM architecture
- Error handling + user feedback
