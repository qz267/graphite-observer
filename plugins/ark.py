servers = '(gardner[1-35-8]|hador(18|19|20))'
targets = [
    {
        'reg' : 'servers.%s.*loadavg.01' % servers,
        'max' : 20,
        'min' : 0,
    },
    {
        'reg' : 'servers.%s.luzsla.avg' % servers,
        'max' : 400,
        'min' : 0,
    },
    {
        'reg' : 'servers.%s.network.*lan.*rx_byte' % servers,
        'max' : 30000,
        'min' : 0,
    },
    {
        'reg' : 'servers.thorin.*memcache.shire-mc\d+.*hit_rate',
        'max' : 100,
        'min' : 90,
    },
]

category = 'sysadmin'
