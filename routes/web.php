<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Route;

if (! request()->getRequestUri() == '/login') {
    Route::redirect('/login', '/admin/login')
        ->name('login');
}

Route::get('/health', function (Request $request) {
    $checks = [
        'app' => true,
        'database' => false,
        'cache' => false,
    ];

    try {
        DB::connection()->getPdo();
        $checks['database'] = true;
    } catch (\Throwable) {
        $checks['database'] = false;
    }

    try {
        Cache::store('file')->put('health_check', true, 1);
        $checks['cache'] = Cache::store('file')->get('health_check') === true;
    } catch (\Throwable) {
        $checks['cache'] = false;
    }

    $allHealthy = count(array_filter($checks)) === count($checks);

    return response()->json([
        'status' => $allHealthy ? 'healthy' : 'degraded',
        'timestamp' => now()->toIso8601String(),
        'checks' => $checks,
    ], $allHealthy ? 200 : 503);
})->name('health');
