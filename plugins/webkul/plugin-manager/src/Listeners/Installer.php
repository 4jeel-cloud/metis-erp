<?php

namespace Webkul\PluginManager\Listeners;

class Installer
{
    /**
     * After installation hook — telemetry removed for privacy.
     *
     * @return void
     */
    public function installed(): void
    {
        // Telemetry disabled for privacy.
    }
}
