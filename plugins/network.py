targets = [
    {
        'reg' : 'servers.(dis|hador|gardner).*network.*(eth0|lan).*(rx|tx)_byte$',
        'max' : 50 * 1024 * 1024,
        'min' : 0,
    },
    {
        'reg' : 'servers.(dis|hador|gardner).*tcp.CurrEstab',
        'max' : 50 * 1024,
        'min' : 0,
    },
]
