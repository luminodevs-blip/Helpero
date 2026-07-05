# Helpero Client Web — Design Rules

These rules apply to **every** screen in this project. Do not deviate from them.

---

## 🎨 Color System

| Token | Value | Usage |
|---|---|---|
| `--primary` | `#7B82F4` | Buttons, active icons, links, accents |
| Background | `#FFFFFF` | All card and screen backgrounds |
| Alt Background | `#F1F4F8` | Page background, input fill |
| Title text | `text-zinc-900` (`#14181B`) | Always explicit — never system `color-scheme` |
| Subtitle text | `text-zinc-500` (`#57636C`) | Always explicit |

> ⚠️ **Never** use `text-text-primary` or `text-text-secondary` Tailwind utilities on white card sections — they render invisible in dark mode. Always use explicit `text-zinc-900` / `text-zinc-500`.

---

## 🔤 Typography

| Role | Font | Weight | Size |
|---|---|---|---|
| Page headings (H1/H2) | `font-outfit` | 800 extrabold | `text-xl` – `text-2xl` |
| Section headings (H3) | `font-outfit` | 700 bold | `text-base` – `text-lg` |
| Card titles | `font-outfit` | 700 bold | `text-[15px]` |
| Body / labels | system sans | 600 semibold | `text-sm` |
| Captions / meta | system sans | 500 medium | `text-[11px]` – `text-xs` |

---

## 📐 Spacing & Layout

| Context | Value |
|---|---|
| Horizontal screen padding | `px-5` (20px) |
| Between sections | `space-y-5` or `mb-5` (20px) |
| Between cards | `space-y-5` (20px) |
| Card inner padding | `p-4` (16px) |
| Bottom nav safe zone | `pb-28` – `pb-32` |

---

## 🔵 Border Radius (Roundings)

| Element | Tailwind | Pixels |
|---|---|---|
| Full-screen cards / bottom sheets | `rounded-[28px]` | 28px |
| Standard content cards | `rounded-2xl` | 16px |
| Inner image thumbnails | `rounded-xl` | 12px |
| Buttons (primary CTA) | `rounded-xl` | 12px |
| Pill badges / tags | `rounded-full` | 9999px |
| Input fields | `rounded-2xl` | 16px |
| Floating nav bar | `rounded-[24px]` | 24px |

---

## 🖼️ Hero Headers

- Category pages: show **video** (`video_url`) if present, fall back to `image_url`
- Back button: **white circle** `bg-white shadow-md` — NOT glassmorphism on light backgrounds
- Share button: same style as back button
- Position back at `top-12 left-4`, share at `top-12 right-4`

---

## 📦 Service Cards (Category Page)

Structure (top to bottom):
1. **Title** — `font-outfit font-bold text-[15px] text-zinc-900`
2. **"Starts at $X · ⏱ duration"** — `text-[12px] text-zinc-500`
3. **Bullet list** — 4 visible by default, expand via "Learn more"
4. **Thumbnail image** — `h-[100px] w-[90px] rounded-xl` right-aligned
5. **"Book Now" button** — `bg-zinc-900 text-white rounded-xl w-full`
6. **"Learn more" toggle** — `text-primary text-[12px] font-bold`

---

## ✅ Promo Banners

- Horizontal scrollable strip below the rating row
- Each banner: `border border-zinc-200 rounded-xl px-3.5 py-2.5 min-w-[170px]`
- Icon: `text-primary h-4 w-4`
- Title: `text-[11px] font-extrabold text-zinc-900`
- Subtitle: `text-[10px] text-zinc-500`
