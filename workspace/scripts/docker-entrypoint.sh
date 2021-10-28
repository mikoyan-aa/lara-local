#!/bin/sh
INITIALIZED_WORKSPACE="/.initialized-workspace"

if [ ! -f ${INITIALIZED_WORKSPACE} ]; then
    echo "==================================================="
    echo ""
    echo " Starting all initialization."
    echo ""
    echo "==================================================="

    ###############################################
    # Install composer packages
    ###############################################

    cd /var/www/aainc-test && composer install


    ###############################################
    # Set database migration and seeds
    ###############################################

    cd /var/www/aainc-test && php artisan migrate
    cd /var/www/aainc-test && php artisan db:seed


    ###############################################
    # Install node modules
    ###############################################

    cd /var/www/aainc-test && npm install


    ###############################################
    # Finalization
    ###############################################

    touch ${INITIALIZED_WORKSPACE}

    echo "==================================================="
    echo ""
    echo " Finished all initialization."
    echo ""
    echo "==================================================="
fi

exec "$@"
