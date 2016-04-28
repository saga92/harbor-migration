# harbor-migration
harbor-migration is a project for migrating database schema between different version of project [harbor](https://github.com/vmware/harbor)
###installation
- step 1: clone repo

    ```git clone https://github.com/saga92/harbor-migration```
- step 2: modify migration.cfg
- step 3: build image from dockerfile
    ```
    cd harbor-migration
    
    docker build -t your-image-name .
    ```

###migration
- show instruction of harbor-migration

    ```docker run your-image-name help```

- create backup file in /path/to/backup

    ```
    docker run -v /data/database:/var/lib/mysql -v /path/to/backup:/harbor-migration/backup your-image-name backup
    ```

- restore from backup file in /path/to/backup

    ```
    docker run -v /data/database:/var/lib/mysql -v /path/to/backup:/harbor-migration/backup your-image-name restore
    ```

- perform database schema upgrade

    ```docker run -v /data/database:/var/lib/mysql your-image-name up head```

- perform database schema downgrade

    ```docker run -v /data/database:/var/lib/mysql your-image-name down base```
