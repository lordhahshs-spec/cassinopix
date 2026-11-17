<x-filament-panels::page>
    <style>
        .la-grid { display: grid; gap: 1rem; grid-template-columns: repeat(auto-fit, minmax(170px, 1fr)); }
        .la-stat { border-radius: .75rem; padding: 1rem 1.1rem; background: #fff; box-shadow: 0 1px 2px rgba(0,0,0,.06); outline: 1px solid rgba(0,0,0,.06); }
        .dark .la-stat { background: rgb(24 24 27); outline-color: rgba(255,255,255,.08); }
        .la-stat small { display: block; font-size: .78rem; color: #78716c; }
        .la-stat strong { display: block; font-size: 1.35rem; margin-top: .2rem; }
        .la-toolbar { display: flex; flex-wrap: wrap; gap: .5rem; align-items: center; }
        .la-input { width: 100%; max-width: 320px; border-radius: .5rem; border: 1px solid #d6d3d1; padding: .5rem .75rem; font-size: .875rem; background: #fff; color: #333; }
        .la-input:-webkit-autofill,
        .la-input:-webkit-autofill:hover,
        .la-input:-webkit-autofill:focus,
        .la-input:-webkit-autofill:active {
            -webkit-box-shadow: 0 0 0 30px white inset !important;
            box-shadow: 0 0 0 30px white inset !important;
            -webkit-text-fill-color: #333 !important;
            transition: background-color 5000s ease-in-out 0s;
        }
        .la-chips { display: flex; flex-wrap: wrap; gap: .4rem; }
        .la-chip { border-radius: 999px; padding: .3rem .75rem; font-size: .8rem; border: 1px solid #d6d3d1; cursor: pointer; background: transparent; }
        .la-chip.on { background: #eab308; border-color: #eab308; color: #1c1917; font-weight: 600; }
        .la-list { display: grid; gap: .6rem; grid-template-columns: repeat(auto-fill, minmax(150px, 1fr)); }
        .la-item { position: relative; border-radius: .6rem; overflow: hidden; outline: 1px solid rgba(0,0,0,.08); background: #fafaf9; cursor: pointer; }
        .dark .la-item { background: rgb(39 39 42); outline-color: rgba(255,255,255,.08); }
        .la-item.on { outline: 2px solid #eab308; }
        .la-thumb { aspect-ratio: 1/1; display: flex; align-items: center; justify-content: center; background: repeating-conic-gradient(#e7e5e4 0 25%, #f5f5f4 0 50%) 0 0/16px 16px; }
        .dark .la-thumb { background: rgb(63 63 70); }
        .la-thumb img { max-width: 100%; max-height: 100%; object-fit: contain; }
        .la-thumb svg { width: 42px; height: 42px; color: #a8a29e; }
        .la-meta { padding: .45rem .55rem; font-size: .72rem; line-height: 1.25; }
        .la-meta b { display: block; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; font-weight: 600; }
        .la-meta span { color: #78716c; }
        .la-check { position: absolute; top: .4rem; left: .4rem; width: 1.1rem; height: 1.1rem; accent-color: #eab308; }
        .la-table { width: 100%; font-size: .85rem; border-collapse: collapse; }
        .la-table td, .la-table th { padding: .55rem .4rem; border-bottom: 1px solid rgba(0,0,0,.06); text-align: left; }
        .la-note { font-size: .82rem; color: #78716c; }
    </style>

    {{-- Limpeza rápida --}}
    <div class="la-toolbar" style="justify-content:space-between">
        <p class="la-note" style="margin:0">Cache, logs, uploads temporários e imagens que ninguém usa mais.</p>
        <x-filament::button icon="heroicon-o-bolt" wire:click="quickClean" wire:loading.attr="disabled" wire:target="quickClean"
            wire:confirm="Limpar o cache, zerar todos os logs e apagar os uploads temporários agora?">
            <span wire:loading.remove wire:target="quickClean">Limpeza rápida (cache + logs + temporários)</span>
            <span wire:loading wire:target="quickClean">Limpando...</span>
        </x-filament::button>
    </div>

    {{-- Cache --}}
    <x-filament::section>
        <x-slot name="heading">Cache</x-slot>
        <x-slot name="description">
            Limpa config, rotas, views e cache do Laravel, componentes do Filament e o OPcache do PHP.
            Use depois de enviar arquivos novos para o servidor ou quando uma alteração não aparecer no site.
        </x-slot>
        <x-filament::button color="gray" icon="heroicon-o-arrow-path" wire:click="clearCache" wire:loading.attr="disabled" wire:target="clearCache">
            <span wire:loading.remove wire:target="clearCache">Limpar cache</span>
            <span wire:loading wire:target="clearCache">Limpando...</span>
        </x-filament::button>
    </x-filament::section>

    {{-- Logs --}}
    <x-filament::section>
        <x-slot name="heading">Logs</x-slot>
        <x-slot name="description">
            O <code>laravel.log</code> é esvaziado (o sistema continua escrevendo nele). Logs diários antigos são apagados.
        </x-slot>
        @if(count($logs))
            <div style="overflow-x:auto">
                <table class="la-table">
                    <thead><tr><th style="width:30px"></th><th>Arquivo</th><th style="text-align:right">Tamanho</th></tr></thead>
                    <tbody>
                        @foreach($logs as $log)
                            <tr wire:key="log-{{ md5($log['path']) }}">
                                <td><input type="checkbox" value="{{ $log['path'] }}" wire:model.live="selectedLogs" style="accent-color:#eab308"></td>
                                <td><code>{{ $log['path'] }}</code></td>
                                <td style="text-align:right;white-space:nowrap">{{ $fmt($log['size']) }}</td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
            <div style="margin-top:1rem">
                <x-filament::button color="danger" outlined icon="heroicon-o-trash" wire:click="clearLogs"
                    wire:confirm="Zerar os logs marcados?">
                    Zerar logs marcados ({{ $fmt(array_sum(array_map(fn ($l) => in_array($l['path'], $selectedLogs, true) ? $l['size'] : 0, $logs))) }})
                </x-filament::button>
            </div>
        @else
            <p class="la-note">Nenhum log encontrado.</p>
        @endif
    </x-filament::section>

    {{-- Imagens e arquivos sem uso --}}
    <x-filament::section>
        <x-slot name="heading">Imagens e arquivos sem uso</x-slot>
        <x-slot name="description">
            Procura em <code>public/storage</code> imagens, músicas e outros arquivos que não aparecem em nenhuma tabela do banco nem no código do site.
            Nada é apagado direto: os arquivos vão para uma lixeira e podem ser restaurados.
        </x-slot>

        <div class="la-toolbar" style="margin-bottom:1rem">
            <x-filament::button wire:click="scan" icon="heroicon-o-magnifying-glass" wire:loading.attr="disabled" wire:target="scan">
                <span wire:loading.remove wire:target="scan">{{ $result ? 'Escanear novamente' : 'Escanear arquivos' }}</span>
                <span wire:loading wire:target="scan">Escaneando, aguarde...</span>
            </x-filament::button>
            @if($result)
                <span class="la-note">Última varredura: {{ $result['scanned_at'] }}</span>
            @endif
        </div>

        @if($result)
            <div class="la-grid">
                <div class="la-stat"><small>Arquivos analisados</small><strong>{{ number_format($result['total_files'], 0, ',', '.') }}</strong></div>
                <div class="la-stat"><small>Ocupando</small><strong>{{ $fmt($result['total_size']) }}</strong></div>
                <div class="la-stat"><small>Sem uso</small><strong style="color:#ca8a04">{{ number_format(count($result['unused']), 0, ',', '.') }}</strong></div>
                <div class="la-stat"><small>Espaço a liberar</small><strong style="color:#16a34a">{{ $fmt($result['unused_size']) }}</strong></div>
            </div>
            @if($result['skipped_recent'] > 0)
                <p class="la-note" style="margin-top:.75rem">
                    {{ $result['skipped_recent'] }} arquivo(s) sem referência foram ignorados por terem sido enviados nas últimas 24h.
                </p>
            @endif
        @else
            <p class="la-note">Clique em "Escanear arquivos" para começar. Pode levar alguns segundos.</p>
        @endif
    </x-filament::section>

    {{-- Uploads temporários --}}
    @if($tmp['count'] > 0)
        <x-filament::section>
            <x-slot name="heading">Uploads temporários</x-slot>
            <x-slot name="description">Sobras de envios do painel com mais de 24h em <code>storage/app/livewire-tmp</code>. Podem ser apagadas sem risco.</x-slot>
            <div class="la-toolbar">
                <span>{{ $tmp['count'] }} arquivo(s), {{ $fmt($tmp['size']) }}</span>
                <x-filament::button color="gray" icon="heroicon-o-trash" wire:click="cleanTmp" wire:confirm="Apagar os uploads temporários antigos?">
                    Limpar temporários
                </x-filament::button>
            </div>
        </x-filament::section>
    @endif

    {{-- Lista de arquivos sem uso --}}
    @if($result && count($result['unused']) > 0)
        <x-filament::section>
            <x-slot name="heading">Arquivos sem uso</x-slot>

            <div style="display:flex;flex-direction:column;gap:.9rem">
                <div class="la-chips">
                    <button type="button" class="la-chip {{ $folder === '' ? 'on' : '' }}" wire:click="$set('folder', '')">
                        Todas ({{ count($result['unused']) }})
                    </button>
                    @foreach($folders as $name => $info)
                        <button type="button" class="la-chip {{ $folder === $name ? 'on' : '' }}" wire:click="$set('folder', '{{ $name }}')">
                            {{ $name }} ({{ $info['count'] }} · {{ $fmt($info['size']) }})
                        </button>
                    @endforeach
                </div>

                <div class="la-toolbar">
                    <input type="text" class="la-input" placeholder="Filtrar por nome..." autocomplete="off" wire:model.live.debounce.400ms="search">
                    <x-filament::button size="sm" color="gray" wire:click="selectAllVisible">Marcar os exibidos</x-filament::button>
                    <x-filament::button size="sm" color="gray" wire:click="clearSelection">Desmarcar</x-filament::button>
                </div>

                <div class="la-toolbar">
                    <x-filament::button color="warning" icon="heroicon-o-archive-box-arrow-down" wire:click="moveSelected"
                        wire:confirm="Mover os arquivos marcados para a lixeira? Eles deixam de aparecer no site.">
                        Mover marcados para a lixeira ({{ count($selected) }} · {{ $fmt($selectedSize) }})
                    </x-filament::button>
                    <x-filament::button color="danger" outlined icon="heroicon-o-archive-box-x-mark" wire:click="moveAll"
                        wire:confirm="Mover TODOS os {{ count($result['unused']) }} arquivos sem uso para a lixeira?">
                        Mover todos ({{ $fmt($result['unused_size']) }})
                    </x-filament::button>
                </div>

                @if($itemsTotal > count($items))
                    <p class="la-note">Mostrando {{ count($items) }} de {{ $itemsTotal }}. Use o filtro ou as pastas para ver o restante; "Marcar os exibidos" marca todos os {{ $itemsTotal }} do filtro atual.</p>
                @endif

                <div class="la-list">
                    @foreach($items as $item)
                        <label class="la-item {{ in_array($item['path'], $selected, true) ? 'on' : '' }}" wire:key="f-{{ md5($item['path']) }}">
                            <input type="checkbox" class="la-check" value="{{ $item['path'] }}" wire:model.live="selected">
                            <div class="la-thumb">
                                @if($item['image'])
                                    <img src="{{ asset('storage/' . $item['path']) }}" loading="lazy" alt="">
                                @else
                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M19.5 14.25v-2.625a3.375 3.375 0 0 0-3.375-3.375h-1.5A1.125 1.125 0 0 1 13.5 7.125v-1.5a3.375 3.375 0 0 0-3.375-3.375H8.25m2.25 0H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 0 0-9-9Z" /></svg>
                                @endif
                            </div>
                            <div class="la-meta">
                                <b title="{{ $item['path'] }}">{{ $item['name'] }}</b>
                                <span>{{ $item['folder'] }} · {{ $fmt($item['size']) }}</span>
                            </div>
                        </label>
                    @endforeach
                </div>
            </div>
        </x-filament::section>
    @elseif($result)
        <x-filament::section>
            <p>Nenhum arquivo sem uso encontrado. O site já está limpo.</p>
        </x-filament::section>
    @endif

    {{-- Lixeira --}}
    @if(count($trash) > 0)
        <x-filament::section>
            <x-slot name="heading">Lixeira</x-slot>
            <x-slot name="description">
                Arquivos movidos ficam em <code>storage/app/lixeira-arquivos</code>, fora do site. Confira se nada quebrou e depois esvazie para liberar o espaço em disco.
            </x-slot>

            <div style="overflow-x:auto">
                <table class="la-table">
                    <thead><tr><th>Movido em</th><th>Arquivos</th><th>Tamanho</th><th></th></tr></thead>
                    <tbody>
                        @foreach($trash as $batch)
                            <tr wire:key="b-{{ $batch['id'] }}">
                                <td>{{ $batch['label'] }}</td>
                                <td>{{ $batch['count'] }}</td>
                                <td>{{ $fmt($batch['size']) }}</td>
                                <td style="text-align:right;white-space:nowrap">
                                    <x-filament::button size="xs" color="gray" icon="heroicon-o-arrow-uturn-left"
                                        wire:click="restoreBatch('{{ $batch['id'] }}')" wire:confirm="Restaurar estes arquivos para o site?">
                                        Restaurar
                                    </x-filament::button>
                                    <x-filament::button size="xs" color="danger" icon="heroicon-o-trash"
                                        wire:click="emptyBatch('{{ $batch['id'] }}')" wire:confirm="Excluir definitivamente este lote? Não dá para desfazer.">
                                        Excluir de vez
                                    </x-filament::button>
                                </td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>

            <div style="margin-top:1rem">
                <x-filament::button color="danger" icon="heroicon-o-trash" wire:click="emptyAllTrash"
                    wire:confirm="Esvaziar a lixeira inteira? Os arquivos serão apagados para sempre.">
                    Esvaziar lixeira ({{ $fmt(array_sum(array_column($trash, 'size'))) }})
                </x-filament::button>
            </div>
        </x-filament::section>
    @endif
</x-filament-panels::page>
