#!/bin/bash

DATE=$(date +%F)
LOGDIR=/tmp
LOGFILE=$LOGDIR/$0-$DATE.log
USERID=$(id -u)
R="\e[31m"
G="\E[32m"
N="\e[0m"
Y="\e[33m"

if [ $USERID -ne 0 ];
then
    echo -e "$R ERROR:: Please run this script with root access $N"
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

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOGDIR

validate $? "installing redis repo"

yum module enable redis:remi-6.2 -y &>>$LOGDIR

VALIDATE $? "enabling redis 6.2"

yum install redis -y &>>$LOGDIR

VALIDATE $? "installing redis 6.2"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>>$LOGDIR

VALIDATE $? "allowing remote connections to redis"

systemctl enable redis &>>$LOGDIR

VALIDATE $? "enabling redis"

systemctl start redis &>>$LOGDIR

VALIDATE $? "starting redis"
