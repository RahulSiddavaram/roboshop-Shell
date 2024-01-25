#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/tmp
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

USERID=$(id -u)

if [ $USERID -ne 0 ];
then 
    echo -e "$R ERROR :: PLEASE RUN the script WITH ROOT ACCESS $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ];
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else    
        echo -e "$2 ... $G SUCCESS $N"
    fi
}


cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "Copied MONGODB Repo into yum.repos.d"

yum install mongod-org -y &>> $LOGFILE

VALIDATE $? "Installation of mongo-org"

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "Enabling MongoDB"

systemctl start mongod &>> $LOGFILE

VALIDATE $? "Starting MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "Edited MongoDB Conf"

systemctl restart mongod &>> $LOGFILE

VALIDATE $? "Restarting MongoDB"