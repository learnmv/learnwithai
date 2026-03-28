# LearnWithAI Frontend Design Document

## Overview
LearnWithAI is a personalized learning platform with a "Digital Garden" aesthetic theme. The design philosophy treats learning as cultivation - each topic is a plant, mastery is blooming, and progress is growth.

---

## Design Philosophy: Digital Garden

### Core Metaphors
- **Grades** = Garden zones/greenhouses
- **Subjects** = Different biomes (Desert for Math = structured/sandy, Forest for Science = organic, etc.)
- **Topics** = Individual plants/species
- **Progress** = Plant growth stages: seed → sprout → sapling → bloom
- **Weak areas** = Plants needing water/attention
- **Strong areas** = Thriving, blooming plants

### Visual Language
- Organic shapes, soft curves, no sharp corners
- Nature-inspired color palette
- Gentle, breathing animations
- Floating elements (leaves, particles)
- Glass-morphism for overlays

---

## Color System

### CSS Variables

```css
/* Soil Browns */
--soil-dark: #2C2419;      /* Text, headers */
--soil-medium: #5C4A32;    /* Secondary text */
--soil-light: #8B7355;     /* Borders, accents */
--soil-pale: #D4C4B0;      /* Light backgrounds */

/* Growth Greens */
--seed: #E8F5E9;           /* Palest green, backgrounds */
--sprout: #A5D6A7;         /* Fresh green */
--sapling: #66BB6A;        /* Vibrant green */
--flourish: #43A047;       /* Rich green */
--deep-root: #2E7D32;      /* Deep green */

/* Bloom & Warmth */
--bloom: #F48FB1;          /* Pink, achievements */
--bloom-light: #F8BBD9;    /* Light pink */
--sunshine: #FFF8E1;       /* Warm yellow/cream */
--amber: #FFCC80;          /* Golden amber */

/* Biome Accents */
--math-sand: #F5E6C8;      /* Warm sand for math */
--science-leaf: #C8E6C9;   /* Forest green */
--history-amber: #FFE0B2;  /* Amber/gold */
--english-sky: #BBDEFB;    /* Soft blue */

/* Backgrounds */
--garden-cream: #FAF7F2;   /* Warm off-white */
--garden-paper: #FFFEFB;   /* Pure white with warmth */
```

### Shadows
```css
--shadow-soft: 0 4px 20px rgba(44, 36, 25, 0.08);
--shadow-lift: 0 8px 32px rgba(44, 36, 25, 0.12);
--shadow-dramatic: 0 16px 48px rgba(44, 36, 25, 0.16);
```

---

## Typography

### Font Stack
```css
--font-display: 'Playfair Display', Georgia, serif;  /* Headings */
--font-body: 'Nunito', -apple-system, sans-serif;    /* Body text */
--font-mono: 'Space Mono', monospace;                /* Numbers/labels */
```

### Font Usage
- **Headings (H1-H4)**: Playfair Display, weight 600
  - H1: clamp(2.5rem, 6vw, 4rem)
  - H2: clamp(1.75rem, 4vw, 2.5rem)
  - H3: clamp(1.25rem, 3vw, 1.5rem)
- **Body**: Nunito, 1.1rem, line-height 1.6
- **Labels/Numbers**: Space Mono, uppercase with letter-spacing

### Google Fonts Import
```html
<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700&family=Playfair+Display:wght@400;500;600;700&family=Space+Mono:wght@400;700&display=swap" rel="stylesheet">
```

---

## Spacing System

```css
--space-xs: 0.5rem;   /* 8px */
--space-sm: 1rem;     /* 16px */
--space-md: 1.5rem;   /* 24px */
--space-lg: 2.5rem;   /* 40px */
--space-xl: 4rem;     /* 64px */
--space-xxl: 6rem;    /* 96px */
```

---

## Border Radius System

```css
--radius-sm: 12px;
--radius-md: 20px;
--radius-lg: 28px;
--radius-full: 9999px;  /* Pills, avatars, circles */
```

---

## UI Components

### Cards (Plant Pots)
- Background: `--garden-paper`
- Border-radius: `--radius-lg` (28px)
- Padding: `--space-md` (1.5rem)
- Shadow: `--shadow-soft`
- Hover: translateY(-4px) + `--shadow-lift`
- Top accent line: 4px gradient (green to pink)

### Organic Card Variant
- Border-radius: `60% 40% 50% 50% / 40% 50% 60% 50%`
- Creates asymmetric, organic blob shape

### Buttons (Seeds)
- Border-radius: `--radius-full` (pill shape)
- Padding: 0.875rem 1.75rem
- Font: `--font-body`, weight 600
- Primary: Gradient background (sapling to flourish)
- Secondary: White with `--soil-pale` border
- Glow variant: Shimmer effect on hover

### Progress Bars (Growth Rings)
- Height: 8px
- Background: `--soil-pale`
- Fill: Gradient (subject color to green)
- Border-radius: `--radius-full`

### Navigation (Garden Paths)
- Step indicators as text with leaf separators (🌿)
- Active state: `--flourish` color
- Background: `--garden-paper` with pill shape

---

## Animation System

### Timing Functions
```css
--transition-fast: 150ms ease;
--transition-medium: 300ms cubic-bezier(0.4, 0, 0.2, 1);
--transition-slow: 500ms cubic-bezier(0.34, 1.56, 0.64, 1);
```

### Key Animations

```css
/* Page transitions - Grow from center */
@keyframes growIn {
    from {
        opacity: 0;
        transform: translateY(20px) scale(0.98);
    }
    to {
        opacity: 1;
        transform: translateY(0) scale(1);
    }
}

/* Background breathing effect */
@keyframes breathe {
    0%, 100% { transform: scale(1); opacity: 0.4; }
    50% { transform: scale(1.05); opacity: 0.5; }
}

/* Gentle plant bobbing */
@keyframes gentle-bob {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-3px); }
}

/* Gentle swaying for bloom stage */
@keyframes gentle-sway {
    0%, 100% { transform: rotate(-3deg); }
    50% { transform: rotate(3deg); }
}

/* Pulse for growth indicators */
@keyframes pulse {
    0%, 100% { transform: scale(1); opacity: 1; }
    50% { transform: scale(1.2); opacity: 0.7; }
}

/* Floating leaves */
@keyframes fall {
    to {
        transform: translateY(100vh) rotate(360deg);
    }
}

/* AI status blink */
@keyframes blink {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.5; }
}

/* Button shimmer */
@keyframes shimmer {
    from { left: -100%; }
    to { left: 100%; }
}
```

---

## Layout Patterns

### Container
```css
.container {
    max-width: 1400px;
    margin: 0 auto;
    padding: var(--space-md);
}
```

### Grids
- **Grades**: `repeat(auto-fit, minmax(180px, 1fr))`
- **Subjects**: `repeat(auto-fit, minmax(280px, 1fr))`
- **Topics**: Two-column (content + sidebar), stacks on mobile

### Responsive Breakpoints
- Mobile: < 768px (single column, simplified nav)
- Tablet: 768px - 1024px
- Desktop: > 1024px

---

## Background Effects

### Animated Gradient
```css
body::before {
    content: '';
    position: fixed;
    background:
        radial-gradient(ellipse at 20% 80%, var(--sprout) 0%, transparent 50%),
        radial-gradient(ellipse at 80% 20%, var(--bloom-light) 0%, transparent 40%),
        radial-gradient(ellipse at 50% 50%, var(--sunshine) 0%, transparent 70%);
    opacity: 0.4;
    animation: breathe 8s ease-in-out infinite;
}
```

### Floating Leaves
- 8 decorative leaves (🍃 🌿 🍂 🌱)
- Random positions, 15-25s duration
- Linear infinite animation

### Glass Morphism
```css
backdrop-filter: blur(20px);
background: rgba(250, 247, 242, 0.85);
```

---

## Growth Stage System

| Stage | Icon | Color | Animation | Description |
|-------|------|-------|-----------|-------------|
| Seed | 🌰 | `--soil-pale` | None | Ready to plant |
| Sprout | 🌱 | `--sprout` | gentle-bob | Growing |
| Sapling | 🌿 | `--sapling` | None | Taking root |
| Bloom | 🌻 | `--bloom` | gentle-sway | Mastered! |

---

## Biome Colors by Subject

| Subject | Primary | Accent | Icon |
|---------|---------|--------|------|
| Math | `--math-sand` | Orange | 📐 |
| Science | `--science-leaf` | Green | 🔬 |
| English | `--english-sky` | Blue | 📚 |
| History | `--history-amber` | Amber | 🏛️ |

---

## Accessibility

### Reduced Motion
```css
@media (prefers-reduced-motion: reduce) {
    *, *::before, *::after {
        animation-duration: 0.01ms !important;
        animation-iteration-count: 1 !important;
        transition-duration: 0.01ms !important;
    }
}
```

### Focus States
```css
:focus-visible {
    outline: 3px solid var(--flourish);
    outline-offset: 2px;
}
```

### Color Contrast
- All text meets WCAG AA standards
- `--soil-dark` on `--garden-paper`: 10.2:1 ratio
- Interactive elements have clear focus indicators

---

## AI Assistant Design

### Visual Style
- Dark gradient background: `linear-gradient(135deg, #1a1a2e 0%, #16213e 100%)`
- Floating particles animation
- Gradient avatar: green gradient
- Status indicator with blinking dot

### Personality
- Name: Sprout
- Tone: Friendly, encouraging, Socratic
- Behavior: Guides without giving direct answers
- Avatar: 🌿

---

## Component States

### Grade Cards
- Default: White background, transparent border
- Hover: `--sapling` border, translateY(-8px), shadow
- Active: `--flourish` border, `--seed` background
- Recommended: Pulse animation indicator

### Subject Cards
- Biome-colored icon background
- Gradient progress bar (subject color to green)
- Hover: Slight lift + shadow increase

### Answer Options (Quiz)
- Default: White background, `--soil-pale` border
- Hover: `--sapling` border, `--seed` background
- Selected: `--flourish` border
- Correct: Green background, green border
- Incorrect: Red background, red border

---

## File Structure

```
/home/sysadmin/learnwithai/
├── index.html           # Complete application (single file)
├── design-system.md     # Original design notes
└── frontend_design.md   # This document
```

The application is built as a single, self-contained HTML file with:
- Embedded CSS (complete design system)
- Embedded JavaScript (all functionality)
- No external dependencies except Google Fonts

---

## Design Principles

1. **Organic Over Geometric**: Prefer soft curves, gradients, and natural shapes
2. **Warmth Over Coolness**: Earth tones, warm whites, gentle colors
3. **Motion With Purpose**: Animations guide attention and delight
4. **Hierarchy Through Typography**: Clear heading/body distinction
5. **Accessibility First**: All users can navigate and understand
6. **Mobile Responsive**: Works beautifully on all screen sizes
