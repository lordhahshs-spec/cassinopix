<?php

namespace App\Http\Controllers\Api\Profile;

use App\Http\Controllers\Controller;
use App\Models\Deposit;
use App\Models\Order;
use Illuminate\Http\Request;

class ProfileController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $totalEarnings = Order::where('user_id', auth('api')->id())->where('type', 'win')->sum('amount');
        $totalBets = Order::where('user_id', auth('api')->id())->where('type', 'bet')->count();
        $sumBets = Order::where('user_id', auth('api')->id())->where('type', 'bet')->sum('amount');

        return response()->json([
            'status' => true,
            'user' => auth('api')->user(),
            'totalEarnings' => \Helper::amountFormatDecimal($totalEarnings),
            'totalBets' => (int) $totalBets,
            'sumBets' => $sumBets,
        ]);
    }

    /**
     * Salva os dados de PIX do jogador (usados para preencher o saque).
     */
    public function savePix(Request $request)
    {
        $validator = \Validator::make($request->all(), [
            'pix_name' => 'required|string|min:3|max:150',
            'pix_type' => 'required|in:document,email,phoneNumber,randomKey',
            'pix_key'  => 'required|string|max:150',
        ], [
            'pix_name.required' => 'Informe o nome completo do titular.',
            'pix_name.min'      => 'Informe o nome completo do titular.',
            'pix_type.required' => 'Selecione o tipo de chave.',
            'pix_type.in'       => 'Tipo de chave inválido.',
            'pix_key.required'  => 'Informe a chave PIX.',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }

        $key = trim($request->pix_key);
        $digits = preg_replace('/\D/', '', $key);
        switch ($request->pix_type) {
            case 'document':
                if (!in_array(strlen($digits), [11, 14])) {
                    return response()->json(['pix_key' => 'CPF/CNPJ inválido.'], 400);
                }
                $key = $digits;
                break;
            case 'email':
                if (!filter_var($key, FILTER_VALIDATE_EMAIL)) {
                    return response()->json(['pix_key' => 'E-mail inválido.'], 400);
                }
                $key = strtolower($key);
                break;
            case 'phoneNumber':
                if (strlen($digits) < 10 || strlen($digits) > 13) {
                    return response()->json(['pix_key' => 'Telefone inválido.'], 400);
                }
                $key = $digits;
                break;
            case 'randomKey':
                if (strlen($key) < 32) {
                    return response()->json(['pix_key' => 'Chave aleatória inválida.'], 400);
                }
                break;
        }

        $user = auth('api')->user();
        $user->update([
            'pix_name' => trim($request->pix_name),
            'pix_type' => $request->pix_type,
            'pix_key'  => $key,
        ]);

        return response()->json(['status' => true, 'message' => 'Dados de saque salvos!', 'user' => $user->fresh()]);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function updateName(Request $request)
    {
        $rules = [
            'name' => 'required',
        ];

        $validator = \Validator::make($request->all(), $rules);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }

        if(auth('api')->user()->update(['name' => $request->name])) {
            return response()->json(['status' => true, 'message' => trans('Name was updated successfully')]);
        }
    }

    /**
     * Store a newly created resource in storage.
     */
    public function uploadAvatar(Request $request)
    {
        $rules = [
            'avatar' => ['required','image','mimes:jpg,png,jpeg'],
        ];

        $validator = \Validator::make($request->all(), $rules);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }

        $avatar = \Helper::upload($request->avatar)['path'];
        if(auth('api')->user()->update(['avatar' => $avatar])) {
            return response()->json(['status' => true, 'message' => trans('Avatar has been updated successfully')]);
        }
    }

    /**
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function updateLanguage(Request $request)
    {
        if(auth('api')->check()) {
            $user = auth('api')->user();

            $user->language = $request->input('language');
            $user->save();

            return response()->json(['message' => 'Idioma atualizado com sucesso']);
        }
        return response()->json(['message' => 'Idioma atualizado com sucesso, mas com dados salvo na sessão, faça login para salvar em seu perfil']);
    }

    /**
     * @return \Illuminate\Http\JsonResponse
     */
    public function getLanguage(Request $request)
    {
        $browserLanguages = $request->getLanguages();

        $preferredLanguage = $browserLanguages[0] ?? 'en';
        if(auth('api')->check()) {
            return response()->json(['language' => auth('api')->user()->language]);
        }

        return response()->json(['language' => $preferredLanguage]);
    }
}
