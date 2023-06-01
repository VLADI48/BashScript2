#!/bin/bash
#Developed by Bogatov Vladimir Vladimirovich

#The counter variable for if
if_time=0

#Configuration file
file="./config.txt"


#Checking the folder size and the number of files in the folder
pr_check(){
while true
do
    numls=$(ls /local/backups | tee | wc -l)
    echo $numls
    if (( numls > counts)) && (( if_time < 1 )) && [ $check_counts == "true" ]
    then
        log_time=$(date +%d.%m.%y-%k:%M:%S)
        echo "$log_time : Information! The number of files in the backups directory is $numls and it is greater than counts = $counts !" >> ./log.txt
        echo "The number of files in the backups directory is $numls and it is greater than counts = $counts !" | mutt -s "Attention!!!" -- "$email"
        if_time=send_time
    fi

    sizedu=$(du /local/backups -b -s | cut -d '	' -f 1)
    echo $sizedu
    if (( sizedu > size )) && (( if_time < 1 )) && [ $check_size == "true" ]
    then
        log_time=$(date +%d.%m.%y-%k:%M:%S)
        echo "$log_time : Information! The size of the backups folder is $sizedu and exceeds the specified $size !" >> ./log.txt
        echo "The size of the backups folder is $sizedu and exceeds the specified $size !" | mutt -s "Attention!!!" -- "$email"
        if_time=send_time
    fi

    if (( conf_time < 1 ))
    then
        echo "PROVERKA FAJLA! $conf_time"
        check_conf
    fi

    if_time=$(( $if_time - 1 ))
    conf_time=$(( $conf_time -1 ))
    sleep $check_time
done
}


#Checking for the presence of a configuration file and getting variables from it
check_conf(){
if [ -f ./config.txt ]
then
    conf_time=`cat ./config.txt | grep "^conf_time" | cut -d '=' -f 2`
    echo $conf_time
    if [ "$conf_time" == "" ]
    then
        log_time=$(date +%d.%m.%y-%k:%M:%S)
        echo "$log_time : The conf_time variable was not found in the configuration file! The script will be stopped and closed!" >> ./log.txt
        exit 1
    fi

    email=`cat ./config.txt | grep "^email" | cut -d '=' -f 2`
    echo $email
    if [ "$email" == "" ]
    then
        log_time=$(date +%d.%m.%y-%k:%M:%S)
        echo "$log_time : The email variable was not found in the configuration file! The script will be stopped and closed!" >> ./log.txt
        exit 1
    fi

    size=`cat ./config.txt | grep "^size" | cut -d '=' -f 2`
    echo $size
    if [ "$size" == "" ]
    then
        log_time=$(date +%d.%m.%y-%k:%M:%S)
        echo "$log_time : The size variable was not found in the configuration file! The script will be stopped and closed!" >> ./log.txt
        exit 1
    fi

    check_size=`cat ./config.txt | grep "^check_size" | cut -d '=' -f 2`
    echo $check_size
    if [ "$check_size" == "" ]
    then
        log_time=$(date +%d.%m.%y-%k:%M:%S)
        echo "$log_time : The check_size variable was not found in the configuration file! The script will be stopped and closed!" >> ./log.txt
        exit 1
    fi

    counts=`cat ./config.txt | grep "^counts" | cut -d '=' -f 2`
    echo $counts
    if [ "$counts" == "" ]
    then
        log_time=$(date +%d.%m.%y-%k:%M:%S)
        echo "$log_time : The counts variable was not found in the configuration file! The script will be stopped and closed!" >> ./log.txt
        exit 1
    fi

    check_counts=`cat ./config.txt | grep "^check_counts" | cut -d '=' -f 2`
    echo $check_counts
    if [ "$check_counts" == "" ]
    then
        log_time=$(date +%d.%m.%y-%k:%M:%S)
        echo "$log_time : The check_counts variable was not found in the configuration file! The script will be stopped and closed!" >> ./log.txt
        exit 1
    fi

    check_time=`cat ./config.txt | grep "^check_time" | cut -d '=' -f 2`
    echo $check_time
    if [ "$check_time" == "" ]
    then
        log_time=$(date +%d.%m.%y-%k:%M:%S)
        echo "$log_time : The check_time variable was not found in the configuration file! The script will be stopped and closed!" >> ./log.txt
        exit 1
    fi

    send_time=`cat ./config.txt | grep "^send_time" | cut -d '=' -f 2`
    echo $send_time
    if [ "$send_time" == "" ]
    then
        log_time=$(date +%d.%m.%y-%k:%M:%S)
        echo "$log_time : The send_time variable was not found in the configuration file! The script will be stopped and closed!" >> ./log.txt
        exit 1
    fi
else
    log_time=$(date +%d.%m.%y-%k:%M:%S)
    echo "$log_time : WARNING! The configuration file was not found! The script will be stopped and closed!" >> ./log.txt
    exit 1
fi

#checking the package status (dpkg) and look for its status (grep) in the output
package=$(apt-cache policy ssmtp | grep "Installed" )
if [ "$package" == "" ]
then
    log_time=$(date +%d.%m.%y-%k:%M:%S)
    echo "$log_time : WARNING! ssmtp not installed! The script will be stopped and closed!" >> ./log.txt
    exit 1
fi

pr_check
}


check_conf