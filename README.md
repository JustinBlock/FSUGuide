# FSUGuide

FSUGuide is an un-official iOS app created for students new to Florida State University. It pulls the FSU calendar of events in a neatly formatted layout as well as giving users a checklist of events to interact with. Among other features is a points system for using features on the app, a message board and a list of popular locations with Apple Maps integration. The iOS app was written in Objective-C and utilizes Apple Maps integration as well as Parse for the backend.

Not affiliated with FSU.

## Getting Started
This app requires a Parse backend in order to work. In AppDelegate.m find



        configuration.applicationId = @"INSERT-APPLICATION-ID";
        åç
        configuration.server = @"INSER-SERVER-URL";
        
        configuration.clientKey = @"INSERT-CLIENT-KEY";

and set the corresponding values. There are many websites out there to get free developer Parse hosting.
