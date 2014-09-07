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
port = dbConn.hosts[0].port
host = dbConn.hosts[0].host
database = dbConn.database

# static files temp
RoutePolicy.declare staticEndpoint, "network"
WebApp.connectHandlers.use staticEndpoint, connect.static(staticDir)

filePrefix = ->
  now = new Date()
  "meteor-mongodump-#{now.getFullYear()}-#{now.getMonth()+1}-#{now.getDate()}-"

Meteor.generateMongoDump = (callback) ->
  # create temp dir and file
  temp.mkdir {}, (err, tempDir) ->
    callback err if err?
    tempFile = temp.path
      dir: staticDir
      prefix: filePrefix()
      suffix: ".tar.gz"
    # build and execute mongodumo
    outPath = tempDir
    dumpCommand = "mongodump --db #{database} --host #{host} --port #{port} --out #{outPath}"
    exec dumpCommand, (err, res)  ->
      # zip it
      new targz().compress "#{tempDir}/#{database}", tempFile, (err) ->
        callback err, tempFile

Meteor.parseMongoDump = (tmpRestoreFile, callback) ->
  # make a temp directory for mongorestore target
  temp.mkdir {}, (err, tempDir) ->
    # extract the contents of the upload
    new targz().extract tmpRestoreFile, tempDir, (e, location) ->
      # perfrom mongorstore with --drop
      restoreCommand = "mongorestore --drop --db #{database} --host #{host} --port #{port} #{tempDir}/#{database};"
      exec restoreCommand, (err, res)  ->
        callback(err, res) if callback?


Meteor.methods
  'downloadBackup' : ->
    filePath = do Meteor._wrapAsync(Meteor.generateMongoDump)
    filePathArr = filePath.split('/')
    file = filePathArr[filePathArr.length - 1]
    return "#{staticEndpoint}/#{file}"

   'uploadBackup': (fileData) ->
      # save the uploaded file
      complete = do Meteor._wrapAsync (done) ->
        tmpRestoreFile = temp.path()
        fs.writeFile tmpRestoreFile, fileData, 'binary', ->
          Meteor.parseMongoDump tmpRestoreFile, ->
            done null, true
      return complete








