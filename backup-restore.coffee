fs   = Npm.require('fs')
exec = Npm.require('child_process').exec
mongodbUri = Npm.require('mongodb-uri')
targz = Npm.require('tar.gz')
temp = Npm.require('temp')

# use `temp` to cleanup mongodump and mongorestore
temp.track()

# get database connection information from process
dbConn = mongodbUri.parse(process.env.MONGO_URL)

Meteor.backup = (callback) ->
  # create temp dir and file
  temp.mkdir {}, (err, tempDir) ->
    callback err if err?
    temp.open {suffix: '.tgz'}, (err, tempFile) ->
      callback err if err?
      # build and execute mongorestore command
      port = dbConn.hosts[0].port
      host = dbConn.hosts[0].host
      database = dbConn.database
      outPath = tempDir
      command = "mongodump --db #{database} --host #{host} --port #{port} --out #{outPath}"
      exec command, (err, res)  ->
        # zip it
        new targz().compress tempDir, tempFile.path, (err) ->
          callback err if err?
          callback null, tempFile.path

Meteor.restore = (callback) ->
  # receive  uploaded file
  # unzip it to temp folder
  # run mongorestore
  console.log 'restoring...'


Meteor.methods
  'backup' : ->
    Meteor.backup (err, file) ->
      # send it off to the client over http, rename the file?
      console.log 'sending to client:', file
      console.log 'tbc'

  'restore' : ->
    Meteor.restore()