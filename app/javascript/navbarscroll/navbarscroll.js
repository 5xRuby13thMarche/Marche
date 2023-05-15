const navbar = document.querySelector(".navbar");

window.addEventListener("scroll", function () {
  const offsetTop = window.pageYOffset;

  if (offsetTop > 0) {
    // 計算透明度
    const alpha = Math.min(0.9, offsetTop / 200); // 最大透明度為0.9，當頁面滾動200像素時達到最大透明度

    // 設置 Navbar 背景色透明度
    navbar.style.backgroundColor = `rgba(0, 0, 0, ${alpha})`;
  } else {
    // Navbar 回到初始透明度
    navbar.style.backgroundColor = "rgba(0, 0, 0, 0)";
  }
});
