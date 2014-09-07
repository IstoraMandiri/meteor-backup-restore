fs   = Npm.require('fs')
exec = Npm.require('child_process').exec
mongodbUri = Npm.require('mongodb-uri')
targz = Npm.require('tar.gz')
connect = Npm.require("connect")
temp = Npm.require('temp')

staticDir = process.env.PWD + "/.meteor/local/backuprestore_tmp"
staticEndpoint = "/download-backup"

# use `temp` to cleanup
temp.track()

# get database connection information from process
dbConn = mongodbUri.parse(process.env.MONGO_URL)

# static files temp
RoutePolicy.declare staticEndpoint, "network"
WebApp.connectHandlers.use staticEndpoint, connect.static(staticDir)

filePrefix = ->
  now = new Date()
  "meteor-mongodump-#{now.getFullYear()}-#{now.getMonth()+1}-#{now.getDate()}-"

Meteor.backup = (callback) ->
  # create temp dir and file
  temp.mkdir {}, (err, tempDir) ->
    callback err if err?
    tempFile = temp.path
      dir: staticDir
      prefix: filePrefix()
      suffix: ".tgz"
    # build and execute mongorestore command
    port = dbConn.hosts[0].port
    host = dbConn.hosts[0].host
    database = dbConn.database
    outPath = tempDir
    command = "mongodump --db #{database} --host #{host} --port #{port} --out #{outPath}"
    exec command, (err, res)  ->
      # zip it
      new targz().compress tempDir, tempFile, (err) ->
        if err?
          callback err
        else

          callback null, tempFile

Meteor.restore = (callback) ->
  # receive  uploaded file
  # unzip it to temp folder
  # run mongorestore
  console.log 'restoring...'


Meteor.methods
  'backup' : ->
    filePath = do Meteor._wrapAsync(Meteor.backup)
    filePathArr = filePath.split('/')
    file = filePathArr[filePathArr.length - 1]
    return "#{staticEndpoint}/#{file}"

  'restore' : ->
    Meteor.restore()