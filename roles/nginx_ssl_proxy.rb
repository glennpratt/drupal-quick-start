name "nginx_ssl_proxy"
description ""
run_list(
  'apci::ssl_only_nginx_proxy'
)
override_attributes(
  :varnish => {
	  :listen_port => "8181"
  }
)
