// Require modules
var express = require("express");
var mongoose = require("mongoose");
var Data = require("./noteSchema");
const morgan = require("morgan");
const bodyParser = require("body-parser");
var app = express();
mongoose.set("useFindAndModify", false);
mongoose.connect("mongodb://localhost/newDB", {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});
app.use(morgan("dev"));
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", "*");
  res.header(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept, Authorization"
  );
  if (req.method === "OPTIONS") {
    res.header("Access-Control-Allow-Methods", "PUT, POST, PATCH, DELETE, GET");
    return res.status(200).json({});
  }
  next();
});

mongoose.connection
  .once("open", () => {
    console.log("Connected to DB!");
  })
  .on("error", (error) => {
    console.log("Fail to connect " + error);
  });

// Create a words ( Post request )
app.post("/create", (req, res) => {
  var words = new Data({
    firstChacracter: req.body.firstChacracter,
    lastChacracter: req.body.lastChacracter,
  });
  words.save().then(() => {
    if (words.isNew == false) {
      console.log("Save Data!");
      res.send("Save Data!");
    } else {
      console.log("Failed to save data");
    }
  });
});
// http://192.168.0.100/create
var server = app.listen(8081, "192.168.0.100", () => {
  console.log("Server is running!");
});

// Get All Data
app.get("/featch", (req, res) => {
  Data.find({}).then((items) => {
    res.send(items);
  });
});

// Delete Data
app.post("/delete", (req, res) => {
  Data.findOneAndRemove(
    {
      _id: req.get("id"),
    },
    (err) => {
      console.log("Failed" + err);
    }
  );

  res.send("Deleted!");
});

// Update Data
app.post("/update", (req, res) => {
  Data.findOneAndUpdate(
    {
      _id: req.get("id"),
    },
    {
      firstChacracter: req.get("firstChacracter"),
      lastChacracter: req.get("lastChacracter"),
    },
    (err) => {
      console.log("Failed" + err);
    }
  );
  res.send("Updated!");
});
// Check Data Character
app.post("/check", (req, res) => {
  var first = new RegExp("^" + req.body.firstChacracter + "$", "i");
  var last = new RegExp("^" + req.body.lastChacracter + "$", "i");
  return Data.find(
    {
      firstChacracter: first,
      lastChacracter: last,
    },
    (err, q) => {
      return res.send(q.length != 0);
    }
  );
});

// Search Data Character
app.post("/find", (req, res) => {
  var first = new RegExp("^" + req.body.firstChacracter + "$", "i");
  return Data.find(
    {
      firstChacracter: first,
    },
    (err, q) => {
      return res.send(q);
    }
  );
});
