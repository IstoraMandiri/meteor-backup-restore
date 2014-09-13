# Meteor Backup-Restore
### A basic backup solution using `mongodump` and `monogorestore`

`$ meteor add hitchcott:backup-restore`

This package supports Meteor >=0.9, and is experimental. 

#### ⚠️ Don't use this package *out of the box* for anything other than prototyping.

This package contains methods that directly manipulate your database, which can be used by *any* clients out of the box.

If you use this for anything other than prototyping, please secure your methods with a package such as [hitchcott:method-hooks](https://github.com/hitchcott/meteor-method-hooks). Check out the [security](#security) section for more information.

**Please be sure to understand what this package does before using it in production.**

## What is it?

This package has two functions:

* **Backup**: Uses `mongodump` to create a tarball of the application's database then send it to the client via HTTP
* **Restore**: Allows aforementioned tarball to be uploaded and restored using `mongorestore`

This provides a simple way of creating backups and restoring your application's database without having to use the mongodb command line tools manually.

A common use case might be to copy your development database over to meteor.com after deploying it (untested), or simply keeping an backup archive of app instances.

If you are using [`collectionfs`](https://github.com/CollectionFS/Meteor-CollectionFS), with `cfs:gridfs` any stored files (such as images) will also be included in the backup file.

## Client API

There are two client helpers:

**Meteor.downloadBackup** will call the `downloadBackup` method, have the server generate a mongodump, tarball it, create a http endpoint, and automatically redirecting the user to the download link when it is ready.

```coffeescript
Template.myTemplate.events
  'click #download-backup' : ->
    Meteor.downloadBackup()
```

**Metoer.uploadBackup** accepts a file object. It reads that file as a binary blob in the browser, and sends it to an `uploadBackup` method. Once server-side, the tarball is extracted and is used with `mongorestore`, which will drop the current database and replace it with the uploaded data.
    
```coffeescript
  'change #upload-backup': (e) ->
     Meteor.uploadBackup e.currentTarget.files[0], ->
        alert 'backup complete!'
```

## Server API

This package should work out of the box with the above client methods. If you want to use them server-side, you can do:

* `Meteor.generateMongoDump`
* `Meteor.parseMongoDump`
* Meteor method `downloadBackup`
* Meteor method `uploadBackup`

Check `backup-restore.coffee` for more information.

## Security

You shouldn't use this pacakge for anything other than prototyping without securing the methods on the server side. 

To do so, you could use the [hitchcott:method-hooks](https://github.com/hitchcott/meteor-method-hooks) package. 

For example:

```coffeescript
Meteor.beforeMethods ['uploadBackup', 'downloadBackup'], ->
  Meteor.users.findOne(@userId)?.admin
```

The above will ensure that only users with the `admin` field attached to their user (server side mongo) object can perform backups and restores.

## Todos (PRs welcome)

* Make TEMP_LIFETIME configurable. Currently fixed at 30 mins.
* Direct upload of tar via HTTP instead of using `FileReader` on client (I believe this will be required larger backup files).
* Deeper collectionfs integration 
	* serving backup/restore files
	* backing up local filesystem files
* Better docs
* Tests

## Credits

Chris Hithcoct, 2014

MIT License
