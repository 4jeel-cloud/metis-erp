<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        DB::statement("
            UPDATE partners_partners
            SET customer_rank = COALESCE((
                SELECT COUNT(*)
                FROM accounts_account_moves
                WHERE partner_id IS NOT NULL
                  AND move_type IN ('out_invoice', 'out_refund')
                  AND accounts_account_moves.partner_id = partners_partners.id
            ), 0)
        ");

        DB::statement("
            UPDATE partners_partners
            SET supplier_rank = COALESCE((
                SELECT COUNT(*)
                FROM accounts_account_moves
                WHERE partner_id IS NOT NULL
                  AND move_type IN ('in_invoice', 'in_refund')
                  AND accounts_account_moves.partner_id = partners_partners.id
            ), 0)
        ");
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        DB::statement('
            UPDATE partners_partners
            SET customer_rank = NULL,
                supplier_rank = NULL
        ');
    }
};
