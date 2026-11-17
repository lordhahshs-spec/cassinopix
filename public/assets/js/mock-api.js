/**
 * Robust in-browser Mock API Interceptor for static environments (Vercel, preview, GitHub Pages)
 * Accurately implements XMLHttpRequest and fetch interfaces for Axios and Vue.
 */
(function () {
  const RealXMLHttpRequest = window.XMLHttpRequest;
  const RealFetch = window.fetch;

  const mockSetting = {
    id: 1,
    software_name: 'GamesPix',
    software_description: 'Aposte com confiança no melhor cassino online com saques via PIX imediatos.',
    software_favicon: '01JNANKYEEM27MVWCWHK9Q5HVV.png',
    software_logo_white: '01JNANKYEEM27MVWCWHK9Q5HVV.png',
    software_logo_black: '01JNANKYEEM27MVWCWHK9Q5HVV.png',
    currency_code: 'BRL',
    decimal_format: 'dot',
    currency_position: 'left',
    prefix: 'R$',
    storage: 'local',
    min_deposit: 10,
    max_deposit: 10000,
    min_withdrawal: 20,
    max_withdrawal: 5000,
    initial_bonus: 100,
    suitpay_is_enable: 1,
    disable_spin: 0
  };

  const pgSoftProvider = { id: 1, name: 'PGSOFT', code: 'PGSOFT', cover: null, status: 1 };
  const pragmaticProvider = { id: 2, name: 'PRAGMATIC PLAY', code: 'PRAGMATICGS', cover: null, status: 1 };
  const originaisProvider = { id: 3, name: 'ORIGINAIS', code: 'ORIGINAIS', cover: null, status: 1 };

  const pgSoftGames = [
    { id: 1, provider_id: 1, game_name: 'Fortune Tiger', game_code: 'fortune-tiger', cover: 'ProftGames/PGSOFT_fortune-tiger.avif', distribution: 'proftgames', status: 1, views: 9800, is_featured: 1, show_home: 1, provider: pgSoftProvider },
    { id: 2, provider_id: 1, game_name: 'Fortune Ox', game_code: 'fortune-ox', cover: 'ProftGames/PGSOFT_fortune-ox.avif', distribution: 'proftgames', status: 1, views: 8700, is_featured: 1, show_home: 1, provider: pgSoftProvider },
    { id: 3, provider_id: 1, game_name: 'Fortune Rabbit', game_code: 'fortune-rabbit', cover: 'ProftGames/PGSOFT_fortune-rabbit.avif', distribution: 'proftgames', status: 1, views: 8200, is_featured: 1, show_home: 1, provider: pgSoftProvider },
    { id: 4, provider_id: 1, game_name: 'Fortune Dragon', game_code: 'fortune-dragon', cover: 'ProftGames/PGSOFT_fortune-dragon.avif', distribution: 'proftgames', status: 1, views: 7900, is_featured: 1, show_home: 1, provider: pgSoftProvider },
    { id: 5, provider_id: 1, game_name: 'Fortune Mouse', game_code: 'fortune-mouse', cover: 'ProftGames/PGSOFT_fortune-mouse.avif', distribution: 'proftgames', status: 1, views: 7100, is_featured: 1, show_home: 1, provider: pgSoftProvider },
    { id: 6, provider_id: 1, game_name: 'Ganesha Gold', game_code: 'ganesha-gold', cover: 'ProftGames/PGSOFT_ganesha-gold.avif', distribution: 'proftgames', status: 1, views: 6400, is_featured: 1, show_home: 1, provider: pgSoftProvider },
    { id: 7, provider_id: 1, game_name: 'Double Fortune', game_code: 'double-fortune', cover: 'ProftGames/PGSOFT_double-fortune.avif', distribution: 'proftgames', status: 1, views: 5800, is_featured: 0, show_home: 1, provider: pgSoftProvider },
    { id: 8, provider_id: 1, game_name: 'Bikini Paradise', game_code: 'bikini-paradise', cover: 'ProftGames/PGSOFT_bikini-paradise.avif', distribution: 'proftgames', status: 1, views: 5400, is_featured: 0, show_home: 1, provider: pgSoftProvider },
    { id: 9, provider_id: 1, game_name: 'Jungle Delight', game_code: 'jungle-delight', cover: 'ProftGames/PGSOFT_jungle-delight.avif', distribution: 'proftgames', status: 1, views: 5100, is_featured: 0, show_home: 1, provider: pgSoftProvider },
    { id: 10, provider_id: 1, game_name: 'Dragon Tiger Luck', game_code: 'dragon-tiger-luck', cover: 'ProftGames/PGSOFT_dragon-tiger-luck.avif', distribution: 'proftgames', status: 1, views: 4900, is_featured: 0, show_home: 1, provider: pgSoftProvider }
  ];

  const pragmaticGames = [
    { id: 11, provider_id: 2, game_name: 'Gates of Olympus', game_code: 'vs20olympgate', cover: 'ProftGames/PRAGMATIC_PLAY_vs20olympgate.png', distribution: 'proftgames', status: 1, views: 9200, is_featured: 1, show_home: 1, provider: pragmaticProvider },
    { id: 12, provider_id: 2, game_name: 'Sweet Bonanza', game_code: 'vs20fruitsw', cover: 'ProftGames/PRAGMATIC_PLAY_vs20fruitsw.png', distribution: 'proftgames', status: 1, views: 8600, is_featured: 1, show_home: 1, provider: pragmaticProvider },
    { id: 13, provider_id: 2, game_name: 'Sugar Rush', game_code: 'vs20sugarrush', cover: 'ProftGames/PRAGMATIC_PLAY_vs20sugarrush.png', distribution: 'proftgames', status: 1, views: 7800, is_featured: 0, show_home: 1, provider: pragmaticProvider },
    { id: 14, provider_id: 2, game_name: 'Big Bass Bonanza', game_code: 'vs10bbbonanza', cover: 'ProftGames/PRAGMATIC_PLAY_vs10bbbonanza.png', distribution: 'proftgames', status: 1, views: 7400, is_featured: 0, show_home: 1, provider: pragmaticProvider },
    { id: 15, provider_id: 2, game_name: 'The Dog House', game_code: 'vs20doghouse', cover: 'ProftGames/PRAGMATIC_PLAY_vs20doghouse.png', distribution: 'proftgames', status: 1, views: 6900, is_featured: 0, show_home: 1, provider: pragmaticProvider },
    { id: 16, provider_id: 2, game_name: 'Starlight Princess', game_code: 'vs20starlight', cover: 'ProftGames/PRAGMATIC_PLAY_vs20starlight.png', distribution: 'proftgames', status: 1, views: 6700, is_featured: 0, show_home: 1, provider: pragmaticProvider }
  ];

  const originaisGames = [
    { id: 17, provider_id: 3, game_name: 'Mines', game_code: 'mg-mines', cover: 'ProftGames/ORIGINAIS_mg-mines.png', distribution: 'proftgames', status: 1, views: 9100, is_featured: 1, show_home: 1, provider: originaisProvider },
    { id: 18, provider_id: 3, game_name: 'Crash', game_code: 'mg-crash', cover: 'ProftGames/ORIGINAIS_mg-crash.png', distribution: 'proftgames', status: 1, views: 8400, is_featured: 1, show_home: 1, provider: originaisProvider },
    { id: 19, provider_id: 3, game_name: 'Double', game_code: 'mg-double', cover: 'ProftGames/ORIGINAIS_mg-double.png', distribution: 'proftgames', status: 1, views: 7600, is_featured: 0, show_home: 1, provider: originaisProvider },
    { id: 20, provider_id: 3, game_name: 'Plinko', game_code: 'mg-plinko', cover: 'ProftGames/ORIGINAIS_mg-plinko.png', distribution: 'proftgames', status: 1, views: 7200, is_featured: 0, show_home: 1, provider: originaisProvider },
    { id: 21, provider_id: 3, game_name: 'Dice', game_code: 'mg-dice', cover: 'ProftGames/ORIGINAIS_mg-dice.png', distribution: 'proftgames', status: 1, views: 6500, is_featured: 0, show_home: 1, provider: originaisProvider },
    { id: 22, provider_id: 3, game_name: 'Roulette', game_code: 'mg-roulette', cover: 'ProftGames/ORIGINAIS_mg-roulette.png', distribution: 'proftgames', status: 1, views: 6200, is_featured: 0, show_home: 1, provider: originaisProvider }
  ];

  const allGames = [...pgSoftGames, ...pragmaticGames, ...originaisGames];

  const mockCategories = [
    { id: 1, name: 'Fortune Tiger', slug: 'fortune-tiger', image: 'ProftGames/PGSOFT_fortune-tiger.avif' },
    { id: 2, name: 'Slots PG Soft', slug: 'slots', image: 'ProftGames/PGSOFT_fortune-ox.avif' },
    { id: 3, name: 'Pragmatic Play', slug: 'pragmatic', image: 'ProftGames/PRAGMATIC_PLAY_vs20olympgate.png' },
    { id: 4, name: 'Originais', slug: 'originais', image: 'ProftGames/ORIGINAIS_mg-mines.png' }
  ];

  const mockBanners = [
    { id: 1, image: '01JNAP0R343RKW3A0EEMCCEQN1.jpg', type: 'carousel', description: 'Banner 1', link: '#' },
    { id: 2, image: '01JNAP18JB8Q78JB9NN7KYKCA6.jpg', type: 'carousel', description: 'Banner 2', link: '#' },
    { id: 3, image: '01JNAP1QXK77NK48ZMVFDZ2EVX.jpg', type: 'home', description: 'Promoção 1', link: '#' },
    { id: 4, image: '01JNAP24CQ6YEY225XAEF71M1J.jpg', type: 'home', description: 'Promoção 2', link: '#' },
    { id: 5, image: '01JNAP0R343RKW3A0EEMCCEQN1.jpg', type: 'home', description: 'Promoção 3', link: '#' }
  ];

  function getMockData(rawUrl) {
    const url = (rawUrl || '').split('?')[0];

    if (url.includes('/suitpay/consult-status-transaction')) {
      return { status: 200, data: { status: 'pendente' } };
    }

    if (url.includes('/settings/data') || url.endsWith('/api/settings')) {
      return { status: 200, data: { setting: mockSetting } };
    }

    if (url.includes('/settings/banners') || url.includes('/banners')) {
      return { status: 200, data: { banners: mockBanners } };
    }

    if (url.includes('/categories')) {
      return { status: 200, data: { categories: mockCategories } };
    }

    if (url.includes('/games/all')) {
      return {
        status: 200,
        data: {
          providers: [
            { ...pgSoftProvider, games: pgSoftGames },
            { ...pragmaticProvider, games: pragmaticGames },
            { ...originaisProvider, games: originaisGames }
          ]
        }
      };
    }

    if (url.includes('/featured/games')) {
      return {
        status: 200,
        data: { featured_games: allGames.filter(g => g.is_featured === 1) }
      };
    }

    if (url.includes('/casinos/games') || url.includes('/search/games')) {
      return {
        status: 200,
        data: {
          games: {
            data: allGames,
            current_page: 1,
            last_page: 1,
            total: allGames.length
          }
        }
      };
    }

    if (url.includes('/missions')) {
      return { status: 200, data: { missions: [] } };
    }

    if (url.includes('/roulette')) {
      return { status: 200, data: { spins: 0, free_spins: [] } };
    }

    if (url.includes('/profile/getLanguage') || url.includes('/getLanguage')) {
      return { status: 200, data: { language: 'pt_BR' } };
    }

    if (url.includes('/auth/verify') || url.includes('/profile') || url.includes('/user')) {
      const token = localStorage.getItem('token');
      if (token) {
        return {
          status: 200,
          data: {
            user: { id: 1, name: 'Jogador', email: 'jogador@teste.com', balance: 50.0 },
            status: true
          }
        };
      }
      return { status: 401, data: { message: 'Unauthenticated.' } };
    }

    return { status: 200, data: {} };
  }

  function shouldMock(rawUrl) {
    if (!rawUrl) return false;
    const url = String(rawUrl).toLowerCase();
    return url.includes('/api/') || url.includes('/suitpay/') || url.includes('categories') || url.includes('banners') || url.includes('settings');
  }

  // Standalone MockXMLHttpRequest
  class MockXMLHttpRequest extends EventTarget {
    constructor() {
      super();
      this.readyState = 0;
      this.status = 0;
      this.statusText = '';
      this.responseText = '';
      this.response = '';
      this.responseType = '';
      this.responseURL = '';
      this.withCredentials = false;
      this.timeout = 0;
      this.upload = new EventTarget();

      this._headers = {};
      this._responseHeaders = {
        'content-type': 'application/json; charset=utf-8',
        'cache-control': 'no-cache'
      };

      this.onreadystatechange = null;
      this.onload = null;
      this.onloadstart = null;
      this.onloadend = null;
      this.onerror = null;
      this.ontimeout = null;
      this.onabort = null;
      this.onprogress = null;
    }

    open(method, url) {
      this._method = method;
      this._url = url;
      this.responseURL = url;
      this.readyState = 1;
      this._dispatch('readystatechange');
    }

    setRequestHeader(key, val) {
      this._headers[String(key).toLowerCase()] = val;
    }

    send() {
      this._dispatch('loadstart');

      const mock = getMockData(this._url);
      const jsonStr = JSON.stringify(mock.data);

      setTimeout(() => {
        this.status = mock.status;
        this.statusText = mock.status === 200 ? 'OK' : (mock.status === 401 ? 'Unauthorized' : 'Not Found');
        this.responseText = jsonStr;
        this.response = this.responseType === 'json' ? mock.data : jsonStr;
        this.readyState = 4;

        this._dispatch('readystatechange');

        if (mock.status >= 200 && mock.status < 300) {
          this._dispatch('load');
        } else {
          this._dispatch('error');
        }

        this._dispatch('loadend');
      }, 5);
    }

    abort() {
      this.readyState = 0;
      this._dispatch('abort');
      this._dispatch('loadend');
    }

    getAllResponseHeaders() {
      return Object.entries(this._responseHeaders)
        .map(([k, v]) => `${k}: ${v}\r\n`)
        .join('');
    }

    getResponseHeader(name) {
      return this._responseHeaders[String(name).toLowerCase()] || null;
    }

    overrideMimeType() {}

    _dispatch(eventName) {
      const evt = new Event(eventName);
      const fn = this['on' + eventName];
      if (typeof fn === 'function') {
        try {
          fn.call(this, evt);
        } catch (e) {
          console.error('[MockXHR Handler Error]', e);
        }
      }
      this.dispatchEvent(evt);
    }
  }

  // Intercept window.XMLHttpRequest dynamically
  window.XMLHttpRequest = function () {
    const mockXhr = new MockXMLHttpRequest();
    let realXhr = null;
    let isMock = true;

    return new Proxy(mockXhr, {
      get(target, prop) {
        if (!isMock && realXhr) {
          const val = realXhr[prop];
          return typeof val === 'function' ? val.bind(realXhr) : val;
        }
        const val = target[prop];
        return typeof val === 'function' ? val.bind(target) : val;
      },
      set(target, prop, value) {
        if (!isMock && realXhr) {
          realXhr[prop] = value;
          return true;
        }
        target[prop] = value;
        return true;
      }
    });
  };

  // Keep prototype intact for instanceof checks
  window.XMLHttpRequest.prototype = RealXMLHttpRequest.prototype;

  // Intercept window.fetch
  window.fetch = function (input, init) {
    const url = typeof input === 'string' ? input : input?.url;
    if (shouldMock(url)) {
      const mock = getMockData(url);
      return Promise.resolve(new Response(JSON.stringify(mock.data), {
        status: mock.status,
        headers: { 'Content-Type': 'application/json' }
      }));
    }
    return RealFetch.call(window, input, init);
  };
})();
