targets = [
    dict(desc = 'dis%s cpu' % i, \
            path = 'servers.dis%s.cpu.total.user' % i, \
            max = '300', min = '0') \
                  for i in range(1, 21)
]
