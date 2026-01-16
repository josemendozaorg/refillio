/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: '#0F52BA',
        secondary: '#008080',
        background: '#0D1117', // Dark background similar to the Flutter app screenshots/impl
      },
    },
  },
  plugins: [],
}
