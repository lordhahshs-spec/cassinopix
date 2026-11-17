<?php

namespace App\Http\Controllers\Api\Wallet;

use App\Http\Controllers\Controller;
use App\Models\Deposit;
use App\Traits\Gateways\SuitpayTrait;
use Illuminate\Http\Request;

class DepositController extends Controller
{
    use SuitpayTrait;

    /**
     * @param Request $request
     * @return array|false[]
     */
    public function submitPayment(Request $request)
    {
        return self::requestQrcode($request);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function consultStatusTransactionPix(Request $request)
    {
        return self::consultStatusTransaction();
    }

    /**
     * Status do PIX gerado (o modal consulta a cada poucos segundos para mostrar a confirmação).
     * Só lê o banco: quem confirma o pagamento é o webhook da Ecompag.
     */
    public function paymentStatus($id)
    {
        $tx = \App\Models\Transaction::where('user_id', auth('api')->id())
            ->where(function ($q) use ($id) {
                $q->where('external_id', $id)->orWhere('payment_id', $id);
            })
            ->latest('id')
            ->first();

        if (!$tx) {
            return response()->json(['paid' => false, 'status' => 'not_found']);
        }

        $paid = (int) $tx->status === 1;

        return response()->json([
            'paid'    => $paid,
            'status'  => $paid ? 'PAID' : 'PENDING',
            'amount'  => (float) $tx->price,
            'balance' => $paid ? (float) optional(\App\Models\Wallet::where('user_id', auth('api')->id())->first())->balance : null,
        ]);
    }

    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $deposits = Deposit::whereUserId(auth('api')->id())->paginate();
        return response()->json(['deposits' => $deposits], 200);
    }

}
