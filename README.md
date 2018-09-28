# docker-nextcloud

1. `$ git clone https://github.com/bastiandg/docker-nextcloud && cd docker-nextcloud`
2. edit install.sh and set `DOMAIN_NAME`, `EMAIL` and `DATADIR`
3. `bash install.sh`

# Caveats
1. The first user to access the site automatically gets admin access. The developers are aware of this, but say it's the intended behavior. See: https://github.com/nextcloud/server/issues/8653
2. Data base passwords are provided via environment Variables to the containers. So they can be read by all users with access to the docker daemon by doing `docker inspect db`.

# Inspiration
This is heavily inspired by https://github.com/mihaics/docker-nextcloud.git
