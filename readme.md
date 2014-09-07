# Meteor backup-restore
### A basic backup solution using mongodump and monogorestore

`$ meteor add hitchcott:backup-restore`

This package currently supports Meteor >=0.9, and is experimental. 

**Important: Do not add this package to production apps**, right now it is 100% insecure. This package contains methods that directly manipulate your database which are compelteley accessible to any clients.

## What is it?

This package has two functions:

* **Backup**: Uses `mongodump` to create a tarball of the application's database then send it to the client via HTTP
* **Restore**: Allows aforementioned tarball to be uploaded and restored using `mongorestore`

This provides a simple way of creating backups and restoring your application's database without having to use the mongodb command line tools manually.

A common use case might be to copy your development database over to meteor.com after deploying it (untested), or simply keeping an backup archive of app instances.

## Client API

There are two client helpers:

```coffeescript
Template.myTemplate.events
  'click #download-backup' : ->
    Meteor.downloadBackup()
```

**Meteor.downloadBackup** will call the `downloadBackup` method, have the server generate a mongodump, tarball it, create a http endpoint, and automatically redirecting the user to the download link when it is ready.
    
```coffeescript
  'change #upload-backup': (e) ->
     Meteor.uploadBackup e.currentTarget.files[0], ->
        alert 'backup complete!'
```

**Metoer.uploadBackup** accepts a file object. It reads that file as a binary blob in the browser, and sends it to an `uploadBackup` method. Once server-side, the tarball is extracted and is used with `mongorestore`, which will drop the current database and replace it with the uploaded data.

## Server API

This package should work out of the box with the above client methods. If you want to use them server-side, you can do:

* `Meteor.generateMongoDump`
* `Meteor.parseMongoDump`
* Meteor method `downloadBackup`
* Meteor method `uploadBackup`

Check `backup-restore.coffee` for more information.

## Todo

* Add Method Security. I'll probably use [method-hooks](https://github.com/hitchcott/meteor-method-hooks/) once it's updated to 0.9.
* Direct upload of tar instead of client-side reading - I believe this will be required larger backup files
* *Maybe* collectionfs integration (both for serving backup/restore files and backing up local filesystem files)
* Better docs
* Tests

## Credits

Chris Hithcoct, 2014

MIT License
