const express = require('express');
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const bodyParser = require('body-parser');
const cors = require('cors');
const multer = require('multer');

const app = express();
app.use(bodyParser.json());
app.use(cors());

// Подключаемся к MongoDB
mongoose.connect('mongodb+srv://ATAIST:co8RSZBC1h24thvk@manga.sw049.mongodb.net/manga?retryWrites=true&w=majority', { useNewUrlParser: true, useUnifiedTopology: true, serverSelectionTimeoutMS: 5000})
  .then(() => console.log('Connected to MongoDB'))
  .catch(err => console.log(err));

const mangaSchema = new mongoose.Schema({
  name: { type: String, required: true },
  image: { type: Buffer, required: true }, // Store image as binary data
});
const Manga = mongoose.model('Manga', mangaSchema);

// Схема пользователя
const userSchema = new mongoose.Schema({
  username: { type: String, required: true, unique: true },
  password: { type: String, required: true },
});

const User = mongoose.model('User', userSchema);

// Регистрация
app.post('/register', async (req, res) => {
  const { username, password } = req.body;
  const existingUser = await User.findOne({ username });

  if (existingUser) {
    return res.status(400).send('User already exists');
  }

  const hashedPassword = await bcrypt.hash(password, 10);

  const user = new User({
    username,
    password: hashedPassword,
  });

  await user.save();
  res.status(201).send('User registered successfully');
});

// Авторизация
app.post('/login', async (req, res) => {
  const { username, password } = req.body;
  const user = await User.findOne({ username });

  if (!user) {
    return res.status(400).send('Incorrect username or password');
  }

  const isMatch = await bcrypt.compare(password, user.password);

  if (!isMatch) {
    return res.status(400).send('Incorrect username or password');
  }

  const token = jwt.sign({ userId: user._id }, 'your_secret_key', { expiresIn: '1h' });
  res.json({ token });
});


// Multer setup for file uploads
const upload = multer({ storage: multer.memoryStorage() });


app.post('/upload', upload.single('image'), async (req, res) => {
  const { name } = req.body;

  if (!req.file) {
    return res.status(400).send('No file uploaded');
  }

  const manga = new Manga({
    name,
    image: req.file.buffer, // Store file buffer in MongoDB
  });

  await manga.save();
  res.status(201).send('Image uploaded successfully');
});
// Retrieve all manga with their IDs and names
app.get('/manga', async (req, res) => {
  const mangas = await Manga.find({}, { name: 1 }); // Only return name and ID
  res.json(mangas);
});

// Retrieve a specific manga image by ID
app.get('/manga/:id/image', async (req, res) => {
  const manga = await Manga.findById(req.params.id);

  if (!manga) {
    return res.status(404).send('Manga not found');
  }

  res.set('Content-Type', 'image/jpeg'); // Set appropriate content type
  res.send(manga.image); // Send binary image data
});

// Запускаем сервер
const PORT = 5000;
app.listen(PORT, () => {
  console.log(Server is running on port ${PORT});
});
