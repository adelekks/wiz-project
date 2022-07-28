#!/bin/bash
sudo cat << EOF > /etc/yum.repos.d/mongodb-org-3.0.repo
[mongodb-org-3.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/3.0/x86_64/
gpgcheck=0
enabled=1
EOF
sudo yum install -y mongodb-org
sudo systemctl start mongod
sudo systemctl status mongod
sudo systemctl enable mongod

## Adding Data to / Reading Data from a MongoDB Database 
cat << EOF > /opt/mongodb.js
//create the names collection and add documents to it
db.names.insert({'name' : 'Kenny Adeleke'});
db.names.insert({'name' : 'Peter Campbell'});
db.names.insert({'name' : 'Betty Draper'});
db.names.insert({'name' : 'Joan Harris'});

//set a reference to all documents in the database
allMadMen = db.names.find();

//iterate the names collection and output each document
while (allMadMen.hasNext()) {
   printjson(allMadMen.next());
}
EOF

## Create script to collect data
cat >> EOF > /opt/collect-data.js
//set a reference to all documents in the database
allMadMen = db.names.find();

//iterate the names collection and output each document
while (allMadMen.hasNext()) {
   printjson(allMadMen.next());
}
EOF

mongo /opt/mongodb.js

