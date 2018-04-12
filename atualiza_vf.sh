#!/bin/bash

RELEASE_CLIENT_PATH="/var/varejofacil"

echo -en "baixando versão... "
    VERSION_DATA=$(curl http://versoes.varejofacil.com/builds/head.json)
    VERSION=$(echo $VERSION_DATA | jq '.version'| tr -d '"').$(echo $VERSION_DATA | jq '.number' | tr -d '"')
    RELEASE_DIR=release_v$VERSION
    RELEASE_PATH="$RELEASE_CLIENT_PATH/$RELEASE_DIR"

    rm -rf $RELEASE_PATH 2>> /dev/null 1>&2;

    if ! mkdir $RELEASE_PATH 1> /dev/null 2>&1; then
      echo "ERRO: não foi possível criar o diretório de release"
      exit 1
    fi

    URL_VERSAO=$(echo $VERSION_DATA | jq '.url' | tr -d '"')

    echo ""

    if ! wget -O $RELEASE_PATH/versao.zip $URL_VERSAO 1> /dev/null 2>&1; then
      echo "ERRO: não foi possível baixar a release mais recente"
      exit 1
    fi

echo "OK"

echo -en "descompactando versao... "
    if ! unzip $RELEASE_PATH/versao.zip -d $RELEASE_PATH 1> /dev/null 2>&1; then
      echo "erro"
      echo "ERRO: não foi possível descompactar a release"
      exit 1
    fi
echo "OK"

echo -en "Parando varejofacil... "

    if ! /etc/init.d/varejofacil-tomcat stop 1> /dev/null 2>&1; then
        echo "erro"
        echo "ERRO: não foi possível parar o tomcat"
        exit 1
    fi
echo "OK"

echo -en "preparando ambiente... "

    if ! rm -rf $RELEASE_CLIENT_PATH/components/apache-tomcat/webapps/ROOT* 1> /dev/null 2>&1; then
        echo "erro"
        echo "ERRO: não foi possível limpar a pasta webapps"
        exit 1
    fi

    if ! cp -f $RELEASE_PATH/wars/SysPDVWeb.war $RELEASE_CLIENT_PATH/components/apache-tomcat/webapps/ROOT.war 1> /dev/null 2>&1; then
      echo "erro"
      echo "ERRO: não foi possível copiar o war"
      exit 1
    fi

    if ! rm -rf $RELEASE_CLIENT_PATH/migrations/MigrationsPostgreSQL 1> /dev/null 2>&1; then
        echo "erro"
        echo "ERRO: não foi possível limpar as migrations"
        exit 1
    fi

    if ! cp -f -r $RELEASE_PATH/migrations/MigrationsPostgreSQL/  $RELEASE_CLIENT_PATH/migrations/MigrationsPostgreSQL 1> /dev/null 2>&1; then
        echo "erro"
        echo "ERRO: não foi possível copiar as migrations"
        exit 1
    fi

    if ! mv $RELEASE_CLIENT_PATH/configuracoes.properties $RELEASE_CLIENT_PATH/backup.properties 1> /dev/null 2>&1; then
        echo "erro"
        echo "ERRO: não foi possível renomear o arquivo de configurações"
        exit 1
    fi

    if ! /etc/init.d/varejofacil-tomcat start 1> /dev/null 2>&1; then
        echo "erro"
        echo "ERRO: não foi possível reiniciar o serviço do Tomcat"
        exit 1
    fi

    if ! rm -rf $RELEASE_PATH 1> /dev/null 2>&1; then
        echo "erro"
        echo "ERRO: não foi possível limpar a pasta da nova versão"
        exit 1
    fi

echo "OK"