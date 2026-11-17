import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import vue from '@vitejs/plugin-vue';
import i18n from 'laravel-vue-i18n/vite';
import fs from 'node:fs';
import path from 'node:path';

function previewSpaPlugin() {
    return {
        name: 'preview-spa-plugin',
        configureServer(server) {
            server.middlewares.use((req, res, next) => {
                const url = (req.url || '').split('?')[0];

                // Mock API endpoints for Vite preview environment so frontend executes smoothly
                if (url.startsWith('/api/')) {
                    res.setHeader('Content-Type', 'application/json');

                    if (url.includes('/settings/settings/data') || url === '/api/settings') {
                        return res.end(JSON.stringify({
                            setting: {
                                software_name: 'Cassino Online',
                                currency_code: 'BRL',
                                prefix: 'R$',
                                decimal_format: 'pt-BR',
                                min_deposit: 10,
                                max_deposit: 10000,
                                min_withdrawal: 20,
                                max_withdrawal: 5000,
                                initial_bonus: 100,
                                suitpay_is_enable: 1,
                            }
                        }));
                    }

                    if (url.includes('/banners')) {
                        return res.end(JSON.stringify({ banners: [] }));
                    }

                    if (url.includes('/categories')) {
                        return res.end(JSON.stringify({
                            categories: [
                                { id: 1, name: 'Populares', slug: 'populares' },
                                { id: 2, name: 'Slots', slug: 'slots' },
                                { id: 3, name: 'Ao Vivo', slug: 'ao-vivo' },
                                { id: 4, name: 'Roleta', slug: 'roleta' },
                            ]
                        }));
                    }

                    if (url.includes('/games/all') || url.includes('/casinos/games')) {
                        return res.end(JSON.stringify({
                            providers: [],
                            games: { data: [], current_page: 1, last_page: 1 }
                        }));
                    }

                    if (url.includes('/featured/games')) {
                        return res.end(JSON.stringify({ featured_games: [] }));
                    }

                    if (url.includes('/getLanguage')) {
                        return res.end(JSON.stringify({ language: 'pt_BR' }));
                    }

                    if (url.includes('/auth') || url.includes('/user') || url.includes('/profile')) {
                        res.statusCode = 401;
                        return res.end(JSON.stringify({ message: 'Unauthenticated.' }));
                    }

                    return res.end(JSON.stringify({}));
                }

                // Intercept HTML navigation and root so laravel-vite-plugin doesn't block the preview
                if (url === '/' || url === '/index.html' || (!url.includes('.') && req.headers.accept?.includes('text/html'))) {
                    const htmlPath = path.resolve(__dirname, 'index.html');
                    if (fs.existsSync(htmlPath)) {
                        const html = fs.readFileSync(htmlPath, 'utf-8');
                        res.statusCode = 200;
                        res.setHeader('Content-Type', 'text/html');
                        return res.end(html);
                    }
                }

                next();
            });
        }
    };
}

export default defineConfig({
    plugins: [
        previewSpaPlugin(),
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.js'],
            refresh: true,
        }),
        vue({
            template: {
                base: null,
                includeAbsolute: false
            }
        }),
        i18n(),
    ],
    resolve: {
        alias: {}
    }
});
