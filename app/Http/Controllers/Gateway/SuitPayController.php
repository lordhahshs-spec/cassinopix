<?php

namespace App\Http\Controllers\Gateway;

use App\Http\Controllers\Controller;
use App\Models\Gateway;
use App\Models\Withdrawal;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class SuitPayController extends Controller
{
    use \App\Traits\Gateways\SuitpayTrait;

    /**
     * Consulta de backup do PIX (o site chama a cada poucos segundos).
     * Roda no máximo 1x a cada 30s para não sobrecarregar o banco nem a Ecompag; o webhook é quem confirma na hora.
     */
    public function consultStatusTransactionPix(Request $request)
    {
        if (!\Illuminate\Support\Facades\Cache::add('ecompag_consulta_backup', 1, 30)) {
            return response()->json(['status' => 'pendente']);
        }

        return self::consultStatusTransaction();
    }

    /**
     * Processar saque via Ecompag PIX
     */
    public function withdrawal(Request $request)
    {
        $withdrawalId = $request->input('id');

        try {
            $withdrawal = Withdrawal::with('user')->find($withdrawalId);
            
            if (!$withdrawal) {
                return redirect()->back()->with('error', 'Saque não encontrado');
            }

            if ($withdrawal->status == 1) {
                return redirect()->back()->with('error', 'Este saque já foi processado');
            }

            // Buscar credenciais (usa os mesmos campos da suitpay)
            $gateway = Gateway::first();
            
            if (!$gateway || !$gateway->suitpay_cliente_id || !$gateway->suitpay_cliente_secret) {
                return redirect()->back()->with('error', 'Gateway não configurado');
            }

            // Validações
            $user = $withdrawal->user;
            if (!$user->cpf) {
                return redirect()->back()->with('error', 'CPF do usuário não cadastrado');
            }

            if (!$withdrawal->pix_key) {
                return redirect()->back()->with('error', 'Chave PIX não informada');
            }

            // API Ecompag - endpoint de transferência
            $apiUrl = 'https://api.ecompag.com/v2/pix/payment.php';
            
            $postData = [
                'client_id' => $gateway->suitpay_cliente_id,
                'client_secret' => $gateway->suitpay_cliente_secret,
                'nome' => trim($user->name . ' ' . ($user->last_name ?? '')),
                'cpf' => preg_replace('/[^0-9]/', '', $user->cpf),
                'valor' => floatval($withdrawal->amount),
                'chave_pix' => $withdrawal->pix_key,
                'urlnoty' => url('/api/suitpay/webhook')
            ];

            Log::info('Ecompag: Iniciando transferência', [
                'withdrawal_id' => $withdrawal->id,
                'amount' => $withdrawal->amount,
            ]);

            // Fazer requisição
            $response = Http::asForm()->timeout(30)->post($apiUrl, $postData);
            $statusCode = $response->status();
            $responseData = $response->json();

            Log::info('Ecompag: Resposta', [
                'status' => $statusCode,
                'data' => $responseData
            ]);

            // Verificar sucesso - API Ecompag retorna objeto direto, não array
            if ($statusCode === 200 && isset($responseData['statusCode']) && $responseData['statusCode'] == 200) {
                
                $transactionId = $responseData['transactionId'] ?? null;
                $externalId = $responseData['external_id'] ?? $transactionId;
                
                $withdrawal->update([
                    'status' => 1,
                    'bank_info' => json_encode([
                        'transaction_id' => $transactionId,
                        'external_id' => $externalId,
                        'message' => $responseData['message'] ?? 'Transferência processada',
                        'processed_at' => now()->format('Y-m-d H:i:s')
                    ])
                ]);

                Log::info('Ecompag: Saque aprovado', [
                    'withdrawal_id' => $withdrawal->id,
                    'transaction_id' => $transactionId
                ]);

                return redirect()
                    ->route('filament.admin.resources.todos-saques.index')
                    ->with('success', 'Saque processado com sucesso! ID: ' . $transactionId);
            }

            // Erro
            $errorMessage = $responseData['message'] ?? 'Erro ao processar transferência';
            
            Log::error('Ecompag: Erro', [
                'withdrawal_id' => $withdrawal->id,
                'error' => $errorMessage
            ]);

            return redirect()
                ->route('filament.admin.resources.todos-saques.index')
                ->with('error', 'Erro: ' . $errorMessage);

        } catch (\Exception $e) {
            Log::error('Ecompag: Exception', [
                'error' => $e->getMessage()
            ]);

            return redirect()
                ->route('filament.admin.resources.todos-saques.index')
                ->with('error', 'Erro: ' . $e->getMessage());
        }
    }

    /**
     * Processar saque via modal (recebe parâmetros na URL)
     * URL: /suitpay/withdrawal/{id}/{action}
     */
    public function withdrawalFromModal($id, $action)
    {
        try {
            $withdrawal = Withdrawal::with('user')->find($id);
            
            if (!$withdrawal) {
                return redirect()->back()->with('error', 'Saque não encontrado');
            }

            if ($withdrawal->status == 1) {
                return redirect()->back()->with('error', 'Este saque já foi processado');
            }

            // Buscar credenciais
            $gateway = Gateway::first();
            
            if (!$gateway || !$gateway->suitpay_cliente_id || !$gateway->suitpay_cliente_secret) {
                return redirect()->back()->with('error', 'Gateway não configurado');
            }

            // Validações
            $user = $withdrawal->user;
            if (!$user->cpf) {
                return redirect()->back()->with('error', 'CPF do usuário não cadastrado');
            }

            if (!$withdrawal->pix_key) {
                return redirect()->back()->with('error', 'Chave PIX não informada');
            }

            // API Ecompag
            $apiUrl = 'https://api.ecompag.com/v2/pix/payment.php';
            
            $postData = [
                'client_id' => $gateway->suitpay_cliente_id,
                'client_secret' => $gateway->suitpay_cliente_secret,
                'nome' => trim($user->name . ' ' . ($user->last_name ?? '')),
                'cpf' => preg_replace('/[^0-9]/', '', $user->cpf),
                'valor' => floatval($withdrawal->amount),
                'chave_pix' => $withdrawal->pix_key,
                'urlnoty' => url('/api/suitpay/webhook')
            ];

            Log::info('Ecompag: Iniciando transferência (modal)', [
                'withdrawal_id' => $withdrawal->id,
                'amount' => $withdrawal->amount,
            ]);

            $response = Http::asForm()->timeout(30)->post($apiUrl, $postData);
            $statusCode = $response->status();
            $responseData = $response->json();

            Log::info('Ecompag: Resposta', [
                'status' => $statusCode,
                'data' => $responseData
            ]);

            // Verificar sucesso - API Ecompag retorna objeto direto, não array
            if ($statusCode === 200 && isset($responseData['statusCode']) && $responseData['statusCode'] == 200) {
                
                $transactionId = $responseData['transactionId'] ?? null;
                $externalId = $responseData['external_id'] ?? $transactionId;
                
                $withdrawal->update([
                    'status' => 1,
                    'bank_info' => json_encode([
                        'transaction_id' => $transactionId,
                        'external_id' => $externalId,
                        'message' => $responseData['message'] ?? 'Transferência processada',
                        'processed_at' => now()->format('Y-m-d H:i:s')
                    ])
                ]);

                Log::info('Ecompag: Saque aprovado', [
                    'withdrawal_id' => $withdrawal->id,
                    'transaction_id' => $transactionId
                ]);

                return redirect()
                    ->route('filament.admin.resources.todos-saques.index')
                    ->with('success', 'Saque processado com sucesso! ID: ' . $transactionId);
            }

            $errorMessage = $responseData['message'] ?? 'Erro ao processar transferência';
            
            Log::error('Ecompag: Erro', [
                'withdrawal_id' => $withdrawal->id,
                'error' => $errorMessage
            ]);

            return redirect()
                ->route('filament.admin.resources.todos-saques.index')
                ->with('error', 'Erro: ' . $errorMessage);

        } catch (\Exception $e) {
            Log::error('Ecompag: Exception', [
                'error' => $e->getMessage()
            ]);

            return redirect()
                ->route('filament.admin.resources.todos-saques.index')
                ->with('error', 'Erro: ' . $e->getMessage());
        }
    }

    /**
     * Cancelar saque
     */
    public function cancelWithdrawal(Request $request)
    {
        $withdrawalId = $request->input('id');

        try {
            $withdrawal = Withdrawal::with('user')->find($withdrawalId);
            
            if (!$withdrawal) {
                return redirect()->back()->with('error', 'Saque não encontrado');
            }

            if ($withdrawal->status == 1) {
                return redirect()->back()->with('error', 'Saque já processado, não pode ser cancelado');
            }

            // Devolver saldo
            \App\Models\Wallet::where('user_id', $withdrawal->user_id)->increment('balance', $withdrawal->amount);

            $withdrawal->update([
                'status' => 2,
                'bank_info' => json_encode([
                    'cancelled_at' => now()->format('Y-m-d H:i:s'),
                    'cancelled_by' => auth()->user()->name ?? 'Sistema'
                ])
            ]);

            Log::info('Ecompag: Saque cancelado', [
                'withdrawal_id' => $withdrawal->id,
                'amount_returned' => $withdrawal->amount
            ]);

            return redirect()
                ->route('filament.admin.resources.todos-saques.index')
                ->with('success', 'Saque cancelado e saldo devolvido');

        } catch (\Exception $e) {
            Log::error('Ecompag: Erro ao cancelar', [
                'error' => $e->getMessage()
            ]);

            return redirect()
                ->route('filament.admin.resources.todos-saques.index')
                ->with('error', 'Erro ao cancelar: ' . $e->getMessage());
        }
    }

    /**
     * Cancelar saque via modal (recebe parâmetros na URL)
     */
    public function cancelWithdrawalFromModal($id, $action)
    {
        try {
            $withdrawal = Withdrawal::with('user')->find($id);
            
            if (!$withdrawal) {
                return redirect()->back()->with('error', 'Saque não encontrado');
            }

            if ($withdrawal->status == 1) {
                return redirect()->back()->with('error', 'Saque já processado, não pode ser cancelado');
            }

            // Devolver saldo
            \App\Models\Wallet::where('user_id', $withdrawal->user_id)->increment('balance', $withdrawal->amount);

            $withdrawal->update([
                'status' => 2,
                'bank_info' => json_encode([
                    'cancelled_at' => now()->format('Y-m-d H:i:s'),
                    'cancelled_by' => auth()->user()->name ?? 'Sistema'
                ])
            ]);

            Log::info('Ecompag: Saque cancelado (modal)', [
                'withdrawal_id' => $withdrawal->id,
                'amount_returned' => $withdrawal->amount
            ]);

            return redirect()
                ->route('filament.admin.resources.todos-saques.index')
                ->with('success', 'Saque cancelado e saldo devolvido');

        } catch (\Exception $e) {
            Log::error('Ecompag: Erro ao cancelar', [
                'error' => $e->getMessage()
            ]);

            return redirect()
                ->route('filament.admin.resources.todos-saques.index')
                ->with('error', 'Erro ao cancelar: ' . $e->getMessage());
        }
    }

    /**
     * Webhook Ecompag - Processa depósitos e saques
     */
    public function webhook(Request $request)
    {
        try {
            $data = $request->all();
            
            Log::info('Ecompag Webhook recebido', ['data' => $data]);

            if (!$data) {
                return response()->json(['status' => 'error'], 400);
            }

            // Verificar se os dados estão dentro de requestBody
            if (isset($data['requestBody'])) {
                $data = $data['requestBody'];
                Log::info('Ecompag Webhook: Extraído de requestBody', ['data' => $data]);
            }

            $transactionType = $data['transactionType'] ?? null;

            // ============================================
            // WEBHOOK DE DEPÓSITO (Recebimento PIX)
            // ============================================
            if ($transactionType === 'RECEIVEPIX') {
                $status = $data['status'] ?? null;
                $amount = $data['amount'] ?? null;

                // Ecompag manda transactionId (e às vezes external_id): acha a transação local por qualquer um
                $ids = array_values(array_filter([$data['external_id'] ?? null, $data['transactionId'] ?? null]));
                $externalId = null;
                if ($ids) {
                    $tx = \App\Models\Transaction::where(function ($q) use ($ids) {
                        $q->whereIn('external_id', $ids)->orWhereIn('payment_id', $ids);
                    })->first();
                    $externalId = $tx->external_id ?? null;
                }

                Log::info('Ecompag Webhook: DEPÓSITO', [
                    'external_id' => $externalId,
                    'status' => $status,
                    'amount' => $amount
                ]);

                if ($status === 'PAID' && $externalId) {
                    // Chamar trait para finalizar o pagamento
                    $result = \App\Traits\Gateways\SuitpayTrait::finalizePaymentViaWebhook($externalId);
                    
                    if ($result) {
                        Log::info('Ecompag Webhook: Depósito confirmado ✅', [
                            'external_id' => $externalId
                        ]);
                        
                        return response()->json(['status' => 'success', 'message' => 'Depósito processado'], 200);
                    } else {
                        Log::error('Ecompag Webhook: Falha ao processar depósito', [
                            'external_id' => $externalId
                        ]);
                    }
                }
            }

            // ============================================
            // WEBHOOK DE SAQUE (Transferência PIX)
            // ============================================
            if ($transactionType === 'PAYMENT') {
                $transactionId = $data['transactionId'] ?? null;
                $externalId = $data['external_id'] ?? $transactionId;
                $statusId = $data['statusCode']['statusId'] ?? null;

                Log::info('Ecompag Webhook: SAQUE', [
                    'transaction_id' => $transactionId,
                    'external_id' => $externalId,
                    'status_id' => $statusId
                ]);

                if ($statusId == 1 && $externalId) {
                    // Buscar pelo external_id que foi salvo no bank_info
                    $withdrawals = Withdrawal::where(function ($q) use ($externalId, $transactionId) {
                        $q->whereRaw("JSON_UNQUOTE(JSON_EXTRACT(bank_info, '$.external_id')) = ?", [$externalId])
                          ->orWhereRaw("JSON_UNQUOTE(JSON_EXTRACT(bank_info, '$.transaction_id')) = ?", [(string)$transactionId]);
                    })->get();

                    if ($withdrawals->isEmpty()) {
                        Log::warning('Ecompag Webhook: Nenhum saque encontrado', [
                            'external_id' => $externalId,
                            'transaction_id' => $transactionId
                        ]);
                    }

                    foreach ($withdrawals as $withdrawal) {
                        $bankInfo = json_decode($withdrawal->bank_info, true) ?? [];
                        $bankInfo['webhook_confirmed'] = now()->format('Y-m-d H:i:s');
                        $bankInfo['webhook_transaction_id'] = $transactionId;
                        $bankInfo['webhook_status_id'] = $statusId;

                        $withdrawal->update([
                            'status' => 1,
                            'bank_info' => json_encode($bankInfo)
                        ]);

                        Log::info('Ecompag Webhook: Saque confirmado ✅', [
                            'withdrawal_id' => $withdrawal->id,
                            'external_id' => $externalId,
                            'transaction_id' => $transactionId
                        ]);
                    }
                }
            }

            return response()->json(['status' => 'success'], 200);

        } catch (\Exception $e) {
            Log::error('Ecompag Webhook erro', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);

            return response()->json(['status' => 'error'], 500);
        }
    }
}