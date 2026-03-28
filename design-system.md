# LearnWithAI Design System

## Concept: "Digital Garden"
Learning as growth. Each topic is a plant, mastery is blooming, progress is cultivation.

## Core Metaphors
- Grades = Garden zones/greenhouses
- Subjects = Different biomes (Desert for Math = structured/sandy, Forest for Science = organic, etc.)
- Topics = Individual plants/species
- Progress = Plant growth stages (seed → sprout → sapling → flowering → mature)
- Weak areas = Plants needing water/attention
- Strong areas = Thriving, blooming plants

## Aesthetic Direction
- Organic shapes, soft curves, no sharp corners
- Nature-inspired color palette
- Gentle, breathing animations
- Paper/cardboard textures for UI elements
- Floating elements like leaves/butterflies/particles

## Color Palette

### Primary
- `--soil-dark`: #2C2419 (dark brown, text/headers)
- `--soil-medium`: #5C4A32 (medium brown)
- `--soil-light`: #8B7355 (light brown, borders)

### Growth Greens
- `--seed`: #E8F5E9 (palest green, backgrounds)
- `--sprout`: #81C784 (fresh green)
- `--sapling`: #4CAF50 (vibrant green)
- `--flourish`: #2E7D32 (rich green)
- `--bloom`: #F48FB1 (pink, accents/achievements)

### Biome Accents
- `--math-sand`: #F5E6C8 (warm sand for math)
- `--science-leaf`: #A5D6A7 (forest green)
- `--history-amber`: #FFCC80 (amber/gold)
- `--english-sky`: #90CAF9 (soft blue)

### Background
- `--garden-cream`: #FAF7F2 (warm off-white)
- `--garden-mist`: rgba(255,255,255,0.8) (glass effect)

## Typography
- **Display/Headings**: "Playfair Display" - elegant serif, evokes botanical illustrations
- **Body**: "Nunito" - friendly, rounded sans-serif
- **Monospace/Numbers**: "Space Mono" - technical but warm

## UI Components

### Cards (Plant Pots)
- Rounded corners (24px border-radius)
- Soft shadow with organic offset
- Subtle gradient suggesting depth
- Hover: gentle lift + shadow increase

### Buttons (Seeds)
- Pill-shaped (fully rounded)
- Gradient fill on primary
- Hover: scale(1.02) + glow effect
- Active: pressed effect

### Progress Bars (Growth Rings)
- Organic wavy edges (SVG clip-path)
- Fill animation like water rising
- Color transitions through growth stages

### Navigation (Garden Paths)
- Curved lines between sections
- Step indicators as leaf shapes
- Breadcrumb as trail of petals

## Animations
- **Idle**: Gentle breathing (scale 1.0 → 1.02 over 4s)
- **Hover**: Leaf rustle (subtle rotation)
- **Success**: Bloom animation (petals expanding)
- **Loading**: Seed germination (sprouting dots)
- **Page transitions**: Growth from center outward

## Special Effects
- Floating pollen particles (subtle, performance-conscious)
- Mouse-following butterfly (easter egg)
- Scroll-triggered growth animations
- Glass-morphism for overlays (frosted glass effect)

## Accessibility
- All colors meet WCAG AA contrast
- Animations respect prefers-reduced-motion
- Focus states use high-contrast outlines
- Semantic HTML throughout
