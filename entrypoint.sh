#!/usr/bin/sh

start() {
  
  if ! [ -d $PGDATA ]; then
    pg-setup initdb --tune=1c -D $PGDATA
    sed -i 's/peer/trust/g' $PGDATA/pg_hba.conf
    su -l postgres -c "touch $PGDATA/log/postgrespro-$VERSION.log"
  fi

  su -l postgres -c "${BINDIR}/check-db-dir $PGDATA"
  su -l postgres -c "${BINDIR}/pg_ctl -D $PGDATA -l $PGDATA/log/postgrespro-$VERSION.log start"

  tail -F $PGDATA/log/postgrespro-$VERSION.log

}

export BINDIR=/opt/pgpro/$VERSION/bin
export PGDATA=/var/lib/pgpro/$VERSION/data
export PATH=${BINDIR}:$PATH
export LANG=ru_RU.UTF-8

usermod --non-unique --uid "$UID" postgres && groupmod --non-unique --gid "$GID" postgres
chmod -R 0777 /tmp

case "$@" in

  start)
    start
    ;;
  *)
    "$@"

esac
