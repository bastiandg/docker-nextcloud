# docker-nextcloud

**docker-nextcloud** enables you to deploy a fully functional nextcloud server with an automated certificate integration.

# Prerequisites
1. docker daemon
2. `curl`
3. A (sub-)domain which is attached to the docker host
4. The ports 80 and 443 have to be exposed

# Installation

1. `$ git clone https://github.com/bastiandg/docker-nextcloud && cd docker-nextcloud`
2. edit install.sh and set `DOMAIN_NAME`, `EMAIL` and `DATADIR` (`DATADIR` has to be non existent for the first time setup)
3. `bash install.sh`

# Caveats

1. The first user to access the site automatically gets admin access. The developers are aware of this, but say it's the intended behavior. See: https://github.com/nextcloud/server/issues/8653
2. Data base passwords are provided via environment Variables to the containers. So they can be read by all users with access to the docker daemon by doing `docker inspect db`.

# Update

```bash
cd $DATADIR && . config.env && docker-compose down && docker-compose pull && docker-compose up -d
```

# Inspiration

This is heavily inspired by https://github.com/mihaics/docker-nextcloud.git
