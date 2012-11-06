#!/bin/sh

# launch xmonad, with a couple of dzens to run the status bar
# send xmonad state over a named pipe

COLORIZE='/home/arrakis/scripts/colorize.rb'

FG='#cccccc'
BG='black'
FONT="-*-terminus-*-r-*-*-12-*-*-*-*-*-*-*"

# with a pipe talking to an external program
PIPE=$HOME/.xmonad-status
rm -f $PIPE
PATH=${PATH}:/sbin mkfifo -m 600 $PIPE
[ -p $PIPE ] || exit

while true; do
    MPD=`mpc --format "[%artist% - %date% - %album% - %track% - %title% - %time%]|%file% - %time%" | head -n1`
    echo $MPD
    sleep 10
done | dzen2 -e '' -xs 1 -x 125 -y 888 -w 1315 -ta l -fg $FG -bg $BG -fn $FONT &

function get_sensors_readings () {
	sensors=`sensors`
	CPUF=`echo $sensors | grep 'fan1:\ *[0-9]* RPM' -o | sed -e s/\ \ */_/g | cut -d_ -f2`
	MBT=`echo $sensors | grep 'temp1:\ *+[0-9]\{2\}..°C' -o | sed -e s/\ \ */_/g | cut -d_ -f2 | sed -e s/°C//`
	CPUT=`echo $sensors | grep -e 'temp2:\ *+[0-9]\{2\}..°C' -o | sed -e s/\ \ */_/g | cut -d_ -f2 | sed -e s/°C//`
	eval "$1='`ruby $COLORIZE "$CPUF" "1500" "1000" ">" "RPM"`'"
	eval "$2='`ruby $COLORIZE "$MBT" "50" "70" "<" "°C"`'"
	eval "$3='`ruby $COLORIZE "$CPUT" "50" "70" "<" "°C"`'"
}

function get_mem_usage () {
    mem_use=`free -m | grep $2 | sed -e s/\ \ */_/g`
    memused=`echo $mem_use | cut -d_ -f3`
    memfree=`echo $mem_use | cut -d_ -f4`
	memtot=$(( $memused + $memfree ))
	eval "$1='`ruby $COLORIZE "$memused.0/$memtot.0" "0.5" "0.75" "<" "MiB" "$memused/$memtot"`'"
}

function get_sdX_temp () {
	temp=`hddtemp /dev/$1 | sed -e s/\ \ */_/g | cut -d_ -f4 | sed -e s/°C//`
	eval "$1='`ruby $COLORIZE "$temp" "50" "60" "<" "°C"`'"
}

function get_mount_usage () {
	df_h=`df -h | grep $1 | sed -e s/\ \ */_/g`
	disku=`echo $df_h | cut -d_ -f3 | sed -e s/G//`
	diskt=`echo $df_h | cut -d_ -f2 | sed -e s/G//`
	case `echo "$disku<10" | bc` in
		0) eval "$1='`ruby $COLORIZE "$disku.0/$diskt.0" "0.5" "0.75" "<" "GiB" "$disku/$diskt"`'"
	 ;; 1) eval "$1='`ruby $COLORIZE "$disku/$diskt.0" "0.5" "0.75" "<" "GiB" "$disku/$diskt"`'"
	 ;; esac
}

while true; do
    LOAD=`uptime | cut -d, -f3- | cut -d: -f2`
    LOADN=`echo $LOAD | cut -d, -f1`
	get_sensors_readings "cpu_fan" "mobo_temp" "cpu_temp"
	get_mem_usage "ram" "buffers/cache"
	get_mem_usage "swap" "Swap:"
	get_sdX_temp "sda"
	get_mount_usage "home"
	get_sdX_temp "sdb"
	get_mount_usage "data1"
	get_sdX_temp "sdc"
	get_mount_usage "data2"
    UPTIME=`uptime | cut -d, -f1 | cut -d" " -f4-`
    DATE=`date +"%a %Y-%m-%d %H:%M %Z"`
	echo `ruby $COLORIZE "$LOADN" "1.5" "4.0" "<" "" "$LOAD"` "|" $cpu_temp $cpu_fan "|" $mobo_temp "|" $ram "|" $swap "|" $sda $home "|" $sdb $data1 "|" $sdc $data2 "|" $UPTIME "|" $DATE
    sleep 60
done | dzen2 -e '' -xs 2 -y 756 -w 1024 -ta r -fg $FG -bg $BG -fn $FONT &

# and a workspace status bar
dzen2 -e '' -xs 1 -w 125 -y 888 -ta l -fg $FG -bg $BG -fn $FONT < $PIPE &

# go for it
xmonad > $PIPE &

# wait for xmonad
wait $!

pkill -HUP dzen2
