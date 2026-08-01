# Tasker

An app that notifies you when you need to do something.


## Warning !!!

Tasker is still in development. It's not working yet but it's slowing getting there ! I'm doing this in my free time and i don't have much of it currently so don't expect a viable version soon.


## Features (Work in Progress)

- Store your task
- Be notified of an incomming task 
- Get a notification at the start of the day telling you what you'll have to do today 
- Schedule you Task periodically (Weekly, Monthly, Yearly)
- Calendar view of you tasks

## Platforms 

Task is meant to be mobile app, meaning it's supposed to target both Android and IOS.

However, i don't have the required hardware to develop apps for IOS (Thanks Apple !) so i won't offer any support nor binaries for this platform. 

But in theory, it should also work on IOS. If you want to try it on your Apple device, fell free to compile the project yourself. See [flutter's official website](https://docs.flutter.dev/install/quick) for more details.

## Installing the app on your system

No binaries available as the app is still in development, but you'll find the `apk` in the release tab as soon as it's finished.


## Getting Started

If you want to run the project from the source code, you will need to install the flutter sdk.

Once it's correctly installed you can run it on your system by entering :

```console
flutter run
```
in your terminal.

You can also build an apk (for android) with :

```console
flutter build apk
```

## Languages

Tasker is meant to be available in both **English** and **French**. I'm working alone on this so i don't have a team nor the time to work on other translation and it's not intended to have more. That's why translation mechanism of the app is so simple. It's just a json file in `assets/lang`. To add another language to the app simply create an other file in the directory following the pattern `textes_{LOCALE}.json` replacing `{LOCALE}` with the locale you want to add support for (ex : for Spanish, add `assets/lang/textes_es.json`) and complete it by mimicking how it's done in french. 

## Other 

This app came from a frustration i add with Google Calendar which did't always wanted to notify me want i add a task or an event comming soon. 

I share it here as it might interest someone. Feel free to fork it or do whatever you want with it.

If you want more more fetures, don't hesitate to open an issue, i'll work on it if it makes sense :)