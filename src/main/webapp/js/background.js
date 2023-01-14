const images = ["0.jpg","1.jpg"];
const chosimg = images[Math.floor(Math.random()*images.length)];

const bgimg = `url(img/${chosimg})`;
document.body.classList.add("background");
document.body.style.backgroundImage= bgimg;