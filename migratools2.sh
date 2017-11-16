#!/bin/bash                                                                                     
#################################################################################################
#                                                                                               #
#      Migratools V-1.0                                                                         #
#      Desenvolvido por Lauro dos Santos                                                        #
#      Data 06 Jan 2017                                                                         #
#                                                                                               #
#################################################################################################

clear

Menu(){

  echo "------------------------------------------------------------------------"
  echo "    Migratools V-1.0         "
  echo "------------------------------------------------------------------------"
  echo
  echo "[ 1 ] Conectar a um servidor"
  echo "[ 2 ] Download de arquivo do stage"
  echo "[ 3 ] Gerar backup"
  echo "[ 4 ] Enviar arquivo para o stage"
  echo "[ 5 ] Permissão em arquivos"
  echo "[ 6 ] Inciar o Pentaho"
  echo "[ 7 ] Operações em banco de dados"
  echo "[ 8 ] Vfcli - Panama" 
  echo "[ 9 ] Alterações varejofacil"
  echo "[ 0 ] Sair"
  echo
  echo -n "Qual a opcao desejada ? "
  read opcao
  case "$opcao" in
    1) Conect_server ;;
    2) Download ;;
    3) Local_backup ;;
    4) Send_file ;;
    5) Mod_arquivo ;;
    6) Start_pentaho ;;
    7) Database_function ;;
    8) Exclude_vendas ;;
    9) Alter_varejofacil ;;
    0) echo "Tenha um otimo dia" && exit;;
    *) echo "Opcao desconhecida." && Menu ;;
  esac
}

#Conexão aos servidores amazon

Conect_server() {

  echo "------------------------------------------------------------------------"
  echo -e "escolha um servidor para conectar \n------------------------------------------------------------------------\n1-bighost\n2-stage"
  echo "------------------------------------------------------------------------"

  read server

  echo "------------------------------------------------------------------------"

  case $server in
    1)
	echo "Escolha um bighost para conectar"
	read big
		if [ "$big" -le 9 ]; then
      		ssh -i ~/cmkey.pem ubuntu@bighost$big.casamagalha.es
		else	
			echo "servidor nao encontrado"
		fi
    ;;
    2)
      ssh -i ~/cmkey.pem ec2-user@stage.casamagalha.es;;
    *)
      echo "servidor nao encontrado tenha um bom dia"
  esac

  Menu
}

#Faz o download do arquivo gerado no STAGE e encaminha para a pasta tarefas-vf no servidor 172.16.50.5
#Caso não tenha o compartilhamento ativado encaminha para uma pasta local chamada tarefas-vf
#Tambem pode se copiar o arquivo para algum diretorio de sua escolha

Download() {

  echo "Digite o nome do arquivo sem a extensão"
  echo "------------------------------------------------------------------------"
  read bkp
  echo "------------------------------------------------------------------------"
  echo "digite o numero da tarefa"
  echo "------------------------------------------------------------------------"
  read task
  
  if [ -z $bkp ]; then
    echo "Acho que voce esqueceu de digitar o nome do arquivo"
    Menu
  fi
  
  echo -e "Deseja enviar o arquivo para \n------------------------------------------------------------------------\n1)-Servidor de Tarefas Desenvolvimento \n2)-Diretorio local de sua escolha"
  echo "------------------------------------------------------------------------"
  read opcao
  
  case "$opcao" in
    1)
      if [ -d ~/tarefas-vf ]; then
        echo "------------------------------------------------------------------------"
        echo "Iniciando download do arquivo $bkp"
        scp -i ~/cmkey.pem ec2-user@stage.casamagalha.es:/home/ec2-user/bkp/"$bkp".backup ~/tarefas-vf/"VF-$task-$bkp".backup
        echo "------------------------------------------------------------------------"
        echo "concluido com sucesso"
      else
        echo "------------------------------------------------------------------------"
        echo "O Diretorio tarefas-vf nao existe ele sera criado localmente no seu Diretorio home"
        mkdir ~/tarefas-vf
        echo "------------------------------------------------------------------------"
        echo "Iniciando download do arquivo $bkp"
        echo "------------------------------------------------------------------------"
        echo "Diretorio foi criado com sucesso, sera iniciado o Download do arquivo $bkp"
        echo "------------------------------------------------------------------------"
        scp -i ~/cmkey.pem ec2-user@stage.casamagalha.es:/home/ec2-user/bkp/"$bkp".backup ~/tarefas-vf/"VF-$task-$bkp".backup
        echo "------------------------------------------------------------------------"
        echo "concluido com sucesso"
      fi
    ;;
    2)
      echo "------------------------------------------------------------------------"
      echo "Digite o caminho onde voce deseja que o arquivo seja gravado"
      read caminho
      
      if [ -d "$caminho" ]; then
        scp -i ~/cmkey.pem ec2-user@stage.casamagalha.es:/home/ec2-user/bkp/"$bkp".backup "$caminho"/"VF-$task-$bkp".backup  
          echo "Processo concluido com sucesso"
          Menu
        else
          echo "Diretorio não localizado"
          Menu
      fi
    ;;
    *)
      Menu
  esac
  
  Menu

}

#realiza backup em nuvem e local

Local_backup() {

  echo "------------------------------------------------------------------------"
  echo -e "Escolha o tipo de backup \n------------------------------------------------------------------------\n1-Nuvem\n2-Local"
  echo "------------------------------------------------------------------------"
  read bkpnl

  case $bkpnl in
    1)
      echo "Digite o nome do cliente"
      read clientenv
      echo "------------------------------------------------------------------------"
      ssh -i ~/cmkey.pem ec2-user@stage.casamagalha.es idump $clientenv
      echo "O arquivo foi gerado em /home/ec2-user/bkp/$clientenv"
    ;;
    2)
      echo "------------------------------------------------------------------------"
      echo "Digite o nome do cliente"
      read cliente
      echo "------------------------------------------------------------------------"
      echo "Digite a data que voce gerou o arquivo"
      read data
      echo "------------------------------------------------------------------------"
      echo -e "Escolha o formato do arquivo \n------------------------------------------------------------------------\n1-.backup\n2-.sql"
      echo "------------------------------------------------------------------------"
      read tipo
      echo "------------------------------------------------------------------------"
        case $tipo in
          1)
            if [ -d ~/bd-clientes/"$cliente"/destino ]; then
              pg_dump -v -h localhost -p 5432 -U postgres -Fc "$cliente" > ~/bd-clientes/"$cliente"/destino/"$cliente"_migrado"$data".backup
            else
              echo "O Diretorio nao existe em seu computador ele sera criado no seu Diretorio home"
              mkdir -p ~/bd-clientes/"$cliente"/destino
              pg_dump -v -h localhost -p 5432 -U postgres -Fc "$cliente" > ~/bd-clientes/"$cliente"/destino/"$cliente"_migrado"$data".backup
            fi
          ;;
          2)
            if [ -d ~/bd-clientes/"$cliente"/destino ]; then
              pg_dump -v -h localhost -p 5432 -U postgres -d "$cliente" -f ~/bd-clientes/"$cliente"/destino/"$cliente"_migrado"$data".sql
            else
              echo "O Diretorio nao existe em seu computador ele sera criado no seu Diretorio home"
              mkdir -p ~/bd-clientes/"$cliente"/destino
              pg_dump -v -h localhost -p 5432 -U postgres -d "$cliente" -f ~/bd-clientes/"$cliente"/destino/"$cliente"_migrado"$data".sql
            fi
          ;;
          *)
            echo "Formato digitado nao e valido"
            Menu
        esac
    ;;
    *)
      echo "Opcao desconhecida"
  esac    
  
  Menu
}

#envia os arquivos para o stage dentro da pasta ~/bkp

Send_file() {

  echo "------------------------------------------------------------------------"
  echo "Digite o nome do cliente"
  read cliente
  echo "------------------------------------------------------------------------"
  echo "Digite a data que voce gerou o arquivo"
  read data
  echo "------------------------------------------------------------------------"

  scp -i ~/cmkey.pem ~/bd-clientes/$cliente/destino/"$cliente"_migrado"$data".backup ec2-user@stage.casamagalha.es:/home/ec2-user/bkp/"$cliente"_migrado"$data".backup

  Menu

}

#lista o conteudo da pasta tarefas-vf

Mod_arquivo() {

  echo "------------------------------------------------------------------------"
  echo "Digite o nome do cliente"
  read  modcli
  #echo "------------------------------------------------------------------------"
  #echo "Permissão concedida ao arquivo"  

  if [ -d ~/bd-clientes/"$modcli"/origem ]; then
     chmod 777 ~/bd-clientes/"$modcli"/origem/syspdv_srv_"$modcli".fdb
     echo "------------------------------------------------------------------------"
     echo "Permissão concedida ao arquivo"  
 else
     echo "------------------------------------------------------------------------"  
     echo "Diretorio nao existe"
     #echo "------------------------------------------------------------------------"
  fi

  Menu

}

#inicia o pentaho e lembra vc de configurar o kettle.properties caso nao tenha feito

Start_pentaho(){

  echo "------------------------------------------------------------------------"
  echo "Você ja fez a configuração do arquivo kettle.properties?"
  echo -e "Deseja configura-lo? \n------------------------------------------------------------------------\n1)-Sim \n2)-Não"
  echo "------------------------------------------------------------------------"
  read opcao

  if [ "$opcao" -eq 2 ]; then
    echo "------------------------------------------------------------------------"
    echo "Iniciando o Pentaho"
    echo "------------------------------------------------------------------------"
    ~/data-integration/spoon.sh
  else
    echo "------------------------------------------------------------------------"
    echo -e "Escolha o editor de texto \n------------------------------------------------------------------------\n1)-vim \n2)-gedit \n3)-nano"
    echo "------------------------------------------------------------------------"
    read ope
    case $ope in 
        1)
          vim ~/.kettle/kettle.properties
          Start_pentaho
        ;;
        2)
          gedit ~/.kettle/kettle.properties
          Start_pentaho
        ;;
        3)
          nano ~/.kettle/kettle.properties
          Start_pentaho
        ;;
        *)
          echo "------------------------------------------------------------------------"
          echo "Editor de texto não encontrado"
          echo "------------------------------------------------------------------------"
          Start_pentaho
      esac
  fi

  Menu

}

#Função para manipulação de arquivos de banco de dados

Database_function(){

  echo "------------------------------------------------------------------------"
  echo -e "Deseja criar um banco de dados ou realizar o restore ?\n------------------------------------------------------------------------\n1)-Criar banco de dados \n2)-Restore de banco de dados \n3)-Gerar senha criptografada"
  echo "------------------------------------------------------------------------"
  read opt

  case $opt in 

    1)
      Create_database;;
    2)
      Restore_database;;
    3)
      Gera_md5;;
    *)
      echo "Opção invalida"
      Menu
  esac

}

#gera o comando para as alterações de licenca do varejofacil

Alter_varejofacil(){  

  echo "------------------------------------------------------------------------"
  echo "digite o nome do cliente"
  echo "------------------------------------------------------------------------"
  read cliente

  if [ -z $cliente ]; then
    echo "nome invalido"
    Menu
  else
      echo "------------------------------------------------------------------------"
      echo -e "O que voce deseja alterar ? \n------------------------------------------------------------------------\n1)-Quantidade de lojas \n2)-Quantidade de usuarios\n3)-Modulos"
      echo "------------------------------------------------------------------------"
      read alteracao
      echo "------------------------------------------------------------------------"

      case "$alteracao" in
        1)
          echo "Digite a quantidade de lojas que o cliente vai ficar"
          read qtdloja
          echo "------------------------------------------------------------------------"
          echo "Alteração realizada no dia $(date +%x) por $(whoami) as $(date +%X)" #>> /home/lauro/solicitacoes_contrato/alteracao_de_licenca/alteracao_licenca_$cliente
          echo "------------------------------------------------------------------------"
          echo "vfcnstop $cliente"
          echo "vfchcnt name=$cliente stores=$qtdloja" #>> /home/lauro/solicitacoes_contrato/alteracao_de_licenca/alteracao_licenca_$cliente
          echo "vfcnstart $cliente"
          #echo "vfupdb name=$cliente stores=$qtdloja"
          echo "------------------------------------------------------------------------"
          echo "sudo -i vfcnstop $cliente && sudo -i vfchcnt name=$cliente stores=$qtdloja && sudo -i vfcnstart $cliente && exit"
          #echo "Alteração realizada com sucesso $cliente com $qtdloja lojas no momento"
          Menu
        ;;
        2)
          echo "Digite a quantidade de usuarios que o cliente vai ficar"
          read qtdusuario
          echo "------------------------------------------------------------------------"
          echo "Alteração realizada no dia $(date +%x) por $(whoami) as $(date +%X)" #>> /home/lauro/solicitacoes_contrato/alteracao_de_licenca/alteracao_licenca_$cliente
          echo "------------------------------------------------------------------------"
          echo "vfcnstop $cliente"
          echo "vfchcnt name=$cliente users=$qtdusuario" #>> /home/lauro/solicitacoes_contrato/alteracao_de_licenca/alteracao_licenca_$cliente
          echo "vfcnstart $cliente"
          #echo "vfupdb name=$cliente users=$qtdusuario"
          echo "------------------------------------------------------------------------"
          echo "sudo -i vfcnstop $cliente && sudo -i vfchcnt name=$cliente users=$qtdusuario && sudo -i vfcnstart $cliente && exit"
          #echo "Alteração realizada com sucesso $cliente com $qtdusuario usuarios no momento"
          Menu
        ;;
        3)
          Modulo
        ;;
        *)
          echo "Opção invalida"
          Menu
      esac
  fi

}

#cria banco de dados local para restore
Create_database(){

  echo "------------------------------------------------------------------------"
  echo "Digite o nome do cliente que voce deseja criar o banco de dados"
  echo "------------------------------------------------------------------------"
  read user
  createdb -U postgres -E UTF8 -T template0 --lc-collate='C' --lc-ctype='pt_BR.UTF-8' $user
  echo "------------------------------------------------------------------------"
  echo "banco $user criado com suceso"
  echo "------------------------------------------------------------------------"
  echo -e "Deseja realizar o restore ? \n------------------------------------------------------------------------\n1)-Sim \n2)-Não"
  echo "------------------------------------------------------------------------"
  read opcao
  case "$opcao" in
    1)
      Restore_database;;
    2) 
      Menu;;
    *)
      Menu
  esac

}

#faz o restore de backup e cria se não existir  
Restore_database(){

  echo "------------------------------------------------------------------------"
  echo -e "O banco de dados ja foi criado ? \n------------------------------------------------------------------------\n1)-Sim \n2)-Não"
  echo "------------------------------------------------------------------------"
  read opcao

  case "$opcao" in
    1) 
      echo "------------------------------------------------------------------------"
      echo "Digite o nome do arquivo"
      echo "------------------------------------------------------------------------"
        read user
      echo "------------------------------------------------------------------------"
      echo "Digite o caminho onde o arquivo esta localizado"
        read caminho
      echo "------------------------------------------------------------------------"
        if [ -d $caminho ]; then
          pg_restore -h localhost -p 5432 -U postgres -d $user -O -v $caminho/$user.backup
        echo "Processo concluido com sucesso"
          Menu
        else
          echo "Diretorio não localizado"
          Menu
        fi
    ;;
    2)
      Create_database;;
    *)
      echo "Opção invalida"
      Restore_database
  esac

}

Gera_md5(){

  echo "Digite a senha que você deseja criptografar: "
  read senha
  psql -h localhost -U postgres -c "select md5('$senha');"
  Menu

}

Modulo(){

  echo -e "Qual modulo voce deseja adcionar? \n------------------------------------------------------------------------\n1)-Gestão(padrão) \n2)-Serviços\n3)-Fidelização \n4)-E-commerce \n5)-Garantia Estendida \n6)-Convenio \n7)-SPED \n8)-Conciliadora"
  echo "------------------------------------------------------------------------"
  read opmod
  echo "------------------------------------------------------------------------"

  case "$opmod" in 
    1)
      modulo=10000000000000000000	
    ;;
    2)   
      modulo=11000000000000000000	
    ;;
    3)
      modulo=10100000000000000000
    ;;
    4)
      modulo=10010000000000000000	
    ;;
	  5)   
      modulo=10001000000000000000
    ;;
	  6)
      modulo=10000100000000000000   
    ;;
	  7)
      modulo=10000010000000000000   
    ;;
	  8)
      modulo=10000001000000000000
    ;;
     *)
    echo "Opção invalida"
    Menu
  esac
    
  echo "Alteração realizada no dia $(date +%x) por $(whoami) as $(date +%X)" #>> /home/lauro/solicitacoes_contrato/alteracao_de_licenca/alteracao_licenca_$cliente
	#echo "sudo -i vfchcnt name=$cliente modules=$modulo" #>> /home/lauro/solicitacoes_contrato/alteracao_de_licenca/alteracao_licenca_$cliente
	echo "sudo -i vfcnstop $cliente && sudo -i vfchcnt name=$cliente modules=$modulo && sudo -i vfcnstart $cliente && exit"
    
  Menu
}

Exclude_vendas() {

  echo "------------------------------------------------------------------------"
  echo -e "O que você deseja fazer\n------------------------------------------------------------------------\n1)-Verificar Tarefa\n2)-Atualizar CNPJ de Loja\n3)-Reprocessar Cadastros no Panama \n4)-Reprocessar Vendas no Panama\n5)-Excluir Unico Cupom \n6)-Excluir Vendas"
  echo "------------------------------------------------------------------------"
  read opc
  case "$opc" in
    1)
        cd ~/workspace/vfcli
        echo "------------------------------------------------------------------------"
        echo "Digite o nome do cliente"
        echo "------------------------------------------------------------------------"
        read vfclient
        echo "------------------------------------------------------------------------"
        echo "Digite o id da tarefa sem aspas"
        echo "------------------------------------------------------------------------"
        read vfid
        echo "------------------------------------------------------------------------"
        ./vfcli verificar-task --container $vfclient --id "$vfid"
        Menu
    ;;
    2)
        cd ~/workspace/vfcli
        echo "------------------------------------------------------------------------"
        echo "Digite o nome do cliente"
        echo "------------------------------------------------------------------------"
        read vfclient
        echo "------------------------------------------------------------------------"
        echo "Digite o numero da loja"
        echo "------------------------------------------------------------------------"
        read vfloja
        echo "------------------------------------------------------------------------"
        echo "Digite o novo cnpj da loja"
        echo "------------------------------------------------------------------------"
        read vfcnpj
        echo "------------------------------------------------------------------------"
        echo "Deseja esperar o procedimento?"
        echo "1)-Sim"
        echo "2)-Não"
        echo "------------------------------------------------------------------------"
        read vfopc
          case "$vfopc" in
            1) 
              ./vfcli atualizar-cnpj-loja --container $vfclient --loja $vfloja --cnpj $vfcnpj
              Menu
            ;;
            2) 
              ./vfcli atualizar-cnpj-loja --espera false --container $vfclient --loja $vfloja --cnpj $vfcnpj
              Menu
            ;;
            *)
          esac
            echo "Opção invalida"
            Menu
    ;;
    3)
      cd ~/workspace/vfcli
      echo "------------------------------------------------------------------------"
      echo "Digite o nome do cliente"
      echo "------------------------------------------------------------------------"
      read vfclient
      echo "------------------------------------------------------------------------"
      echo "Deseja esperar o procedimento?"
      echo "1)-Sim"
      echo "2)-Não"
      echo "------------------------------------------------------------------------"
      read vfopc
        case "$vfopc" in
          1)
            ./vfcli reprocessar-cadastros-panama --container $vfclient
            Menu
          ;;
          2) 
            ./vfcli reprocessar-cadastros-panama --espera false --container $vfclient
            Menu
          ;;
          *)
        esac
        echo "Opção invalida"
        Menu
    ;;
    4)
      cd ~/workspace/vfcli
      echo "------------------------------------------------------------------------"
      echo "Digite o nome do cliente"
      echo "------------------------------------------------------------------------"
      read vfclient
      echo "------------------------------------------------------------------------"
      echo "Digite a data inicial"
      echo "------------------------------------------------------------------------"
      read vfdatini
      echo "------------------------------------------------------------------------"
      echo "Digite a data final"
      echo "------------------------------------------------------------------------"
      read vfdatfin
      echo "------------------------------------------------------------------------"
      echo "Deseja esperar o procedimento?"
      echo "1)-Sim"
      echo "2)-Não"
      echo "------------------------------------------------------------------------"
      read vfopc
        case "$vfopc" in
          1)
            ./vfcli reprocessar-vendas-panama --container $vfclient --inicial $vfdatini --final $vfdatfin
            Menu
          ;;
          2) 
            ./vfcli reprocessar-vendas-panama --espera false --container $vfclient --inicial $vfdatini --final $vfdatfin
            Menu
          ;;
          *)
        esac
        echo "Opção invalida"
        Menu
    ;;
    5)
      cd ~/workspace/vfcli
      echo "------------------------------------------------------------------------"
      echo "Digite o nome do cliente"
      echo "------------------------------------------------------------------------"
      read vfclient
      echo "------------------------------------------------------------------------"
      echo "Digite o numero da loja"
      echo "------------------------------------------------------------------------"
      read vfloja
      echo "------------------------------------------------------------------------"
      echo "Digite a data de emissao do cupom"
      echo "------------------------------------------------------------------------"
      read vfdat
      echo "------------------------------------------------------------------------"
      echo "Digite o numero do sequencial do cupom"
      echo "------------------------------------------------------------------------"
      read vfseq
      echo "------------------------------------------------------------------------"
      echo "Digite o numero do caixa"
      echo "------------------------------------------------------------------------"
      read vfcx
      echo "------------------------------------------------------------------------"
      echo "Deseja esperar o procedimento?"
      echo "1)-Sim"
      echo "2)-Não"
      echo "------------------------------------------------------------------------"
      read vfopc
        case "$vfopc" in
          1)
            ./vfcli excluir-cupom --container $vfclient --loja $vfloja --data $vfdat --sequencial $vfseq --caixa $vfcx
            Menu
          ;;
          2) 
            ./vfcli excluir-cupom --espera false --container $vfclient --loja $vfloja --data $vfdat --sequencial $vfseq --caixa $vfcx
            Menu
          ;;
          *)
        esac
        echo "Opção invalida"
        Menu
    ;;
    6)
      cd ~/workspace/vfcli
      echo "------------------------------------------------------------------------"
      echo "Digite o nome do cliente"
      echo "------------------------------------------------------------------------"
      read vfclient
      echo "------------------------------------------------------------------------"
      echo "Digite a data inicial"
      echo "------------------------------------------------------------------------"
      read vfdatini
      echo "------------------------------------------------------------------------"
      echo "Digite a data final"
      echo "------------------------------------------------------------------------"
      read vfdatfin
      echo "------------------------------------------------------------------------"
      echo "Digite o(s) numero(s) da(s) loja(s) ex: 001,002"
      echo "------------------------------------------------------------------------"
      read vfloja
      echo "------------------------------------------------------------------------"
      echo "Digite o(s) numero(s) do(s) caixa(s) ex: 001,002"
      echo "------------------------------------------------------------------------"
      read vfcx
      echo "------------------------------------------------------------------------"
      echo "Deseja esperar o procedimento?"
      echo "1)-Sim"
      echo "2)-Não"
      echo "------------------------------------------------------------------------"
      read vfopc
        case "$vfopc" in
          1)
            ./vfcli excluir-tudo --container $vfclient --inicial $vfdatini --final $vfdatfin --lojas $vfloja --caixas $vfcx
            Menu
          ;;
          2) 
            ./vfcli excluir-tudo --espera false --container $vfclient --inicial $vfdatini --final $vfdatfin --lojas $vfloja --caixas $vfcx
            Menu
          ;;
          *)
        esac
        echo "Opção invalida"
        Menu
    ;;
    *)
    echo "Opção invalida"
    Menu
  esac

  Menu

}

Menu