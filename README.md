# BashScript2

EPAM Final Task. Bash Script №2

Task:
Write a bash script
•	Script2 works in detached mode and starts at system boot
•	Script2 has /var/run/script_name.pid (should not be run by a second instance)
•	Script2 Must be configurable (ENV, configuration, etc.)
•	Script2 checks /local/backups and sends mail to root according to its configuration (a or b points):
•	number of files in /local/backups directory is more than X
•	total size of /local/backups directory is more than Y bytes
