const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.{erb,haml,html,slim}",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
      },
      colors: {
        marche_white: '#faf8f7',
        marche_orange: '#ff8537',
        marche_orange100: '#ffa46a',
        marche_pearl: '#f1e9e4',
        marche_black: '#0c0b0b',
        marche_black100: '#8c8c8c',
        marche_blue: '#1d4ed8',
        marche_shop_primary: '#335495',
        marche_shop_white: '#FEFEFE',
        marche_shop_blue: '#A5BECF',
        marche_shop_blue500: '#668BC4',
        marche_shop_black: '#040A1B',
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/aspect-ratio"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/container-queries"),
    require("daisyui"),
  ],
  daisyui: {
    styled: true,
    themes: false,
    base: true,
    utils: true,
    logs: true,
    rtl: false,
    prefix: "",
    darkTheme: "light",
  },
};
