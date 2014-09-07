Meteor.uploadBackup = (blob, callback) ->
  fileReader = new FileReader()
  fileReader.onload = (file) ->
    Meteor.call "uploadBackup", file.srcElement.result, ->
      callback() if callback?
  fileReader.readAsBinaryString blob

Meteor.downloadBackup = ->
  Meteor.call 'downloadBackup', (e, data) ->
    window.location = data