require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

mongoose.connect("mongodb+srv://ATAIST:co8RSZBC1h24thvk@manga.sw049.mongodb.net/manga?retryWrites=true&w=majority", { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log("MongoDB Connected"))
  .catch(err => console.log(err));

const MangaSchema = new mongoose.Schema({
  name: String,
  folder: String,
});
const Manga = mongoose.model('Manga', MangaSchema);

app.get('/mangas', async (req, res) => {
  const mangas = await Manga.find();
  res.json(mangas);
});

app.listen(5000, () => console.log("Server running on port 5000"));
