var path="/Users/administrator/Desktop"

watcher = require('fl-watch-tree').watchTree(path, {'sample-rate': 5});
//watcher.on('fileDeleted', function(path) {
//    console.log("fileDeleted" + path + "!");
//});
watcher.on('filePreexisted', function(path) {
    console.log("filePreexisted" + path + "!");
});
//watcher.on('fileCreated', function(path) {
//    console.log("fileCreated" + path + "!");
//});
watcher.on('fileModified', function(path) {
    console.log("fileModified" + path + "!");
})