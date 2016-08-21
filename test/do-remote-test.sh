. remote-support.sh

verbose_level=3

startCommandCapture

queueCommand ls /tmp

queueCommand pwd

invokeQueuedCommands agriman.local

clearQueuedCommands

invokeRemoteCommand agriman.local ls -al /home/dsieh
