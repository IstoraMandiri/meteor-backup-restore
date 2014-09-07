Package.describe({
  summary: "Datbase backup using mongorestore",
  version: "1.0.0"
  // git: ""
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