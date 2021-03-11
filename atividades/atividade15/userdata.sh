#!/bin/bash

apt install -y apache2

cat << 'EOF' > /usr/local/bin/atividade.sh
#!/bin/bash

while true
do
   DATA=$(date +%D-%H:%M:%S)
   TIME_START=$(uptime | tr ',' ' ' | tr -s [:space:] ' ' | cut -d' ' -f4)
   LOAD_AVERAGE=$(uptime | tr -s [:space:] ' ' | cut -d' ' -f10-)
   MEM_USE=$(free -m | grep  'Mem' | tr -s [:space:] ' ' | cut -d' ' -f3)
   MEM_FREE=$(free -m | grep  'Mem' | tr -s [:space:] ' ' | cut -d' ' -f7)
   RECEIVE=$(cat /proc/net/dev | grep -e "eth0" | tr -s [:space:] ' ' | cut -d' ' -f3)
   TRANSMIT=$(cat /proc/net/dev | grep -e "eth0" | tr -s [:space:] ' ' | cut -d' ' -f11)
   echo "$DATA - $TIME_START - $LOAD_AVERAGE - $MEM_USE - $MEM_FREE - $RECEIVE - $TRANSMIT" >> /var/log/mensagens.log

   cat << EOT > /var/www/html/index.html
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
      <title>Pagina Web</title>
   </head>
   <body>
      <p>Nome: Carlos Alberto Ferreira Junior</p>
      <p>Matrícula: 385154</p>
      <style type="text/css">
         .tg  {border-collapse:collapse;border-spacing:0;}
         .tg td{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
            overflow:hidden;padding:10px 5px;word-break:normal;}
         .tg th{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
            font-weight:normal;overflow:hidden;padding:10px 5px;word-break:normal;}
         .tg .tg-baqh{text-align:center;vertical-align:top}
         .tg .tg-0lax{text-align:left;vertical-align:top}
      </style>
      <table class="tg">
         <thead>
            <tr>
               <th class="tg-baqh" colspan="7">Monitoramento de Instancia do Servidor</th>
            </tr>
         </thead>
         <tbody>
            <tr>
               <td class="tg-0lax">Data e hora</td>
               <td class="tg-0lax">Tempo de atividade</td>
               <td class="tg-0lax">Carga média (1min, 5min, 15min) </td>
               <td class="tg-0lax">Memória livre<br></td>
               <td class="tg-0lax">Memória ocupada</td>
               <td class="tg-0lax">Quantidade de bytes recebidos</td>
               <td class="tg-0lax">Quantidade de bytes enviados</td>
            </tr>
            <tr>
               <td class="tg-0lax">$DATA</td>
               <td class="tg-0lax">$TIME_START</td>
               <td class="tg-0lax">$LOAD_AVERAGE</td>
               <td class="tg-0lax">$MEM_USE</td>
               <td class="tg-0lax">$MEM_FREE</td>
               <td class="tg-0lax">$RECEIVE</td>
               <td class="tg-0lax">$TRANSMIT</td>
            </tr>
         </tbody>
      </table>
   </body>
</html>
EOT

   sleep 5
done
EOF

chmod 744 /usr/local/bin/atividade.sh

cat << 'EOF' > /etc/systemd/system/my-script.service
[Unit]
After=network.target

[Service]
ExecStart=/usr/local/bin/atividade.sh

[Install]
WantedBy=default.target" 
EOF

chmod 664 /etc/systemd/system/my-script.service

systemctl daemon-reload

systemctl enable my-script.service

systemctl start my-script.service
