<?php

$CONFIG = array(

'memcache.local' => '\OC\Memcache\APCu',
'memcache.locking' => '\\OC\\Memcache\\Redis',

'redis' => [
	'host' => 'redis',
	'port' => 6379,
	'timeout' => 0.0,
	'dbindex' => 0,
],
);
