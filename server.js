const express = require('express');
const puppeteer = require('puppeteer-extra');
const StealthPlugin = require('puppeteer-extra-plugin-stealth');

const app = express();
const port = 3000;

let browser; // Сохраняем экземпляр браузера

puppeteer.use(StealthPlugin());

// Middleware для создания или использования существующего экземпляра браузера
app.use(async (req, res, next) => {
  if (!browser) {
    browser = await puppeteer.launch({ headless: true });
  }
  req.browser = browser;
  next();
});

app.get('/get-content', async (req, res) => {
  const url = req.query.url;

  if (!url) {
    return res.status(400).json({ error: 'URL parameter is missing' });
  }

  try {
    const page = await req.browser.newPage();
    await page.goto(url, { waitUntil: 'domcontentloaded' });

    // Добавляем ожидание 10 секунд
	setTimeout(async () => {
		const content = await page.content();
		await page.close();

		res.status(200).send(content);
	}, 10000);
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});