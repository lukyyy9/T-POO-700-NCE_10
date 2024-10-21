/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./src/**/*.{html,js,vue}"
  ],
  theme: {
    extend: {
      colors: {
        primary: '#ffdd67',
        primaryAccent: '#FFEFB7',
        secondary: '#DBADFF',
        secondaryAccent: '#E7C9FF',
        mainFrame: '#303030',
        frame: '#4E4E4E',
        subFrame: '#656565',
        red: '#FF4141'
      },
    },
  },
  plugins: [],
}
