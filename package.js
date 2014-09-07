Package.describe({
  summary: "A basic backup solution using mongodump and monogorestore",
  version: "0.0.0",
  git: "https://github.com/hitchcott/meteor-backup-restore",
  name: 'hitchcott:backup-restore'
});

Npm.depends({
  "temp": "0.8.1",
  "mongodb-uri": "0.9.7",
  "tar.gz": "0.1.1",
  "connect": "2.7.10"
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@0.9.0');

  api.use(['coffeescript','webapp','routepolicy'],'server');
  api.addFiles('backup-restore.coffee', 'server');

  api.use(['coffeescript'],'client');
  api.addFiles('client-helpers.coffee','client')
});