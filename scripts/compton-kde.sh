#!/usr/bin/env sh


#### Starts compton on kde-openbox session
#### V.0.1 2020-01-03

## Terminates any running compton session
killall -q compton

## Wait until the processes have been shut down
while pgrep -u $UID -x compton > /dev/null; do sleep 1; done

desktop=$(echo $DESKTOP_SESSION)

if [ "$desktop" == '/usr/share/xsessions/openbox-kde' ] ; then
    /usr/bin/compton -b --config $HOME/.config/compton/compton.conf
fi

###EOF
