const express = require("express");
const client = require("prom-client");

const app = express();
client.collectDefaultMetrics({ timeout: 5000 });

const PORT = 8080;
//test
app.get("/", (req, res) => {
  res.send("OK");
});

app.get("/metrics", async (req, res) => {
  res.set("Content-Type", client.register.contentType);
  res.end(await client.register.metrics());
});

app.listen(PORT, () => {
  console.log(`Web app running on port ${PORT}`);
});
