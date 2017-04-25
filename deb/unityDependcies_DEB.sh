## Dependencies for running a Unity exe on deb linux

## If these do not work for you, then you can use the ldd command
## to list all dependcies that are needed. 

sudo apt-get install libgl1-mesa-glx-lts-utopic:i386

sudo apt-get install libxcursor1:i386

sudo apt-get install libxrandr2:i386

chmod +x /path/to/game.x86
