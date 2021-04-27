<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
    </head>
    <body style='overflow: hidden; background-color: #FFFFFF;'>
        <div style='text-align: center; top: 0px; left: 0px; right: 0px; height: 50px; overflow: show; font-family: Arial; font-size: 24px; font-weight: bold; color: #000' id='infos'>
        </div>

        <div style='text-align: center; top: 40px; left: 0px; right: 0px; height: 50px; overflow: show; font-family: Arial; font-size: 24px; font-weight: bold; color: #888' id='files'>
        </div>

        <div style='position: absolute; width: 100%; height: 350px;' id='floating_icons'></div>
        <span style="position: absolute;" id="floating_degub"></span>

        <div style='top: 100px; margin: 0 auto; overflow: hidden;' id='icons_box'>
          <div style='position: relative; float: right; right: 50%;'>
                <div style='position: relative; float: right; right: -50%;' id='icons'>
                </div>
            </div>
        </div>

        <div style="text-align: center;">
            <div style='padding-top: 30px; top: 0; right: 0; bottom: 0; left: 0; width: 50%; height: 50%; margin: auto; overflow: show;'>
                <img src='loading.png'>
                <div id='loadingtext' style='margin-top: 10px; color: #666; font-family: Arial; font-size: 12px; font-weight: bold;'>Waiting for updates...</div>
            </div>
        </div>

        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js"></script>
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/jquery-ui.min.js"></script>

        <script type="text/javascript">
            //  ------------------------------------- //
                // Number of messages that we can see bellow the GMod logo 
                var MESSAGES = 18;
                // Random messages will appear after this time, but it allways goes back to 0 when a new download starts
                var SECONDS_FOR_RANDOM_MESSAGES = 15;
                // Plays audio when a download starts
                var AUDIO = true;
                // Icons Width x Height
                var ICONS_WIDTH = 16;
                var ICONS_HEIGHT = 16;

                // Animations:

                // Floating icons
                var FLOATING_ICONS = true;

                // Icons poping in a box
                var ICONS_BOX = true;
                    // Number of icons per line
                    var ICONS_PER_LINE = 30;
                    // Number of lines
                    var LINES = 7;

            //  ------------------------------------- //

            var keywords = [
                "Unwelding Boxes", 
                "Charging Toolgun", 
                "Breaking Addons", 
                "Stuffing Ragdolls", 
                "Loading JBMod", 
                "Refuelling Thrusters", 
                "Unknotting ropes",
                "Painting Barrels",
                "Feeding Birds",
                "Bathing Father Grigori",
                "Decoding Lua's syntax",
                "Re-killing Alyx",
                "Calibrating Manhacks",
                "Cleaning Leafblower",
                "Reconfiguring Gravity Matrix",
                "Growing Watermelons",
                "Mowing Grass",
                "Plastering Walls",
                "Inflating Balloons",
                "Awaiting City17's orders",
                "Calling Sleep( 1000 );",
                "Unfreezing The Freeman",
                "Patching Broken Update",
                "Styling Mossman's Hair",
                "Reducing lifespan of G-Man",
                "Polishing Kleiner's Head",
                "Delaying Half-Life 3",
                "Changing Physgun Batteries",
                "Breaking Source Engine"
            ]
            
            var iconFolder = "icons/";

            var ext = [];
            
            ext['png'] = "picture.png";
            ext['vtf'] = "picture.png";
            ext['vmt'] = "page_white_picture.png";
            
            ext['wav'] = "sound.png";
            ext['mp3'] = "sound.png";
            ext['ogg'] = "sound.png";
            
            ext['txt'] = "page_white_text.png";
            ext['htm'] = "page_white_world.png";
            ext['tml'] = "page_white_world.png"; // html
            
            ext['bsp'] = "world.png";
            ext['ain'] = "world_add.png";
            
            ext['ttf'] = "font.png";
            ext['otf'] = "font.png";

            ext['mdl'] = "brick.png";            
            ext['vvd'] = "brick_add.png";
            ext['vtx'] = "brick_add.png";
            ext['phy'] = "brick_add.png";

            ext['.db'] = "database.png";

            ext['wlo'] = "package.png"; // Fake extension for Workshop Loading
            ext['wdo'] = "package_go.png"; // Fake extension for Workshop Downloading

            ext['generic'] = "box.png";

            ext['dbg'] = "cancel.png"; // Debug

            var audio = [];
            audio[0] = new Audio('push.wav');
            audio[1] = new Audio('push.wav');
            audio[2] = new Audio('push.wav');
            audio[3] = new Audio('push.wav');
            audio[4] = new Audio('push.wav');
            audio[5] = new Audio('push.wav');
            audio[6] = new Audio('push.wav');
            var audioIncrement = 1;

            var msg = [];
            for (i=1; i<=MESSAGES; i++)
                msg[i] = "";

            var time = 0;

            var iconArray = "";
            var iconIncrement = 0;

            var FilesNeeded = 0;
            var FilesTotal = 0;
            var RunningWorkshop = true;
            var Downloading = false;

            document.getElementById("icons_box").style.height = ICONS_HEIGHT * LINES + LINES + 'px';
            document.getElementById("icons_box").style.width = ICONS_WIDTH * ICONS_PER_LINE + ICONS_PER_LINE * 2 + 'px';

            // ----------------------------------------------------------------------------------
            // General --------------------------------------------------------------------------
            
            function GetExtension(str, n) {
                if (n <= 0)
                    return "";
                else if (n > String(str).length)
                    return str;
                else {
                    var iLen = String(str).length;
                    return String(str).substring(iLen, iLen - n);
                }
            }

            // ----------------------------------------------------------------------------------
            // Icons Box ------------------------------------------------------------------------

            if (ICONS_BOX) {
                function FileListing(filename) {
                    var icon = "";
                    var iconID = "icon" + iconIncrement;
                    var extension = GetExtension(filename, 3);

                    if (extension in ext)
                        icon = iconFolder + ext[extension];
                    else
                        icon = iconFolder + ext["generic"];

                    iconArray = '<img id="' + iconID + '" style="float: left; width: ' + ICONS_WIDTH + 'px; height: ' + ICONS_HEIGHT + 'px; padding: 1px 2px 0 0;" src="' + icon + '"/>' + iconArray;

                    document.getElementById("icons").innerHTML = iconArray;

                    document.getElementById(iconID).style.height = '0px';
                    document.getElementById(iconID).style.width = '0px';

                    $("#" + iconID).animate({height: ICONS_HEIGHT + "px", width: ICONS_WIDTH + "px"});
                    
                    iconIncrement++;

                    if (AUDIO) {
                        audio[audioIncrement].play();

                        audioIncrement++;

                        if (audioIncrement == 7)
                            audioIncrement = 0;
                    }
                }
            }

            // ----------------------------------------------------------------------------------
            // Floating Icons -------------------------------------------------------------------

            if (FLOATING_ICONS) {
                function GetCurrentTime() {
                    return new Date().getTime() / 1000;
                }

                function Lerp(delta, from, to) {
                    if (delta < 0) return from;
                    if (delta > 1) return to;
                    return from + (to - from) * delta;
                }

                function SetFloatingIcon(filename, debug) {
                    var icon = "";
                    var debug = false;
                    var extension = GetExtension(filename, 3);

                    if (extension == "dbg")
                        debug = true;

                    if (extension in ext)
                        icon = iconFolder + ext[extension];
                    else
                        icon = iconFolder + ext["generic"];

                    var iconElement = document.createElement("img");
                    iconElement.style.width = "16px";
                    iconElement.style.height = "16px";
                    iconElement.style.position = "absolute";
                    iconElement.style.marginLeft = "-100px";
                    iconElement.style.zIndex = "1";
                    iconElement.src = icon;
                    document.getElementById("floating_icons").appendChild(iconElement);

                    var distance = Math.random() * 300;
                    var baseY = document.getElementById("floating_icons").offsetHeight - distance;
                    var maxY = (1 - Math.random() * 0.5) * 128;
                    var speed = 50 * (1 - Math.random() * 0.5);
                    var startTime = GetCurrentTime();
                    var endTime = startTime + speed * 0.5;

                    if (debug)
                        var time = 0;

                    var timer = setInterval(function () {
                        if (debug)
                            time++;

                        var currentTime = GetCurrentTime();

                        var delta = (currentTime - startTime) / (endTime - startTime);

                        var x = Lerp(delta, -62, document.getElementById("floating_icons").offsetWidth);
                        var y = baseY - maxY + Math.sin(x * 0.01) * maxY/2;

                        iconElement.style.marginTop = y;
                        iconElement.style.marginLeft = x;

                        if (debug)
                            document.getElementById("floating_degub").innerHTML = "<br/><br/><br/><br/><br/><br/>Timer: " + time + "<br/>Delta: " + delta + "<br/> Time: " + startTime + "/" + endTime + "<br/> Speed: " + speed + "<br\>Pos x/y: " + x + "/" + y + "<br/> Distance: " + distance + "<br/>MaxY: " + maxY;

                        if (delta > 1.01) {
                            if (Downloading == filename) {
                                startTime = GetCurrentTime();
                                endTime = startTime + speed * 0.5;
                            } else
                                clearInterval(timer);
                        }
                    }, 0.1)
                }

                // Test SetFloatingIcon()
                // Start debug
                //SetFloatingIcon(".dbg", true);
                //Downloading = ".dbg";
                //FileListing(".dbg");
                // End debug
            }

            // ----------------------------------------------------------------------------------
            // Change Text ----------------------------------------------------------------------

            function UpdateText(text) {
                var str = "";
                var i;
                
                for (i=MESSAGES; i>=2; i--)
                    msg[i] = msg[i-1];

                msg[1] = text;

                for (i=1; i<=MESSAGES; i++)
                    str = str + '<span style="color: ' + 'hsl(0, 0%,' + 100*(1-(1/MESSAGES)*(MESSAGES-i)) + '%)' + ';">' + msg[i] + '</span><br/>';
                
                document.getElementById("loadingtext").innerHTML = str;
            }

            function ChangeText() {
                setTimeout(function () {
                    time++;

                    if (time > SECONDS_FOR_RANDOM_MESSAGES) {
                        var keyword = keywords[Math.floor(Math.random() * keywords.length)];
                        UpdateText(keyword);
                        time = 0;
                    }

                    ChangeText();
                }, 1000)
            }

            function RefreshFileBox(text) {
                if (FilesNeeded != 0)
                    document.getElementById("files").innerHTML = text || FilesNeeded + " files needed"; 
            }

            // ----------------------------------------------------------------------------------
            // GMod Functions -------------------------------------------------------------------

            function GameDetails(servername, serverurl, mapname, maxplayers, steamid, gamemode) {
                document.getElementById("infos").innerHTML = servername;
            }

            function SetFilesNeeded(Needed) {
                FilesNeeded = Needed;
                RefreshFileBox();
            }

            function SetFilesTotal(iTotal) {
                FilesTotal = iTotal;
                RefreshFileBox();
            }

            function DownloadingFile(filename) {
                FilesNeeded--;

                if (FilesNeeded == 0 || isNaN(FilesNeeded))
                    FilesNeeded = "( ͡° ͜ʖ ͡°) 0";

                RefreshFileBox();

                UpdateText("Downloading " + filename);

                time = 0;

                if (RunningWorkshop)
                    filename = filename + ".wdo";

                if (Downloading) {
                    if (ICONS_BOX)
                        FileListing(Downloading);

                    Downloading = false;
                }

                Downloading = filename;

                if (FLOATING_ICONS)
                    SetFloatingIcon(filename);
            }

            function SetStatusChanged(status) {
                if (status == "Mounting Addons")
                    RunningWorkshop = false;
 
                 if (status == "Received all Lua files we needed!")
                    RefreshFileBox(keywords[Math.floor(Math.random() * keywords.length)]);

                if (Downloading) {
                    if (ICONS_BOX)
                        FileListing(Downloading);

                    Downloading = false;
                }

                if (RunningWorkshop) {
                    FilesNeeded--;

                    if (FilesNeeded == 0 || isNaN(FilesNeeded))
                        FilesNeeded = "( ͡° ͜ʖ ͡°) 0";

                    RefreshFileBox();

                    var id = status + ".wlo";

                    Downloading = id;

                    if (FLOATING_ICONS)
                        SetFloatingIcon(id);

                    status = status.replace(/\d.*?\-/g, ''); // Remove the counting and total size
                }

                UpdateText(status);
                time = 0;
            }

            RefreshFileBox();
            ChangeText();
        </script>
    </body>
</html>
