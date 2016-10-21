echo 'Start copy nginx conf'

rm -rf /etc/nginx/sites-enabled/*

if ! [ -L /vagrant/conf/nginx/nginx.conf ]; then
  rm -f /etc/nginx/nginx.conf
  cp /vagrant/conf/nginx/nginx.conf /etc/nginx/nginx.conf
fi

rm -rf /etc/nginx/conf.d/*
cp -r /vagrant/conf/nginx/conf.d/* /etc/nginx/conf.d