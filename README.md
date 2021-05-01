# GMod OG Loading Screen

My goal was to reproduce [this old GMod loading screen](https://steamcommunity.com/sharedfiles/filedetails/?id=17641278) in a customizable and slightly expanded way.

![alt txt](https://i.imgur.com/pGci0sq.png)

This style was used during GMod 10 and all servers had it. At the time it wasn't possible to have different load screens.

I decided to distribute this code in the form of an addon to facilitate access as much as possible, so just add it to your collection/account and set the options through the game menu:

[Workshop link](https://steamcommunity.com/sharedfiles/filedetails/?id=2471861417)

![alt txt](https://i.imgur.com/CeoN6h7.png)

But, of course, you can host and modify it at will!

To do this just upload the contents of the "host" folder to your website and connect the index.html link to your GMod server with the sv_loadingurl command.

You can control the screen features by using the full link.

Like this:

```
sv_loadingurl "https://mysite.com/host/index.html?img=&floating=1&box=0&boxLines=1&boxIconsPerLine=60&boxAudio=false&messages=18&randMsgSecs=15&iconH=16&iconW=16"
```

"img=" requires requires links to be changed a bit. ``/`` turns into ``(47)``, ``http://`` into ``_1_`` and ``https://`` into ``_2_``.

e.g. ``https://i.imgur.com/EHU3ebQ.png`` turns into ``_2_i.imgur.com(47)EHU3ebQ.png``.

As a final note I'd like to recommend that you rename the **html** file to **php**. This will avoid caching problems as you make updates.

Changelog:

    Xalalau:

    - Add server name as title;
    - Add file counting and extra status as subtitle;
    - Add support to more file types, including ".gma" (workshop downloads);
    - Add support for icons with Width x Height greater than 16x16;
    - ChangeText(): finished + add support to control how often random messages appear;
    - UpdateText(): add support to control the number of messages to display + better gradient effect;
    - FileListing(): add "box" and "floating" icon modes, which can work together;
    - Improve the random messages;
    - Add debug and simulation functions;
    - Expose the most important settings;
    - Host the screen for everyone to use;
    - Add a Workshop addon to be the interface.
    
    Robotboy655:

    - [Original code](https://web.archive.org/web/20160716010825/https://facepunch.com/showthread.php?t=1275062) (which was a draft)
    
