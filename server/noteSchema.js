var mongoose = require("mongoose");
var Schema = mongoose.Schema;

var words = new Schema({
  firstChacracter: String,
  lastChacracter: String,
});

const Data = mongoose.model("Data", words);

module.exports = Data;
