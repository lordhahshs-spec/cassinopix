# AI Rules & Project Architecture

## Tech Stack
- **Backend Framework**: PHP 8.1+ with **Laravel 10**, modular structure via `nwidart/laravel-modules`, and Eloquent ORM.
- **Admin Panel**: **Filament v3** for administrative dashboards, data tables, metrics widgets, and role management.
- **Authentication & Security**: **Laravel Sanctum** and **JWT-Auth (`tymon/jwt-auth`)** for RESTful API security; session/cookie auth for Filament and web routes.
- **Frontend Framework**: **Vue 3** (Single-File Components) built and bundled with **Vite** (`laravel-vite-plugin` and `@vitejs/plugin-vue`).
- **Styling & Design System**: **Tailwind CSS 3** with custom design tokens, dark mode class strategy, and **Flowbite** components.
- **State Management & Routing**: **Pinia** for centralized client reactive stores and **Vue Router 4** for SPA routing and navigation guards.
- **Real-Time Communication**: **Laravel Echo** + **Pusher (`pusher-js`)** for live event broadcasts, balance updates, and socket channels.
- **Interactive Gaming & Media**: **Pixi.js** for 2D canvas games, **GSAP** for timeline animations, and **Howler.js** for audio and sound effects.
- **Localization (i18n)**: **laravel-vue-i18n** with JSON language dictionaries (`lang/`) supporting multi-language setups (PT-BR, EN, ES).
- **Payment Integrations**: **SuitPay** (PIX deposits/withdrawals) and **Stripe** (`stripe/stripe-php` & `@vue-stripe/vue-stripe`).

---

## Library Usage Guidelines

Use the following designated libraries for specific application responsibilities:

### UI & Styling
- **Tailwind CSS**: Use utility classes for all styling, responsive layouts, spacing, and theme colors (`primary`, `secondary`, `gray`, `bg-base`). Always respect dark mode classes.
- **Flowbite** (`flowbite`, `flowbite-datepicker`): Use for standard UI primitives (dropdowns, modals, tabs, tooltips, and date pickers).
- **FontAwesome / SVG**: Use for iconography across navigation and action buttons.

### Frontend State & Routing
- **Pinia**: Use for global reactive state (authenticated user, wallet balance, active game session, site configurations). Do not duplicate server state across unrelated local component states.
- **Vue Router 4**: Use for client-side navigation, route parameters, layout wrapping, and route transition logic (`resources/js/Pages/`).
- **VueUse** (`@vueuse/core`): Use for reactive utility hooks (local storage, window resizing, debounce/throttle, event listeners).

### API & Data Fetching
- **Axios / Vue-Axios**: Use for all asynchronous HTTP communication with Laravel API endpoints (`/api/*`). Always ensure CSRF token and JWT authorization headers are attached.
- **Laravel Vue Pagination** (`laravel-vue-pagination`): Use for rendering paginated database lists (game catalogs, transaction history).

### Real-Time & WebSockets
- **Laravel Echo & Pusher-js**: Use for subscribing to private and public channels (deposit confirmations, live roulette/spin events, jackpot broadcasts).

### Animation, Gaming & Multimedia
- **Pixi.js**: Use for high-performance 2D canvas rendering (wheel spins, casino game viewports, particle effects).
- **GSAP**: Use for programmatic UI animations, modal transitions, spinning animations, and sequenced timelines.
- **Howler.js**: Use for game sound effects, button click audios, victory chimes, and ambient audio control.

### Forms & Input Handling
- **Maska**: Use for formatting and masking user input fields (CPF, phone numbers, date formats, currency inputs).
- **Moment.js**: Use for manipulating, comparing, and formatting timestamps and human-readable dates.

### Media & Display Utilities
- **vue3-carousel**: Use for banner sliders, featured game carousels, and promotional displays.
- **vue-lazyload**: Use for lazy loading game thumbnails and heavy image assets.
- **vue-fullscreen**: Use for toggling full-screen mode on game canvases and iframe game loaders.
- **qrcode-vue3**: Use for generating PIX QR codes and payment barcodes.

### Notifications & Alerts
- **vue-toastification**: Use for user feedback notifications (deposit success, validation errors, copy-to-clipboard alerts).

### Backend & Admin Management
- **Filament v3**: Use for admin panels, resources, relations, and table builders (`app/Filament/`).
- **Spatie Permission**: Use for managing user roles, permissions, and guard checks.

---

## Code & File Organization
- **Vue Components & Pages**: Place in `resources/js/` (`Pages/`, `Components/`, `Layouts/`, `Stores/`, `Services/`).
- **Backend Logic**: Place controllers in `app/Http/Controllers/`, models in `app/Models/`, Filament resources in `app/Filament/`.
- **Routes**: Organize route definitions in `routes/web.php`, `routes/api.php`, and sub-modules in `routes/groups/`.
- **Modular Domains**: Place modular packages under `Modules/` managed with `nwidart/laravel-modules`.
