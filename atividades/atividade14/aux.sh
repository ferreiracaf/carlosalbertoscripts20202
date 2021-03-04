#!/bin/bash

apt install -y apache2

echo '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Pagina Web</title>
  </head>
  <body>
          <p>Nome: Carlos Alberto Ferreira Junior</p>
          <p>Matrícula: 385154</p>
  </body>
</html>' > /var/www/html/index.html
