Package.describe({
  summary: "Datbase backup using mongorestore",
  version: "1.0.0"
  // git: ""
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@0.9.1');
  api.use('coffeescript')
  api.addFiles('backup-restore.coffee');
});