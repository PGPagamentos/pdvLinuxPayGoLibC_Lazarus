# Binario da Aplicação de exemplo de integração em Lazarus Linux com a biblioteca PGWebLib.so da plataforma de transações com cartão PayGo Web

### Funcionalidades implementadas neste exemplo:

- Inicialização
- Instalação
- Venda
- Cancelamento
- Confirmação
- Relatório
- Reimpressão
- Administrativo


### Pré-requisitos
  - Ubuntu 16.4 - 32bits
  - Cadastro no ambiente de testes/sandbox do PayGo Web
    - código do Ponto de Captura (PdC)
    - PIN-Pad

#### Instruções de uso do exemplo Lazarus Linux

-  Entrar no modo terminal.
-  digitar: su  e informar senha do root.
-  PASTA:
-  Criar um pasta dentro de /home = exemplo:  mkdir /home/pastateste
-  criar permissões para a pasta:  chmod 777 /home/pastateste
-  copiar o pacote zipado para esta pasta e descompactar.
-  Ao Descompactar o pacote, será criado uma sub-pasta de nome EXECUTAVEL, contendo o programa testepaygo.so, PGWebLib.so,           certificado.crt e um Readme com algumas instruções.
-  PINPAD:
-  conectar o Pinpad e Pesquisar em qual USB ele esta conectado - comando: dmesg 
será listado muitas informações, procurar por GERTEC, ao encontrar criar permissões totais na pasta /dev
exemplo de um PinPad na USB ttyACM0: 
cd /dev  = pasta com todas as portas
chmod 777 ttyACM0  = permissões totais
ls -l  = lista todas as permissõs da pasta /dev

-  Pode Executar o programa no modo gráfico.

### Link para download do Ubuntu 16.4 32 bits

http://releases.ubuntu.com/16.04/

- Escolher versão 32-bit PC (i386) desktop image

### Link para Download do Lazarus

https://www.lazarus-ide.org/

- Escolher Lazarus 32bits
