# Postgresql Versions switching
function pg {
  if [ "$#" -eq 0 ]
  then
    echo "PostgreSQL version running : `pgck`"
  elif [ "$1" = "stop" ]
  then
    pg_stop
  elif [ "$1" = "ls" ]
  then
    for i in `pgdirs`
    do
      cat $i/PG_VERSION
    done
  elif [ "$1" = "-h" ]
  then
    echo "Usage: "
    echo "pg                -- Get currently running version"
    echo "pg stop           -- Get installed versions"
    echo "pg ls             -- Get installed versions"
    echo "pg [VERSION]      -- Stops currently running (if any) and starts VERSION"
    echo "                  -- VERSION format : X.Y"
    echo "                  -- EXAMPLES: 8.4"
    echo "                  --           9.2"
    echo "pg -h             -- Display this message"
  else
    dir=`pg_get_dir $1` 
    if [ $dir != "" ]
    then
      curVersion=`pgck`
      if [ $curVersion != "" ]
      then
        echo "Stopping PostreSQL $curVersion"
        pg_stop $curVersion
        brew unlink `pg_get_brew_tap_name $(pg_get_linked)`
      fi
      brew link `pg_get_brew_tap_name $1`
      echo "Launching PostreSQL $1"
      pg_ctl -D `pg_get_dir $1` start
    fi
  fi
}

function pg_get_linked {
  vout=`psql --version`
  vout=${vout/psql (PostgreSQL) /}
  expr "$vout" : '\(...\)'
}

function pg_stop {
  dir=$(pg_get_dir `pgck`)
  if [ "$dir" == "" ]
  then
    echo "No PostgreSQL server running"
  else
    pg_ctl -D $dir stop
  fi
}

function pg_get_brew_tap_name {
  if [[ $1 == 8* ]]
  then
    formulaVersion="8"
  else
    formulaVersion=${1/\./}
  fi
  echo "postgresql$formulaVersion"
}

function pg_get_dir {
  version=$1
  for i in $(pgdirs)
  do
    if [ `cat $i/PG_VERSION` = $version ]
    then
      echo $i
    fi
  done
}

function pgdirs {
  find /usr/local/var -name "postgres*" -maxdepth 1
}

function pgck {
  currentlyRunning=None
  for i in $(pgdirs)
  do
    if [ -e $i/postmaster.pid ]
    then
      currentlyRunning=$(cat $i/PG_VERSION)
    fi
  done
  echo $currentlyRunning
}
