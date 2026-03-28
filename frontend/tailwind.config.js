/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        // Soil Browns
        soil: {
          dark: '#2C2419',
          medium: '#5C4A32',
          light: '#8B7355',
          pale: '#D4C4B0',
        },
        // Growth Greens
        seed: '#E8F5E9',
        sprout: '#A5D6A7',
        sapling: '#66BB6A',
        flourish: '#43A047',
        'deep-root': '#2E7D32',
        // Bloom & Warmth
        bloom: {
          DEFAULT: '#F48FB1',
          light: '#F8BBD9',
        },
        sunshine: '#FFF8E1',
        amber: '#FFCC80',
        // Biome Accents
        'math-sand': '#F5E6C8',
        'science-leaf': '#C8E6C9',
        'history-amber': '#FFE0B2',
        'english-sky': '#BBDEFB',
        // Backgrounds
        'garden-cream': '#FAF7F2',
        'garden-paper': '#FFFEFB',
      },
      fontFamily: {
        display: ['Playfair Display', 'Georgia', 'serif'],
        body: ['Nunito', 'sans-serif'],
        mono: ['Space Mono', 'monospace'],
      },
      borderRadius: {
        'sm': '12px',
        'md': '20px',
        'lg': '28px',
        'full': '9999px',
      },
      animation: {
        'breathe': 'breathe 8s ease-in-out infinite',
        'bob': 'gentle-bob 3s ease-in-out infinite',
        'sway': 'gentle-sway 4s ease-in-out infinite',
        'pulse': 'pulse 2s ease-in-out infinite',
        'fall': 'fall 20s linear infinite',
        'shimmer': 'shimmer 0.5s ease-in-out',
      },
      keyframes: {
        'breathe': {
          '0%, 100%': { transform: 'scale(1)', opacity: '0.4' },
          '50%': { transform: 'scale(1.05)', opacity: '0.5' },
        },
        'gentle-bob': {
          '0%, 100%': { transform: 'translateY(0)' },
          '50%': { transform: 'translateY(-3px)' },
        },
        'gentle-sway': {
          '0%, 100%': { transform: 'rotate(-3deg)' },
          '50%': { transform: 'rotate(3deg)' },
        },
        'fall': {
          'to': { transform: 'translateY(100vh) rotate(360deg)' },
        },
        'shimmer': {
          'from': { left: '-100%' },
          'to': { left: '100%' },
        },
      },
    },
  },
  plugins: [],
}