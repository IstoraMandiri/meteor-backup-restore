Meteor.uploadBackup = (blob) ->
  fileReader = new FileReader()
  fileReader.onload = (file) ->
    Meteor.call "uploadBackup", file.srcElement.result
  fileReader["readAsBinaryString"] blob
