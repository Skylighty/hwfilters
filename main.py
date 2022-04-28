import subprocess as sp
from flask import Flask

app = Flask(__name__)

def hw_filters():
    sp.run(['/bin/bash', '-c', '/opt/mellanox/ethtool/sbin/ethtool', '--show-nfc', 'eth3', '>', '/home/filters.txt'])
    filter_commands = []
    eth_bin_append = '/opt/mellanox/ethtool/sbin/ethtool --config-nfc eth3 '
    with open('/home/filters.txt') as file:
        line = file.readline()
        line.strip()
        line.split()
        if 'Rule' in line and 'Type' in line:
            if 'TCP' or 'UDP' in line: flow_type = line[2].lower() + '4'
            elif 'Raw' in line: flow_type = 'ip4'
            else: pass
        elif 'Src' in line and 'IP' in line:
            src_ip = line[3]
            src_mask = line[5]
        elif 'Dest' in line and 'IP' in line:
            dst_ip = line[3]
            dst_mask = line[5]
        elif 'Src' in line and 'port' in line: src_port = line[2]
        elif 'Dst' in line and 'port' in line: dst_port = line[2]
        elif line=='$': buffer = ''
        filter_commands.append(eth_bin_append + 'flow-type '+flow_type+' src-ip '+src_ip+
                               ' dst-ip '+dst_ip+' src-port '+src_port+' dst-port '+dst_port+' action -1')
            

@app.route('/')
def vommit_filters():
     return "<center>Hello World! Jebać Disa syna orka kurwe zwisa skurwysyna"


if __name__ == "__main__":
    app.run(debug=True,host='0.0.0.0')