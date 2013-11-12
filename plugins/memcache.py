targets = [
    {
        'reg' : 'servers.thorin.*memcache.shire-mc.*hit_rate',
        'max' : 100,
        'min' : 90,
    },
    {
        'reg' : 'servers.thorin.*memcache.shire-bak-mc.*bytes_read',
        'max' : 1024 * 1024,
        'min' : 0,
    },
]
