#!/bin/bash

DATE=$(date +%F)
LOGDIR=/tmp
LOGFILE=$LOGDIR/$0-$DATE.log
cartID=$(id -u)
R="\e[31m"
G="\E[32m"
N="\e[0m"
Y="\e[33m"

if [ $cartID -ne 0 ];
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

yum install nginx -y &>>$LOGFILE

VALIDATE $? "Installing Nginx"

systemctl enable nginx &>>$LOGFILE

VALIDATE $? "Enabling Nginx"

systemctl start nginx &>>$LOGFILE

VALIDATE $? "Starting Nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE

VALIDATE $? "Removing default index html files"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>$LOGFILE

VALIDATE $? "Downloading web build"

cd /usr/share/nginx/html &>>$LOGFILE

VALIDATE $? "Moving to default html directory"

unzip /tmp/web.zip &>>$LOGFILE

VALIDATE $? "Unzipping web artifacts"

cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$LOGFILE

VALIDATE $? "Copying roboshop config"

systemctl restart nginx &>>$LOGFILE

VALIDATE $? "Restarting Nginx"