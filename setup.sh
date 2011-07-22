#!/bin/bash
sudo gem install sinatra rails erubis json -y
sqlite3 dbfile.sqlite3 < migration.sql