//************************************************************************************************
//
//  unit: PGWLib
//  Classe: TPGWLib
//
//  Data da Crição: 26/08/2019
//  Autor:
//  Descrição: Classe Contendo Todos os Metodos de Interoper da DLL de Integração Paygo
//             Versão Linux/Lazarus
//
//
//************************************************************************************************
unit upgwlib;

{$mode objfpc}{$H+}


interface

uses
LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,FileUtil,strutils,
ExtCtrls,LCLType, LCLProc, LCLIntf, dynlibs, uEnums, sysutils, uLib;


{
// Metodos da Unit= dynlibs
// ========================
   Function SafeLoadLibrary(Name : AnsiString) : TLibHandle;
   Function LoadLibrary(Name : AnsiString) : TLibHandle;
   Function GetProcedureAddress(Lib : TlibHandle; ProcName : AnsiString) : Pointer;
   Function UnloadLibrary(Lib : TLibHandle) : Boolean;
}

Type


  //========================================================
  // Record que descreve cada membro da estrutura PW_GetData:
  //========================================================
  TPW_GetData = record
       wIdentificador : Word;
       bTipoDeDado : Byte;
       szPrompt: Array[0..83] of  AnsiChar;
       bNumOpcoesMenu: Byte;
       vszTextoMenu: Array[0..39] of Array[0..40] of AnsiChar;
       vszValorMenu: Array[0..39] of Array[0..255] of  AnsiChar;
       szMascaraDeCaptura: Array[0..40] of AnsiChar;
       bTiposEntradaPermitidos: Byte;
       bTamanhoMinimo: Byte;
       bTamanhoMaximo: Byte;
       ulValorMinimo : UInt32;
       ulValorMaximo : UInt32;
       bOcultarDadosDigitados: Byte;
       bValidacaoDado: Byte;
       bAceitaNulo: Byte;
       szValorInicial: Array[0..40] of AnsiChar;
       bTeclasDeAtalho: Byte;
       szMsgValidacao: Array[0..83] of AnsiChar;
       szMsgConfirmacao: Array[0..83] of AnsiChar;
       szMsgDadoMaior: Array[0..83] of AnsiChar;
       szMsgDadoMenor: Array[0..83] of AnsiChar;
       bCapturarDataVencCartao: Byte;
       ulTipoEntradaCartao: UInt32;
       bItemInicial: Byte;
       bNumeroCapturas: Byte;
       szMsgPrevia: Array[0..83] of AnsiChar;
       bTipoEntradaCodigoBarras: Byte;
       bOmiteMsgAlerta: Byte;
       bIniciaPelaEsquerda: Byte;
       bNotificarCancelamento: Byte;
       bAlinhaPelaDireita: Byte;
    end;

    PW_GetData = Array[0..10] of TPW_GetData;


       // Retorno de GetResult
       TPZ_GetData = record
            pszDataxx: Array[0..10000] of AnsiChar;
       end;
       PSZ_GetData = Array[0..0] of TPZ_GetData;

       //
       CPT_GetDado = record
            pszData: Array[0..32] of AnsiChar;
       end;
       PSZ_GetDado = Array[0..0] of CPT_GetDado;


       // Temporário
       TPZ_GetDisplay = record
            szDspMsg: Array[0..127] of AnsiChar;
            szAux:    Array[0..1023] of AnsiChar;
            szMsgPinPad: Array[0..33] of AnsiChar;
       end;

       PSZ_GetDisplay = Array[0..10] of TPZ_GetDisplay;


  //====================================================================
  // Estrutura para armazenamento de dados para Tipos de Operação
  //====================================================================
     TPW_Operations = record
         bOperType: Byte;
         szText: Array[0..21] of char;
         szValue: Array[0..21] of char;
     end;

     PW_Operations = Array[0..9] of TPW_Operations;


 //====================================================================
 // Estrutura para armazenamento de dados para confirmação de transação
 //====================================================================
    TConfirmaData = record
        szReqNum: Array[0..10] of AnsiChar;
        szExtRef: Array[0..50] of AnsiChar;
        szLocRef: Array[0..50] of AnsiChar;
        szVirtMerch: Array[0..18] of AnsiChar;
        szAuthSyst: Array[0..20] of AnsiChar;
    end;

   ConfirmaData = Array[0..0] of TConfirmaData;




 //========================================================================================================================================
   { Esta função é utilizada para inicializar a biblioteca, e retorna imediatamente.
    Deve ser garantido que uma chamada dela retorne PWRET_OK antes de chamar qualquer outra função.

        Entradas:
        pszWorkingDir Diretório de trabalho (caminho completo, com final nulo) para uso exclusivo do Pay&Go Web

        Saídas: Nenhuma.

       Retorno: PWRET_OK .................................. Operação bem sucedida.
                PWRET_WRITERR ....................... Falha de gravação no diretório informado.
                PWRET_INVCALL ......................... Já foi efetuada uma chamada à função PW_iInit após o carregamento da biblioteca.
                Outro ..................................Outro erro de execução (ver "10. Códigos de retorno", página 78 do Manual).
                                                      Uma mensagem de erro pode ser obtida através da função PW_iGetResult (PWINFO_RESULTMSG).
   }
 //============================================================================================================================================
   TPW_iInit = function (pszWorkingDir:AnsiString):SmallInt; cdecl;


 //=============================================================================================================================================
   { Esta função deve ser chamada para iniciar uma nova transação através do Pay&Go Web, e retorna imediatamente.

    Entradas:
    iOper Tipo de transação a ser realizada (PWOPER_xxx, conforme tabela).

    Saídas: Nenhuma

    Retorno:
              PWRET_OK .................................. Transação inicializada.
              PWRET_DLLNOTINIT ................... Não foi executado PW_iInit.
              PWRET_NOTINST ........................ É necessário efetuar uma transação de Instalação.
              Outro ................................ Outro erro de execução (ver "10. Códigos de retorno", página 78 Manual).
                                                     Uma mensagem de erro pode ser obtida através da função PW_iGetResult (PWINFO_RESULTMSG).
   }
 //==============================================================================================================================================
   TPW_iNewTransac = function (iOper:Byte):SmallInt;  cdecl;



 //=============================================================================================================================================
   {  Esta função é utilizada para alimentar a biblioteca com as informações da transação a ser realizada,
     e retorna imediatamente. Estas informações podem ser:
       - Pré-fixadas na Automação;
       - Capturadas do operador pela Automação antes do acionamento do Pay&Go Web;
       - Capturadas do operador após solicitação pelo Pay&Go Web (retorno PW_MOREDATA por PW_iExecTransac).


      Entradas:
      wParam Identificador do parâmetro (PWINFO_xxx, ver lista completa em ". Dicionário de dados", página 72).
      pszValue Valor do parâmetro (string ASCII com final nulo).

    Saídas: Nenhuma

    Retorno:
              PWRET_OK .................................. Parametro Acrescentado com sucesso.
              PWRET_INVPARAM .................... O valor do parâmetro é inválido
              PWRET_DLLNOTINIT ................... Não foi executado PW_iInit
              PWRET_TRNNOTINIT .................. Não foi executado PW_iNewTransac (ver página 14).
              PWRET_NOTINST ........................ É necessário efetuar uma transação de Instalação
              Outro ........................................... Outro erro de execução (ver "10. Códigos de retorno", página 78). Uma
                                                                mensagem de erro pode ser obtida através da função PW_iGetResult
                                                                (PWINFO_RESULTMSG).
    }
 //==============================================================================================================================================
   TPW_iAddParam = function (wParam:SmallInt; szValue:AnsiString):Int16; cdecl;


 //=============================================================================================================================================
   {  Esta função tenta realizar uma transação através do Pay&Go Web, utilizando os parâmetros
     previamente definidos através de PW_iAddParam. Caso algum dado adicional precise ser informado,
     o retorno será PWRET_MOREDATA e o parâmetro pvstParam retornará informações dos dados que
     ainda devem ser capturados.

     Esta função, por se comunicar com a infraestrutura Pay&Go Web, pode demorar alguns segundos
     para retornar.


     Entradas:
       piNumParam Quantidade máxima de dados que podem ser capturados de uma vez, caso o retorno
       seja PW_MOREDATA. (Deve refletir o tamanho da área de memória apontada por
       pvstParam.) Valor sugerido: 9.

     Saídas:
       pvstParam  Lista e características dos dados que precisam ser informados para executar a transação.
       Consultar "8.Captura de dados" (página 65) para a descrição da estrutura
       e instruções para a captura de dados adicionais. piNumParam Quantidade de dados adicionais que precisam ser capturados
       (quantidade de ocorrências preenchidas em pvstParam

       Retorno:
           PWRET_OK .................................. Transação realizada com sucesso. Os resultados da transação devem ser obtidos através da função PW_iGetResult.
           PWRET_NOTHING ....................... Nada a fazer, fazer as validações locais necessárias e chamar a função PW_iExecTransac novamente.
           PWRET_MOREDATA ................... Mais dados são requeridos para executar a transação.
           PWRET_DLLNOTINIT ................... Não foi executado PW_iInit.
           PWRET_TRNNOTINIT .................. Não foi executado PW_iNewTransac (ver página 14).
           PWRET_NOTINST ........................ É necessário efetuar uma transação de Instalação.
           PWRET_NOMANDATORY ........... Algum dos parâmetros obrigatórios não foi adicionado (ver página 17).
           Outro ........................................... Outro erro de execução (ver "10. Códigos de retorno", página 78 Manual).
                                                             Uma mensagem de erro pode ser obtida através da função PW_iGetResult (PWINFO_RESULTMSG).
    }
 //=============================================================================================================================================
   TPW_iExecTransac = function (var pvstParam: PW_GetData; piNumParam : pointer) : Int16;  cdecl;


 //=========================================================================================================*\
   {  Funcao     :  PW_iGetResult

      Descricao  :  Esta função pode ser chamada para obter informações que resultaram da transação efetuada,
                    independentemente de ter sido bem ou mal sucedida, e retorna imediatamente.

      Entradas   :  iInfo:	   Código da informação solicitada sendo requisitada (PWINFO_xxx, ver lista completa
                                em "9. Dicionário de dados", página 36).
                    ulDataSize:	Tamanho (em bytes) da área de memória apontada por pszData. Prever um tamanho maior
                                que o máximo previsto para o dado solicitado.


      Saidas     :  pszData:	   Valor da informação solicitada (string ASCII com terminador nulo).

      Retorno    :  PWRET_OK	         Sucesso. pszData contém o valor solicitado.
                    PWRET_NODATA	   A informação solicitada não está disponível.
                    PWRET_BUFOVFLW 	O valor da informação solicitada não cabe em pszData.
                    PWRET_DLLNOTINIT	Não foi executado PW_iInit.
                    PWRET_TRNNOTINIT	Não foi executado PW_iNewTransac (ver página 10).
                    PWRET_NOTINST	   É necessário efetuar uma transação de Instalação.
                    Outro	            Outro erro de execução (ver "10. Códigos de retorno", página 40). Uma mensagem
                                      de erro pode ser obtida através da função PW_iGetResult (PWINFO_RESULTMSG).
   }
 //=========================================================================================================*/
   TPW_iGetResult = function(iInfo:Int16; var pszData: PSZ_GetData;   ulDataSize: UInt32):Int16; cdecl;



   //=========================================================================================================
   {
    Funcao     :  PW_iConfirmation

    Descricao  :  Esta função informa ao Pay&Go Web o status final da transação em curso (confirmada ou desfeita).
                  Consultar "7. Confirmação de transação" (página 28) para informações adicionais.

    Entradas   :  ulStatus:   	Resultado da transação (PWCNF_xxx, ver lista abaixo).
                  pszReqNum:  	Referência local da transação, obtida através de PW_iGetResult (PWINFO_REQNUM).
                  pszLocRef:  	Referência da transação para a infraestrutura Pay&Go Web, obtida através de PW_iGetResult (PWINFO_AUTLOCREF).
                  pszExtRef:  	Referência da transação para o Provedor, obtida através de PW_iGetResult (PWINFO_AUTEXTREF).
                  pszVirtMerch:	Identificador do Estabelecimento, obtido através de PW_iGetResult (PWINFO_VIRTMERCH).
                  pszAuthSyst:   Nome do Provedor, obtido através de PW_iGetResult (PWINFO_AUTHSYST).

    Saidas     :  não há.

    Retorno    :  PWRET_OK	         O status da transação foi atualizado com sucesso.
                  PWRET_DLLNOTINIT	Não foi executado PW_iInit.
                  PWRET_NOTINST	   É necessário efetuar uma transação de Instalação.
                  Outro	            Outro erro de execução (ver "10. Códigos de retorno", página 40). Uma mensagem
                                    de erro pode ser obtida através da função PW_iGetResult (PWINFO_RESULTMSG).
   }
   //=========================================================================================================
     TPW_iConfirmation = function(ulResult:Uint32; pszReqNum: AnsiString; pszLocRef:AnsiString ; pszExtRef:AnsiString;
                                                pszVirtMerch:AnsiString; pszAuthSyst:AnsiString):Int16; cdecl;


   //=========================================================================================================*\
   {   Funcao     :  PW_iIdleProc

       Descricao  :  Para o correto funcionamento do sistema, a biblioteca do Pay&Go Web precisa de tempos em tempos
                     executar tarefas automáticas enquanto não está realizando nenhuma transação a pedido da Automação.

       Entradas   :  não há.

       Saidas     :  não há.

       Retorno    :  PWRET_OK	         Operação realizada com êxito.
                     PWRET_DLLNOTINIT	Não foi executado PW_iInit.
                     PWRET_NOTINST	   É necessário efetuar uma transação de Instalação.
                     Outro	            Outro erro de execução (ver "10. Códigos de retorno", página 40). Uma mensagem
                                       de erro pode ser obtida através da função PW_iGetResult (PWINFO_RESULTMSG).
   }
   //=========================================================================================================*/
     TPW_iIdleProc = function():Int16; cdecl;



   //=========================================================================================================
   {
    Funcao     :  PW_iGetOperations

    Descricao  :  Esta função pode ser chamada para obter quais operações o Pay&Go WEB disponibiliza no momento,
                  sejam elas administrativas, de venda ou ambas.

    Entradas   :              bOperType	      Soma dos tipos de operação a serem incluídos na estrutura de
                                                retorno (PWOPTYPE_xxx).
                              piNumOperations	Número máximo de operações que pode ser retornado. (Deve refletir
                                                o tamanho da área de memória apontada por pvstOperations).

    Saídas     :              piNumOperations	Número de operações disponíveis no Pay&Go WEB.
                              vstOperations	   Lista das operações disponíveis e suas características.


    Retorno    :  PWRET_OK	         Operação realizada com êxito.
                  PWRET_DLLNOTINIT	Não foi executado PW_iInit.
                  PWRET_NOTINST	   É necessário efetuar uma transação de Instalação.
                  Outro	            Outro erro de execução (ver "10. Códigos de retorno", página 40). Uma mensagem
                                    de erro pode ser obtida através da função PW_iGetResult (PWINFO_RESULTMSG).
   }
   //======================================================================================================================
     TPW_iGetOperations = function(bOperType:Byte; var vstOperatios: PW_Operations; piNumOperations:Int16):Int16;  cdecl;


   //======================================================================================================================
     { Funcao     :  PW_iPPAbort

      Descricao  :  Esta função pode ser utilizada pela Automação para interromper uma captura de dados no PIN-pad
                    em curso, e retorna imediatamente.

      Entradas   :  não há.

      Saidas     :  não há.

      Retorno    :  PWRET_OK	         Operação interrompida com sucesso.
                    PWRET_PPCOMERR	   Falha na comunicação com o PIN-pad.
                    PWRET_DLLNOTINIT	Não foi executado PW_iInit.
                    Outro	            Outro erro de execução (ver "10. Códigos de retorno", página 40). Uma mensagem
                                      de erro pode ser obtida através da função PW_iGetResult (PWINFO_RESULTMSG).
      }
   //=========================================================================================================*/
     TPW_iPPAbort = function():Int16;  cdecl;



   //=========================================================================================================*\
     { Funcao     :  PW_iPPEventLoop

      Descricao  :  Esta função deverá ser chamada em "loop" até que seja retornado PWRET_OK (ou um erro fatal). Nesse
                    "loop", caso o retorno seja PWRET_DISPLAY o ponto de captura deverá atualizar o "display" com as
                    mensagens recebidas da biblioteca.

      Entradas   :  ulDisplaySize	Tamanho (em bytes) da área de memória apontada por pszDisplay.
                                   Tamanho mínimo recomendado: 100 bytes.

      Saidas     :  pszDisplay	   Caso o retorno da função seja PWRET_DISPLAY, contém uma mensagem de texto
                                   (string ASCII com terminal nulo) a ser apresentada pela Automação na interface com
                                   o usuário principal. Para o formato desta mensagem, consultar "4.3.Interface com o
                                   usuário", página 8.

      Retorno    :  PWRET_NOTHING	   Nada a fazer, continuar aguardando o processamento do PIN-pad.
                    PWRET_DISPLAY	   Apresentar a mensagem recebida em pszDisplay e continuar aguardando o processamento do PIN-pad.
                    PWRET_OK	         Captura de dados realizada com êxito, prosseguir com a transação.
                    PWRET_CANCEL	   A operação foi cancelada pelo Cliente no PIN-pad (tecla [CANCEL]).
                    PWRET_TIMEOUT	   O Cliente não realizou a captura no tempo limite.
                    PWRET_FALLBACK	   Ocorreu um erro na leitura do cartão, passar a aceitar a digitação do número do cartão, caso já não esteja aceitando.
                    PWRET_PPCOMERR	   Falha na comunicação com o PIN-pad.
                    PWRET_DLLNOTINIT	Não foi executado PW_iInit.
                    PWRET_INVCALL	   Não há captura de dados no PIN-pad em curso.
                    Outro	            Outro erro de execução (ver "10. Códigos de retorno", página 40). Uma mensagem
                                      de erro pode ser obtida através da função PW_iGetResult (PWINFO_RESULTMSG).
      }
   //=========================================================================================================
     TPW_iPPEventLoop = function(var pszDisplay; ulDisplaySize:UInt32):Int16;  cdecl;



   //=========================================================================================================
     { Funcao     :  PW_iPPGetCard

      Descricao  :  Esta função é utilizada para realizar a leitura de um cartão (magnético, com chip com contato,
                    ou sem contato) no PIN-pad.

      Entradas   :  uiIndex	Índice (iniciado em 0) do dado solicitado na última execução de PW_iExecTransac
                             (índice do dado no vetor pvstParam).

      Saidas     :  não há.

      Retorno    :  PWRET_OK	         Captura iniciada com sucesso, chamar PW_iPPEventLoop para obter o resultado.
                    PWRET_INVPARAM	   O valor de uiIndex informado não corresponde a uma captura de dados deste tipo.
                    PWRET_DLLNOTINIT	Não foi executado PW_iInit.
                    Outro	            Outro erro de execução (ver "10. Códigos de retorno", página 40). Uma mensagem
                                      de erro pode ser obtida através da função PW_iGetResult (PWINFO_RESULTMSG).
      }
   //=========================================================================================================*/
     TPW_iPPGetCard = function(uiIndex:UInt16):Int16; cdecl;



   //=========================================================================================================*\
     { Funcao     :  PW_iPPGetPIN

      Descricao  :  Esta função é utilizada para realizar a captura no PIN-pad da senha (ou outro dado criptografado)
                    do Cliente.

      Entradas   :  uiIndex	Índice (iniciado em 0) do dado solicitado na última execução de PW_iExecTransac
                             (índice do dado no vetor pvstParam).

      Saidas     :  não há.

      Retorno    :  PWRET_OK	         Captura iniciada com sucesso, chamar PW_iPPEventLoop para obter o resultado.
                    PWRET_INVPARAM	   O valor de uiIndex informado não corresponde a uma captura de dados deste tipo.
                    PWRET_DLLNOTINIT	Não foi executado PW_iInit.
                    Outro	            Outro erro de execução (ver "10. Códigos de retorno", página 40). Uma mensagem
                                      de erro pode ser obtida através da função PW_iGetResult (PWINFO_RESULTMSG).
      }
   //=========================================================================================================*/
     TPW_iPPGetPIN = function(uiIndex:UInt16):Int16;   cdecl;



   //=========================================================================================================*\
     { Funcao     :  PW_iPPGetData

      Descricao  :  Esta função é utilizada para fazer a captura no PIN-pad de um dado não sensível do Cliente..

      Entradas   :  uiIndex	Índice (iniciado em 0) do dado solicitado na última execução de PW_iExecTransac
                             (índice do dado no vetor pvstParam).

      Saidas     :  nao ha.

      Retorno    :  PWRET_OK	         Captura iniciada com sucesso, chamar PW_iPPEventLoop para obter o resultado.
                    PWRET_INVPARAM	   O valor de uiIndex informado não corresponde a uma captura de dados deste tipo.
                    PWRET_DLLNOTINIT	Não foi executado PW_iInit.
                    Outro	            Outro erro de execução (ver "10. Códigos de retorno", página 40). Uma mensagem
                                      de erro pode ser obtida através da função PW_iGetResult (PWINFO_RESULTMSG).
      }
   //=========================================================================================================*/
     TPW_iPPGetData = function(uiIndex:UInt16):Int16;  StdCall;




   //=========================================================================================================*\
     { Funcao     :  PW_iPPGoOnChip

      Descricao  :  Esta função é utilizada para realizar o processamento off-line (antes da comunicação com o Provedor)
                    de um cartão com chip no PIN-pad.

      Entradas   :  uiIndex	Índice (iniciado em 0) do dado solicitado na última execução de PW_iExecTransac
                             (índice do dado no vetor pvstParam).

      Saidas     :  não há.

      Retorno    :  PWRET_OK	         Captura iniciada com sucesso, chamar PW_iPPEventLoop para obter o resultado.
                    PWRET_INVPARAM	   O valor de uiIndex informado não corresponde a uma captura de dados deste tipo.
                    PWRET_DLLNOTINIT	Não foi executado PW_iInit.
                    Outro	            Outro erro de execução (ver "10. Códigos de retorno", página 40). Uma mensagem
                                      de erro pode ser obtida através da função PW_iGetResult (PWINFO_RESULTMSG).
      }
   //=========================================================================================================*/
     TPW_iPPGoOnChip = function(uiIndex:UInt16):Int16;  cdecl;



   //=========================================================================================================*\
     { Funcao     :  PW_iPPFinishChip

      Descricao  :  Esta função é utilizada para finalizar o processamento on-line (após comunicação com o Provedor)
                    de um cartão com chip no PIN-pad.

      Entradas   :  uiIndex	Índice (iniciado em 0) do dado solicitado na última execução de PW_iExecTransac
                             (índice do dado no vetor pvstParam).

      Saidas     :  não há.

      Retorno    :  PWRET_OK	         Captura iniciada com sucesso, chamar PW_iPPEventLoop para obter o resultado.
                    PWRET_INVPARAM	   O valor de uiIndex informado não corresponde a uma captura de dados deste tipo.
                    PWRET_DLLNOTINIT	Não foi executado PW_iInit.
                    Outro	            Outro erro de execução (ver "10. Códigos de retorno pagina 40). Uma mensagem
                                      de erro pode ser obtida através da função PW_iGetResult (PWINFO_RESULTMSG).
      }
   //=========================================================================================================*/
     TPW_iPPFinishChip = function(uiIndex:UInt16):Int16;  cdecl;


   //=========================================================================================================*\
     { Funcao     :  PW_iPPConfirmData

      Descricao  :  Esta função é utilizada para obter do Cliente a confirmação de uma informação no PIN-pad.

      Entradas   :  uiIndex	Índice (iniciado em 0) do dado solicitado na última execução de PW_iExecTransac
                             (índice do dado no vetor pvstParam).

      Saidas     :  não há.

      Retorno    :  PWRET_OK	         Captura iniciada com sucesso, chamar PW_iPPEventLoop para obter o resultado.
                    PWRET_INVPARAM	   O valor de uiIndex informado não corresponde a uma captura de dados deste tipo.
                    PWRET_DLLNOTINIT	Não foi executado PW_iInit.
                    Outro	            Outro erro de execução (ver "10. Códigos de retorno", página 40). Uma mensagem
                                      de erro pode ser obtida através da função PW_iGetResult (PWINFO_RESULTMSG).
      }
   //=========================================================================================================*/
     TPW_iPPConfirmData = function(uiIndex:UInt16):Int16;   cdecl;



   //=========================================================================================================*\
     { Funcao     :  PW_iPPRemoveCard

      Descricao  :  Esta função é utilizada para fazer uma remoção de cartão do PIN-pad.

      Entradas   :  não há.

      Saidas     :  não há.

      Retorno    :  PWRET_OK	         Captura iniciada com sucesso, chamar PW_iPPEventLoop para obter o resultado.
                    PWRET_INVPARAM	   O valor de uiIndex informado não corresponde a uma captura de dados deste tipo.
                    PWRET_DLLNOTINIT	Não foi executado PW_iInit.
                    Outro	            Outro erro de execução (ver "10. Códigos de retorno", página 40). Uma mensagem
                                      de erro pode ser obtida através da função PW_iGetResult (PWINFO_RESULTMSG).
      }
   //=========================================================================================================*/
     TPW_iPPRemoveCard = function():Int16;  cdecl;



   //=========================================================================================================*\
     { Funcao     :  PW_iPPDisplay

      Descricao  :  Esta função é utilizada para apresentar uma mensagem no PIN-pad

      Entradas   :  pszMsg   Mensagem a ser apresentada no PIN-pad. O caractere "\r" (0Dh) indica uma quebra de linha.

      Saidas     :  não há.

      Retorno    :  PWRET_OK	         Captura iniciada com sucesso, chamar PW_iPPEventLoop para obter o resultado.
                    PWRET_DLLNOTINIT	Não foi executado PW_iInit.
                    Outro	            Outro erro de execução (ver "10. Códigos de retorno", página 40). Uma mensagem
                                      de erro pode ser obtida através da função PW_iGetResult (PWINFO_RESULTMSG).
      }
   //=========================================================================================================*/
     TPW_iPPDisplay = function(pszMsg:AnsiString):Int16; cdecl;



   //=========================================================================================================*\
     { Funcao     :  PW_iPPWaitEvent

      Descricao  :  Esta função é utilizada para aguardar a ocorrência de um evento no PIN-pad.

      Entradas   :  não há.

      Saidas     :  pulEvent	         Evento ocorrido.

      Retorno    :  PWRET_OK	         Captura iniciada com sucesso, chamar PW_iPPEventLoop para obter o resultado.
                    PWRET_DLLNOTINIT	Não foi executado PW_iInit.
                    Outro	            Outro erro de execução (ver "10. Códigos de retorno", página 40). Uma mensagem
                                      de erro pode ser obtida através da função PW_iGetResult (PWINFO_RESULTMSG).
      }
   //=========================================================================================================*/
     TPW_iPPWaitEvent = function(var pulEvent:UInt32):Int16;  cdecl;



   //===========================================================================*\
     { Funcao   : PW_iPPGenericCMD

      Descricao  :  Realiza comando genérico de PIN-pad.

      Entradas   :  uiIndex	Índice (iniciado em 0) do dado solicitado na última execução de PW_iExecTransac
                             (índice do dado no vetor pvstParam).

      Saidas     :  Não há.

      Retorno    :  PWRET_xxx.
      }
   //===========================================================================
     TPW_iPPGenericCMD = function(uiIndex:UInt16):Int16;  cdecl;



   //===========================================================================
     { Funcao     : PW_iTransactionInquiry

      Descricao  :  Esta função é utilizada para realizar uma consulta de transações
                    efetuadas por um ponto de captura junto ao Pay&Go WEB.

      Entradas   :  pszXmlRequest	Arquivo de entrada no formato XML, contendo as informações
                                   necessárias para fazer a consulta pretendida.
                    ulXmlResponseLen Tamanho da string pszXmlResponse.

      Saidas     :  pszXmlResponse	Arquivo de saída no formato XML, contendo o resultado da consulta
                                   efetuada, o arquivo de saída tem todos os elementos do arquivo de entrada.

      Retorno    :  PWRET_xxx.
      }
   //==========================================================================================================================
     TPW_iTransactionInquiry = function(const pszXmlRequest:Char; pszXmlResponse:Char; ulXmlResponseLen:UInt32):Int16;  cdecl;



   //=========================================================================================================*\
     { Funcao     :  PW_iGetUserData

      Descricao  :  Esta função é utilizada para obter um dado digitado pelo portador do cartão no PIN-pad.

      Entradas   :  uiMessageId : Identificador da mensagem a ser exibida como prompt para a captura.
                    bMinLen     : Tamanho mínimo do dado a ser digitado.
                    bMaxLen     : Tamanho máximo do dado a ser digitado.
                    iToutSec    : Tempo limite para a digitação do dado em segundos.

      Saídas     :  pszData     : Dado digitado pelo portador do cartão no PIN-pad.

      Retorno    :  PWRET_OK	         Operação realizada com êxito.
                    PWRET_DLLNOTINIT	Não foi executado PW_iInit.
                    PWRET_NOTINST	   É necessário efetuar uma transação de Instalação.
                    PWRET_CANCEL	   A operação foi cancelada pelo Cliente no PIN-pad (tecla [CANCEL]).
                    PWRET_TIMEOUT	   O Cliente não realizou a captura no tempo limite.
                    PWRET_PPCOMERR	   Falha na comunicação com o PIN-pad.
                    PWRET_INVCALL	   Não é possível capturar dados em um PIN-pad não ABECS.
                    Outro	            Outro erro de execução (ver "10. Códigos de retorno", página 40). Uma mensagem
                                      de erro pode ser obtida através da função PW_iGetResult (PWINFO_RESULTMSG).
      }
   //=======================================================================================================================================
     TPW_iPPGetUserData = function(uiMessageId:UInt16; bMinLen:Byte; bMaxLen:Byte; iToutSec:Int16; var pszData: PSZ_GetDado):Int16;  cdecl;






  { TPGWLib }

  TPGWLib = class
  private
  //private
    { private declarations }
  protected
    { protected declarations }
  public

    constructor Create;
    Destructor  Destroy; Override; // declaração do metodo destrutor

    procedure AddMandatoryParams;

    procedure GetVersao;

    procedure Init;

    function Instalacao:Integer;

    function venda:Integer;

    function ConfirmaTrasacao:integer;

    function Reimpressao:Integer;

    function Relatorios:Integer;

    function Cancelamento:Integer;

    function GetParamConfirma:Integer;

    function GetParamPendenteConfirma:Integer;

    function iExecGetData(vstGetData:PW_GetData; iNumParam:Integer):Integer;

    function pszGetInfoDescription(wIdentificador:Integer):string;

    function PrintReturnDescription(iReturnCode:Integer; pszDspMsg:string):Integer;

    function MandaMemo(Descr:string):integer;

    function Carrega_Lib:integer;

    function Libera_Lib:integer;

    function PrintResultParams:Integer;

    function Aguardando:string;


  end;


Const


  // Informações Auxiliares para testes
  PWINFO_AUTHMNGTUSER = '314159';
  PWINFO_POSID  = '60376';
  PWINFO_MERCHCNPJCPF = '20726059000179';
  PWINFO_DESTTCPIP = 'app.tpgw.ntk.com.br:17502';
  PWINFO_USINGPINPAD = '1';
  PWINFO_PPCOMMPORT = '0';




implementation



uses Principal, uLib02;


  var

    MyLibC: TLibHandle = dynlibs.NilHandle;

    MyFunc_iInit: TPW_iInit;

    MyFunc_iNewTransac : TPW_iNewTransac;

    MyFunc_iExecTransac:TPW_iExecTransac;

    MyFunc_iGetResult:TPW_iGetResult;

    MyFunc_iAddParam:TPW_iAddParam;

    MyFunc_iPPRemoveCard:TPW_iPPRemoveCard;

    MyFunc_iPPEventLoop:TPW_iPPEventLoop;

    MyFunc_iConfirmation:TPW_iConfirmation;

    MyFunc_iPPGetCard:TPW_iPPGetCard;

    MyFunc_iPPGetPIN:TPW_iPPGetPIN;

    MyFunc_iPPAbort:TPW_iPPAbort;

    MyFunc_iPPGoOnChip:TPW_iPPGoOnChip;

    MyFunc_iPPGetData:TPW_iPPGetData;

    MyFunc_iPPFinishChip:TPW_iPPFinishChip;

    MyFunc_iPPConfirmData:TPW_iPPConfirmData;

    MyFunc_iPPGetUserData:TPW_iPPGetUserData;

    MyFunc_iPPDisplay:TPW_iPPDisplay;

    MyFunc_iPPWaitEvent:TPW_iPPWaitEvent;



    //***********

    mRCancelado:Integer;

    gfAutoAtendimento: Boolean;

    xpszData: Array[0..20] of char;

    iRetorno: SmallInt;

    vGetdataArray : PW_GetData;

    vstGetData : PW_GetData;

    vGetpszData : PSZ_GetData;

    vGetpszErro : PSZ_GetData;

    vGetpszDado : PSZ_GetDado;

    vGetMsg : PSZ_GetDisplay;

    vGetpszDisplay : PSZ_GetDisplay;
   	xNumParam : int16;

    xSzValue: AnsiString;

    pvstParam:PW_GetData;


    gstConfirmData: ConfirmaData;


    iNumParam: Int16;

    iRet: Int16;

    iRetErro:Integer;

    Volta : String;


    PWEnums : TCEnums;

    txt:string;

    Y:Integer;

  { TPGWLib }

  constructor TPGWLib.Create;
  begin

    inherited Create;
    PWEnums := TCEnums.Create;

  end;

  destructor TPGWLib.Destroy;
  begin
       inherited Destroy;
  end;


  //==================================================================
  //  Retorna a Versão da  Lib
  //==================================================================
  procedure TPGWLib.GetVersao;
  var
    FuncResult: Integer;
    nome:String;
    StrTagNFCe: String;
    iretornar:Integer;
  begin

     xNumParam := 10;

     AddMandatoryParams();

     iretornar := Carrega_Lib();
     if (iretornar <> 0) then
        Exit;


     // Nova Transação para PWOPER_VERSION
     MyFunc_iNewTransac := TPW_iNewTransac(GetProcedureAddress(MyLibC, 'PW_iNewTransac'));
     iRet := MyFunc_iNewTransac (PWEnums.PWOPER_VERSION);



     if (iRet <> PWEnums.PWRET_OK) then
        begin
           // Verifica se Foi inicializada a biblioteca
           if (iRet = PWEnums.PWRET_DLLNOTINIT)  then
               begin
                 MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
                 iRetErro := MyFunc_iGetResult (PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                 Volta := vGetpszData[0].pszDataxx;
                 MandaMemo(Volta);
               end
           // verifica se foi feito instalação
           else if (iRet = PWEnums.PWRET_NOTINST)  then
               begin
                 MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
                 iRetErro := MyFunc_iGetResult (PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                 Volta := vGetpszData[0].pszDataxx;
                 MandaMemo(Volta);
               end
           // Outro Erro
           else
               begin
                 MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
                 iRetErro := MyFunc_iGetResult (PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                 Volta := vGetpszData[0].pszDataxx;
                 MandaMemo(Volta);
               end;


           Exit;

        end;



     // Executa Transação
     MyFunc_iExecTransac := TPW_iExecTransac(GetProcedureAddress(MyLibC, 'PW_iExecTransac'));
     iRet := MyFunc_iExecTransac (vGetdataArray, @xNumParam);


     // Captura Informação
     MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
     iRet := MyFunc_iGetResult (PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));

     MandaMemo(' ');
     MandaMemo('Versão da LIB : ' + vGetpszData[0].pszDataxx);





  end;


//=================================================================================
//  Metodo para inicializar Lib
//=================================================================================

  procedure TPGWLib.Init;
  var
    FuncResult: Integer;
    nome:String;
    StrTagNFCe: String;
    iretornar:Integer;
  begin

     iretornar := Carrega_Lib();
     if (iretornar <> 0) then
        Exit;

     StrTagNFCe:= InputBox('Pasta', 'Informe Diretorio:', '.');

     MyFunc_iInit := TPW_iInit(GetProcedureAddress(MyLibC, 'PW_iInit'));
     FuncResult := MyFunc_iInit (StrTagNFCe);


     MandaMemo(' ');
     PrintReturnDescription(FuncResult,'');


     if (FuncResult = PWEnums.PWRET_WRITERR)  then
         begin

           MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
           iRetErro := MyFunc_iGetResult (PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
           Volta := vGetpszData[0].pszDataxx;
           MandaMemo(Volta);

         end;

         PrintResultParams();



     Exit;

  end;

  //=====================================================================================*\
    {
       function  :  Instalacao

       Descricao  :  Instalação de um Ponto de Captura.

    }
  //=====================================================================================*/
  function TPGWLib.Instalacao: Integer;
  var
      szAux: Char;
      StrTagNFCe: string;
      StrValorTagNFCe: AnsiString;
      msg: AnsiString;
      pszData:Char;
      iParam : Int16;
      xxxparam: SmallInt;
      I:integer;
      comando: array[0..39] of Char;
      winfo:Integer;
      falta:string;
      iRet:Integer;
      iretornar:Integer;
  begin

     I := 0;

     iretornar := Carrega_Lib();
     if (iretornar <> 0) then
        Exit;



          // Nova Transação Instalação PWOPER_INSTALL
          MyFunc_iNewTransac := TPW_iNewTransac(GetProcedureAddress(MyLibC, 'PW_iNewTransac'));
          iRet := MyFunc_iNewTransac (PWEnums.PWOPER_INSTALL);


           if (iRet <> PWEnums.PWRET_OK) then
              begin
                 // Verifica se Foi inicializada a biblioteca
                 if (iRet = PWEnums.PWRET_DLLNOTINIT)  then
                     begin
                       MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
                       iRetErro := MyFunc_iGetResult (PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                       Volta := vGetpszData[0].pszDataxx;
                       MandaMemo(Volta);
                     end
                 // Outro Erro

                 else
                     begin
                       MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
                       iRetErro := MyFunc_iGetResult (PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                       Volta := vGetpszData[0].pszDataxx;
                       MandaMemo(Volta);
                     end;


                 Exit;


              end;



            AddMandatoryParams;  // Parametros obrigatórios


          //=====================================================
          //  Loop Para Capturar Dados e executar Transação
          //=====================================================
          while I < 100 do
          begin

              // Coloca o valor 10 (tamanho da estrutura de entrada) no parâmetro iNumParam
              xNumParam := 10;



              // Tenta executar a transação
              if(iRet <> PWEnums.PWRET_NOTHING) then
                begin
                  //ShowMessage('Processando...');
                end;

              // Executa Transação
              MyFunc_iExecTransac := TPW_iExecTransac(GetProcedureAddress(MyLibC, 'PW_iExecTransac'));
              iRet := MyFunc_iExecTransac (vGetdataArray, @xNumParam);


              MandaMemo(' ');
              PrintReturnDescription(iRet,'');


              if (iRet = PWEnums.PWRET_MOREDATA) then
                begin

                   MandaMemo('Numero de Parametros Ausentes: ' + IntToStr(xNumParam));


                   // Tenta capturar os dados faltantes, caso ocorra algum erro retorna
                   iRetErro := iExecGetData(vGetdataArray,xNumParam);
                   if (iRetErro <> 0) then
                      begin
                        Exit;
                      end
                   else
                      begin
                        I := I+1;
                        Continue;
                      end;

                end
              else
                begin

                    if(iRet = PWEnums.PWRET_NOTHING) then
                      begin
                        I := I+1;
                        Continue;
                      end;


                    if (iRet = PWEnums.PWRET_FROMHOSTPENDTRN) then
                        begin
                            // Busca Parametros da Transação Pendente
                            //GetParamPendenteConfirma();
                        end
                    else
                        begin
                            // Busca Parametros da Transação Atual
                            //GetParamConfirma();
                        end;

                    MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
                    iRet := MyFunc_iGetResult (PWEnums.PWINFO_CNFREQ, vGetpszData, SizeOf(vGetpszData));

                    //iRet := PW_iGetResult(PWEnums.PWINFO_CNFREQ, vGetpszData, SizeOf(vGetpszData));
                    Volta := vGetpszData[0].pszDataxx;
                    if (Volta = '1') then
                       begin
                          MandaMemo(' PWINFO_CNFREQ = 1');
                          MandaMemo(' ');
                          MandaMemo('É Necessário Confirmar esta Transação !');
                          MandaMemo(' ');
                       end;


                    Break;

                end;


          end;


          PrintResultParams();


  end;


  //========================================================
    {

      Executa Nova Transaçao de Venda  PWEnums.PWOPER_SALE

    }
  //========================================================
  function TPGWLib.venda: Integer;
  var
      iParam : Integer;
      Volta : String;
      iRet:Integer;
      iRetI: Integer;
      iRetErro : integer;
      strNome : String;
      I:Integer;
      xloop:integer;
      voltaA:AnsiChar;
      iretornar:Integer;
  begin



      iretornar := Carrega_Lib();
      if (iretornar <> 0) then
         Exit;



          // Verifica se não esta Marcado para Auto Atendimento
          if  (gfAutoAtendimento = True) then
              begin
                gfAutoAtendimento := False;
              end;


          I := 0;






          // Nova Transação Instalação PWOPER_INSTALL
          MyFunc_iNewTransac := TPW_iNewTransac(GetProcedureAddress(MyLibC, 'PW_iNewTransac'));
          iRet := MyFunc_iNewTransac (PWEnums.PWOPER_SALE);  //Executa a função


          if (iRet <> PWEnums.PWRET_OK) then
             begin
                // Verifica se Foi inicializada a biblioteca
                if (iRet = PWEnums.PWRET_DLLNOTINIT)  then
                    begin
                        MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
                        iRetErro := MyFunc_iGetResult (PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                        Volta := vGetpszData[0].pszDataxx;
                        MandaMemo(Volta);
                    end
                // verifica se foi feito instalação
                else if (iRet = PWEnums.PWRET_NOTINST)  then
                    begin
                        MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
                        iRetErro := MyFunc_iGetResult (PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));

                        Volta := vGetpszData[0].pszDataxx;
                        MandaMemo(Volta);
                    end
                // Outro Erro
                else
                    begin
                        MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
                        iRetErro := MyFunc_iGetResult (PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                        Volta := vGetpszData[0].pszDataxx;
                        MandaMemo(Volta);
                    end;


                    Exit;

             end;



          AddMandatoryParams;  // Parametros obrigatórios


          //=====================================================
          //  Loop Para Capturar Dados e executar Transação
          //=====================================================
          while I < 100 do
          begin

              // Coloca o valor 10 (tamanho da estrutura de entrada) no parâmetro iNumParam
              xNumParam := 10;



              // Tenta executar a transação
              if(iRet <> PWEnums.PWRET_NOTHING) then
                begin
                  //ShowMessage('Processando...');
                end;

              MyFunc_iExecTransac := TPW_iExecTransac(GetProcedureAddress(MyLibC, 'PW_iExecTransac'));
              iRet := MyFunc_iExecTransac (vGetdataArray, @xNumParam);

              MandaMemo(' ');
              PrintReturnDescription(iRet,'');


              if (iRet = PWEnums.PWRET_MOREDATA) then
                begin

                   MandaMemo('Numero de Parametros Ausentes: ' + IntToStr(xNumParam));


                   // Tenta capturar os dados faltantes, caso ocorra algum erro retorna
                   iRetErro := iExecGetData(vGetdataArray,xNumParam);
                   if (iRetErro <> PWEnums.PWRET_OK) then
                      begin
                        if (mRCancelado = 1) then
                            begin
                              MandaMemo(' ');
                              MandaMemo('CANCELADO PELA APLICAÇÃO !!');
                            end;

                            MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
                            iRetErro := MyFunc_iGetResult (PWEnums.PWINFO_CNFREQ, vGetpszData, SizeOf(vGetpszData));
                            Volta := vGetpszData[0].pszDataxx;
                            if (Volta = '1') then
                               begin
                                  MandaMemo(' PWINFO_CNFREQ = 1');
                                  MandaMemo(' ');
                                  MandaMemo('É Necessário Confirmar esta Transação !');
                                  MandaMemo(' ');

                                  // Metodo confirma a transação
                                  ConfirmaTrasacao();

                               end;


                        // Busca Todos os codigos e seus conteudos
                           PrintResultParams();

                        Exit;
                      end
                   else
                      begin
                        I := I+1;
                        Continue;
                      end;

                end
              else
                begin


                    if(iRet = PWEnums.PWRET_NOTHING) then
                      begin
                        I := I+1;
                        Continue;
                      end;


                    if (iRet = PWEnums.PWRET_FROMHOSTPENDTRN) then
                        begin
                            // Busca Parametros da Transação Pendente
                            GetParamPendenteConfirma();
                        end
                    else
                        begin
                            // Busca Parametros da Transação Atual
                            GetParamConfirma();
                        end;

                    MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
                    iRet := MyFunc_iGetResult (PWEnums.PWINFO_CNFREQ, vGetpszData, SizeOf(vGetpszData));
                    Volta := vGetpszData[0].pszDataxx;
                    if (Volta = '1') then
                       begin
                          MandaMemo(' PWINFO_CNFREQ = 1');
                          MandaMemo(' ');
                          MandaMemo('É Necessário Confirmar esta Transação !');
                          MandaMemo(' ');

                          // Metodo confirma a transação
                          ConfirmaTrasacao();

                       end;


                    // Busca Todos os codigos e seus conteudos
                       PrintResultParams();


                    Break;


                end;



          end;







  end;


  //=====================================================================================
    {
     Funcao     :  ConfirmaTransacao

     Descricao  : Esta função informa ao Pay&Go Web o status final da transação
                  em curso (confirmada ou desfeita).Confirmação de transação
   }
  //=====================================================================================*/
  function TPGWLib.ConfirmaTrasacao: integer;
  var
    strTagNFCe : String;
    strTagOP   : AnsiString;
    falta : string;
    iRet : Integer;
    iRetorno : Integer;
    iRetErro: Integer;
    ulStatus:Integer;
    Menu:Byte;
    Volta : String;
    winfo:Integer;
    I:Integer;
    iRetI:Integer;
    Cont:string;
    tamanho:Integer;
    passou:Integer;
    testeNum: Array[0..10] of Char;
    WretornaConf: PSZ_GetData;
    iretornar:Integer;
  begin


          iretornar := Carrega_Lib();
          if (iretornar <> 0) then
             Exit;


          {

              Descrição das Confirmações:

           ' 1 - PWCNF_CNF_AUT         A transação foi confirmada pelo Ponto de Captura, sem intervenção do usuário '
           ' 2 - PWCNF_CNF_MANU_AUT    A transação foi confirmada manualmente na Automação
           ' 3 - PWCNF_REV_MANU_AUT    A transação foi desfeita manualmente na Automação
           ' 4 - PWCNF_REV_PRN_AU      A transação foi desfeita pela Automação, devido a uma falha na impressão
                                         do comprovante (não fiscal). A priori, não usar.
                                         Falhas na impressão não devem gerar desfazimento,
                                         deve ser solicitada a reimpressão da transaçã '
           ' 5 - PWCNF_REV_DISP_AUT    A transação foi desfeita pela Automação, devido a uma falha no
                                         mecanismo de liberação da mercadoria
           ' 6 - PWCNF_REV_COMM_AUT    A transação foi desfeita pela Automação, devido a uma falha de
                                         comunicação/integração com o ponto de captura (Cliente Pay&Go Web'
           ' 7 - PWCNF_REV_ABORT       A transação não foi finalizada, foi interrompida durante a captura de dados'
           ' 8 - PWCNF_REV_OTHER_AUT   A transação foi desfeita a pedido da Automação, por um outro motivo não previsto.
           ' 9 - PWCNF_REV_PWR_AUT     A transação foi desfeita automaticamente pela Automação,
                                         devido a uma queda de energia (reinício abrupto do sistema).
           '10 - PWCNF_REV_FISC_AUT    A transação foi desfeita automaticamente pela Automação,
                                         devido a uma falha de registro no sistema fiscal (impressora S@T, on-line, etc.).
        }



           falta :=
           ' 1 - PWCNF_CNF_AUT       '  + chr(13) +
           ' 2 - PWCNF_CNF_MANU_AUT  '  + chr(13) +
           ' 3 - PWCNF_REV_MANU_AUT  '  + chr(13) +
           ' 4 - PWCNF_REV_PRN_AU    '  + chr(13) +
           ' 5 - PWCNF_REV_DISP_AUT  '  + chr(13) +
           ' 6 - PWCNF_REV_COMM_AUT  '  + chr(13) +
           ' 7 - PWCNF_REV_ABORT     '  + chr(13) +
           ' 8 - PWCNF_REV_OTHER_AUT '  + chr(13) +
           ' 9 - PWCNF_REV_PWR_AUT   '  + chr(13) +
           '10 - PWCNF_REV_FISC_AUT  '  + chr(13);


            strTagNFCe := '';

            while (X < 5) do
            begin


                StrTagNFCe:= vInputBox('Escolha Confirmação: ',falta,'',12);


                if (StrTagNFCe = 'CANCELA') then
                    begin
                      mRCancelado := 1;
                      Result := 1;
                      Exit;
                    end
                else
                    begin
                      mRCancelado := 0;
                    end;


                try
                   Menu := StrToInt(strTagNFCe);
                Except
                   ShowMessage('Escolha uma opção Válida');
                   Continue;
                end;


                case Menu of

                     1:
                       begin
                         ulStatus := PWEnums.PWCNF_CNF_AUTO;
                         Break;
                       end;

                     2:
                       begin
                        ulStatus  := PWEnums.PWCNF_CNF_MANU_AUT;
                         Break;
                       end;
                     3:
                       begin
                        ulStatus := PWEnums.PWCNF_REV_MANU_AUT;
                        Break;
                       end;
                     4:
                       begin
                        ulStatus := PWEnums.PWCNF_REV_DISP_AUT;
                         Break;
                       end;

                     5:
                       begin
                        ulStatus := PWEnums.PWCNF_REV_DISP_AUT;
                        Break;
                       end;

                     6:
                       begin
                        ulStatus := PWEnums.PWCNF_REV_COMM_AUT;
                        Break;
                       end;

                     7:
                       begin
                        ulStatus := PWEnums.PWCNF_REV_ABORT;
                        Break;
                       end;

                     8:
                       begin
                        ulStatus := PWEnums.PWCNF_REV_OTHER_AUT;
                        Break;
                       end;

                     9:
                       begin
                        ulStatus := PWEnums.PWCNF_REV_PWR_AUT;
                        Break;
                       end;

                     10:
                       begin
                        ulStatus := PWEnums.PWCNF_REV_FISC_AUT;
                        Break;
                       end;
                     else
                       begin
                         ShowMessage('Opção Inválida');
                         Continue;
                       end;


                end;


            end;


             falta := '0 - Confirmar Ultima Transação ' + chr(13) +
                      '1 - Informar Dados Manualmente ';

             while (X < 5) do
             begin

                  strTagNFCe:= vInputBox('Escolha Opção: ',falta,'',1);


                  if (StrTagNFCe = 'CANCELA') then
                      begin
                        mRCancelado := 1;
                        Result := 1;
                        Exit;
                      end
                  else
                      begin
                        mRCancelado := 0;
                      end;


                  try
                     iRetErro := StrToInt(strTagNFCe);
                  Except
                     ShowMessage('Escolha uma opção Válida');
                     Continue;
                  end;


                  if  (StrToInt(strTagNFCe) = 0) or (StrToInt(strTagNFCe) = 1)  then
                       begin
                         Break;
                       end
                  else
                       begin
                         ShowMessage('Opção Invalida');
                         Continue
                       end;


             end;




            if (strTagNFCe = '1') then
               begin

                  falta := '';

                  strTagOP:= vInputBox('Digite valor de PWINFO_REQNUM: ',falta,'',1);
                  StrLCopy(@gstConfirmData[0].szReqNum, PChar(strTagOP), SizeOf(gstConfirmData[0].szReqNum));        // 11

                  strTagOP:= vInputBox('Digite valor de PWINFO_AUTLOCREF: ',falta,'',1);
                  StrLCopy(@gstConfirmData[0].szLocRef, PChar(strTagOP), SizeOf(gstConfirmData[0].szLocRef));      //11

                  strTagOP:= vInputBox('Digite valor de PWINFO_AUTEXTREF: ',falta,'',1);
                  StrLCopy(@gstConfirmData[0].szExtRef, PChar(strTagOP), SizeOf(gstConfirmData[0].szExtRef));   // 50

                  strTagOP:= vInputBox('Digite valor de PWINFO_VIRTMERCH: ',falta,'',1);
                  StrLCopy(@gstConfirmData[0].szVirtMerch, PChar(strTagOP), SizeOf(gstConfirmData[0].szVirtMerch));  // 18

                  strTagOP:= vInputBox('Digite valor de PWINFO_AUTHSYST: ',falta,'',1);
                  StrLCopy(@gstConfirmData[0].szAuthSyst, PChar(strTagOP), SizeOf(gstConfirmData[0].szAuthSyst));  // 20

               end
            else
               begin
                 // Busca Parametros para Confirmação da Transação
                 // GetParamConfirma();
               end;


            // Executa Confirmação

            MyFunc_iConfirmation := TPW_iConfirmation(GetProcedureAddress(MyLibC, 'PW_iConfirmation'));
            iRet := MyFunc_iConfirmation (ulStatus, gstConfirmData[0].szReqNum,gstConfirmData[0].szLocRef,gstConfirmData[0].szExtRef,gstConfirmData[0].szVirtMerch,gstConfirmData[0].szAuthSyst);

            if (iRet <> PWEnums.PWRET_OK) then
               begin


                  // Verifica se Foi inicializada a biblioteca
                  if (iRet = PWEnums.PWRET_DLLNOTINIT)  then
                      begin
                          MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
                          iRetorno := MyFunc_iGetResult (PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                          Volta := vGetpszData[0].pszDataxx;

                          MandaMemo(Volta);
                          MandaMemo(' ');
                      end;

                  // verifica se foi feito instalação
                  if (iRet = PWEnums.PWRET_NOTINST)  then
                      begin
                          MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
                          iRetorno := MyFunc_iGetResult (PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                          Volta := vGetpszData[0].pszDataxx;

                          MandaMemo(Volta);
                          MandaMemo(' ');
                      end;



                      ShowMessage('Outros Erros: ' + IntToStr(iRet));

                      // Verificar Outros erros

                      Exit;

               end;


              if (StrTagNFCe = 'CANCELA') then
                  begin
                    mRCancelado := 1;
                    Result := 1;
                    Exit;
                  end
              else
                  begin
                    mRCancelado := 0;
                  end;





            //PrintResultParams();


            MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
            iRetorno := MyFunc_iGetResult (PWEnums.PWINFO_RESULTMSG, WretornaConf, SizeOf(WretornaConf));

            volta    := WretornaConf[0].pszDataxx;


            MandaMemo(Volta);
            MandaMemo(' ');

            if (iRet = PWEnums.PWRET_OK) then
               begin
                  MandaMemo('CONFIRMAÇÃO OK');
                  MandaMemo(' ');
               end;



  end;






  //=====================================================================================
    {
       Reimpressão de Recibo da ultima Venda
    }
  //======================================================================================
  function TPGWLib.Reimpressao: Integer;
  var
      iParam : Integer;
      Volta : String;
      iRet:Integer;
      iRetI: Integer;
      iRetErro : integer;
      strNome : String;
      I:Integer;
      xloop:integer;
      voltaA:AnsiChar;
      iretornar:Integer;
  begin

      I := 0;


      iretornar := Carrega_Lib();
      if (iretornar <> 0) then
         Exit;


      // Nova Transação Reimpressão PWOPER_REPRINT
      MyFunc_iNewTransac := TPW_iNewTransac(GetProcedureAddress(MyLibC, 'PW_iNewTransac'));
      iRet := MyFunc_iNewTransac (PWEnums.PWOPER_REPRINT);


      if (iRet <> PWEnums.PWRET_OK) then
         begin
            // Verifica se Foi inicializada a biblioteca
            if (iRet = PWEnums.PWRET_DLLNOTINIT)  then
                begin
                    MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
                    iRetErro := MyFunc_iGetResult (PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                    Volta := vGetpszData[0].pszDataxx;
                    MandaMemo(Volta);
                end
            // verifica se foi feito instalação
            else if (iRet = PWEnums.PWRET_NOTINST)  then
                begin
                    MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
                    iRetErro := MyFunc_iGetResult (PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));

                    Volta := vGetpszData[0].pszDataxx;
                    MandaMemo(Volta);
                end
            // Outro Erro
            else
                begin
                    MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
                    iRetErro := MyFunc_iGetResult (PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                    Volta := vGetpszData[0].pszDataxx;
                    MandaMemo(Volta);
                end;


                Exit;

         end;




      AddMandatoryParams;  // Parametros obrigatórios


      //=====================================================
      //  Loop Para Capturar Dados e executar Transação
      //=====================================================
      while I < 100 do
      begin

          // Coloca o valor 10 (tamanho da estrutura de entrada) no parâmetro iNumParam
          xNumParam := 10;



          // Tenta executar a transação
          if(iRet <> PWEnums.PWRET_NOTHING) then
            begin
              //ShowMessage('Processando...');
            end;


          MyFunc_iExecTransac := TPW_iExecTransac(GetProcedureAddress(MyLibC, 'PW_iExecTransac'));
          iRet := MyFunc_iExecTransac (vGetdataArray, @xNumParam);

          MandaMemo(' ');
          PrintReturnDescription(iRet,'');


          if (iRet = PWEnums.PWRET_MOREDATA) then
            begin

               MandaMemo('Numero de Parametros Ausentes: ' + IntToStr(xNumParam));


               // Tenta capturar os dados faltantes, caso ocorra algum erro retorna
               iRetErro := iExecGetData(vGetdataArray,xNumParam);
               if (iRetErro <> 0) then
                  begin
                    Exit;
                  end
               else
                  begin
                    I := I+1;
                    Continue;
                  end;

            end
          else
            begin


                if(iRet = PWEnums.PWRET_NOTHING) then
                  begin
                    I := I+1;
                    Continue;
                  end;


                if (iRet = PWEnums.PWRET_FROMHOSTPENDTRN) then
                    begin
                        // Busca Parametros da Transação Pendente
                        GetParamPendenteConfirma();
                    end
                else
                    begin
                        // Busca Parametros da Transação Atual
                        GetParamConfirma();
                    end;


                  // Busca Todos os codigos e seus conteudos
                   PrintResultParams();


                Break;


            end;


      end;







  end;



  //=====================================================================================
    {
       Relatórios das vendas e cancelamentos por Data informada
    }
  //======================================================================================
  function TPGWLib.Relatorios: Integer;
  var
    iParam : Integer;
    Volta : String;
    iRet:Integer;
    iRetI: Integer;
    iRetErro : integer;
    strNome : String;
    I:Integer;
    xloop:integer;
    voltaA:AnsiChar;
    iretornar:Integer;
  begin

      I := 0;


      iretornar := Carrega_Lib();
      if (iretornar <> 0) then
         Exit;


      // Nova Transação Relatórios PWOPER_RPTDETAIL
      MyFunc_iNewTransac := TPW_iNewTransac(GetProcedureAddress(MyLibC, 'PW_iNewTransac'));
      iRet := MyFunc_iNewTransac (PWEnums.PWOPER_RPTDETAIL);


      if (iRet <> PWEnums.PWRET_OK) then
         begin
            // Verifica se Foi inicializada a biblioteca
            if (iRet = PWEnums.PWRET_DLLNOTINIT)  then
                begin
                    MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
                    iRetErro := MyFunc_iGetResult (PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                    Volta := vGetpszData[0].pszDataxx;
                    MandaMemo(Volta);
                end
            // verifica se foi feito instalação
            else if (iRet = PWEnums.PWRET_NOTINST)  then
                begin
                    MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
                    iRetErro := MyFunc_iGetResult (PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));

                    Volta := vGetpszData[0].pszDataxx;
                    MandaMemo(Volta);
                end
            // Outro Erro
            else
                begin
                    MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
                    iRetErro := MyFunc_iGetResult (PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                    Volta := vGetpszData[0].pszDataxx;
                    MandaMemo(Volta);
                end;


                Exit;

         end;




      AddMandatoryParams;  // Parametros obrigatórios




      //=====================================================
      //  Loop Para Capturar Dados e executar Transação
      //=====================================================
      while I < 100 do
      begin

          // Coloca o valor 10 (tamanho da estrutura de entrada) no parâmetro iNumParam
          xNumParam := 10;



          // Tenta executar a transação
          if(iRet <> PWEnums.PWRET_NOTHING) then
            begin
              //ShowMessage('Processando...');
            end;

          MyFunc_iExecTransac := TPW_iExecTransac(GetProcedureAddress(MyLibC, 'PW_iExecTransac'));
          iRet := MyFunc_iExecTransac (vGetdataArray, @xNumParam);
          if (iRet = PWEnums.PWRET_MOREDATA) then
            begin

               // Tenta capturar os dados faltantes, caso ocorra algum erro retorna
               iRetErro := iExecGetData(vGetdataArray,xNumParam);
               if (iRetErro <> PWEnums.PWRET_OK) then
                  begin
                    Exit;
                  end
               else
                  begin
                    I := I+1;
                    Continue;
                  end;

            end
          else
            begin


                if(iRet = PWEnums.PWRET_NOTHING) then
                  begin
                    I := I+1;
                    Continue;
                  end;


                // Esta Opção Não precisa de Confirmação, mas caso exista uma transação pendente
                // vai armazenar informações para executar uma confirmação no Menu.
                if (iRet = PWEnums.PWRET_FROMHOSTPENDTRN) then
                    begin
                        // Busca Parametros da Transação Pendente
                        GetParamPendenteConfirma();
                    end;


                    Break;

            end;



      end;


      // Busca Todos Parametros e seus conteudos
       PrintResultParams();



  end;


  //=====================================================================================
    {
        Cancela uma Transação de Venda
    }
  //=====================================================================================
  function TPGWLib.Cancelamento: Integer;
    var
      iParam : Integer;
      Volta : String;
      iRet:Integer;
      iRetI: Integer;
      iRetErro : integer;
      strNome : String;
      I:Integer;
      xloop:integer;
      voltaA:AnsiChar;
      iretornar:Integer;
  begin




      I := 0;


      iretornar := Carrega_Lib();
      if (iretornar <> 0) then
         Exit;


      // Nova Transação Cancelamento PWEnums.PWOPER_SALEVOID
      MyFunc_iNewTransac := TPW_iNewTransac(GetProcedureAddress(MyLibC, 'PW_iNewTransac'));
      iRet := MyFunc_iNewTransac (PWEnums.PWOPER_SALEVOID);


      if (iRet <> PWEnums.PWRET_OK) then
         begin
            // Verifica se Foi inicializada a biblioteca
            if (iRet = PWEnums.PWRET_DLLNOTINIT)  then
                begin
                    MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
                    iRetErro := MyFunc_iGetResult (PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                    Volta := vGetpszData[0].pszDataxx;
                    MandaMemo(Volta);
                end
            // verifica se foi feito instalação
            else if (iRet = PWEnums.PWRET_NOTINST)  then
                begin
                    MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
                    iRetErro := MyFunc_iGetResult (PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));

                    Volta := vGetpszData[0].pszDataxx;
                    MandaMemo(Volta);
                end
            // Outro Erro
            else
                begin
                    MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
                    iRetErro := MyFunc_iGetResult (PWEnums.PWINFO_RESULTMSG, vGetpszData, SizeOf(vGetpszData));
                    Volta := vGetpszData[0].pszDataxx;
                    MandaMemo(Volta);
                end;


                Exit;

         end;




      AddMandatoryParams;  // Parametros obrigatórios



      //=====================================================
      //  Loop Para Capturar Dados e executar Transação
      //=====================================================
      while I < 100 do
      begin

          // Coloca o valor 10 (tamanho da estrutura de entrada) no parâmetro iNumParam
          xNumParam := 10;



          // Tenta executar a transação
          if(iRet <> PWEnums.PWRET_NOTHING) then
            begin
              //ShowMessage('Processando...');
            end;


          MyFunc_iExecTransac := TPW_iExecTransac(GetProcedureAddress(MyLibC, 'PW_iExecTransac'));
          iRet := MyFunc_iExecTransac (vGetdataArray, @xNumParam);
          if (iRet = PWEnums.PWRET_MOREDATA) then
            begin

               // Tenta capturar os dados faltantes, caso ocorra algum erro retorna
               iRetErro := iExecGetData(vGetdataArray,xNumParam);
               if (iRetErro <>  PWEnums.PWRET_OK) then
                  begin
                    Exit;
                  end
               else
                  begin
                    I := I+1;
                    Continue;
                  end;

            end
          else
            begin

                if(iRet = PWEnums.PWRET_NOTHING) then
                  begin
                    I := I+1;
                    Continue;
                  end;


                if iRet <> PWEnums.PWRET_OK then
                   begin

                      MandaMemo('Erro : ...' + IntToStr(iRet));
                      MandaMemo(' ');

                      Break;

                   end;


                if (iRet = PWEnums.PWRET_FROMHOSTPENDTRN) then
                    begin
                        // Busca Parametros da Transação Pendente
                        GetParamPendenteConfirma();
                    end
                else
                    begin
                        // Busca Parametros da Transação Atual
                        GetParamConfirma();
                    end;


                // Busca necessidade de Confirmação.
                MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
                iRet := MyFunc_iGetResult (PWEnums.PWINFO_CNFREQ, vGetpszData, SizeOf(vGetpszData));


                Volta := vGetpszData[0].pszDataxx;
                if (Volta = '1') then
                   begin
                      MandaMemo(' PWINFO_CNFREQ = 1');
                      MandaMemo(' ');
                      MandaMemo('É Necessário Confirmar esta Transação !');
                      MandaMemo(' ');

                      // Metodo confirma a transação
                      ConfirmaTrasacao();

                   end;



                   Break;

            end;



      end;

      PrintResultParams();


  end;





  //============================================================================
    {
      Busca Parametros para confirmação automatica da Ultima Transação de Venda.
    }
  //============================================================================
  function TPGWLib.GetParamConfirma: Integer;
  var
    I:Integer;
  begin

      MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
      iRetorno := MyFunc_iGetResult (PWEnums.PWINFO_REQNUM, vGetpszData, SizeOf(vGetpszData));
      for I := 0 to  SizeOf(gstConfirmData[0].szReqNum) do
        begin
          gstConfirmData[0].szReqNum[I] := vGetpszData[0].pszDataxx[I];
        end;

      MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
      iRetorno := MyFunc_iGetResult (PWEnums.PWINFO_AUTEXTREF, vGetpszData, SizeOf(vGetpszData));
      for I := 0 to SizeOf(gstConfirmData[0].szExtRef) do
        begin
          gstConfirmData[0].szExtRef[I] := vGetpszData[0].pszDataxx[I];
        end;


      MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
      iRetorno := MyFunc_iGetResult (PWEnums.PWINFO_AUTLOCREF, vGetpszData, SizeOf(vGetpszData));
      for I := 0 to SizeOf(gstConfirmData[0].szLocRef) do
        begin
          gstConfirmData[0].szLocRef[I] := vGetpszData[0].pszDataxx[I];
        end;

      MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
      iRetorno := MyFunc_iGetResult (PWEnums.PWINFO_VIRTMERCH, vGetpszData, SizeOf(vGetpszData));
      for I := 0 to SizeOf(gstConfirmData[0].szVirtMerch) do
        begin
          gstConfirmData[0].szVirtMerch[I] := vGetpszData[0].pszDataxx[I];
        end;

      MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
      iRetorno := MyFunc_iGetResult (PWEnums.PWINFO_AUTHSYST, vGetpszData, SizeOf(vGetpszData));
      for I := 0 to SizeOf(gstConfirmData[0].szAuthSyst) do
        begin
          gstConfirmData[0].szAuthSyst[I] := vGetpszData[0].pszDataxx[I];
        end;


      Result := iRetorno;



  end;


  //============================================================================
    {
      Busca Parametros para confirmação automatica da Ultima Transação de Venda.
    }
  //============================================================================
  function TPGWLib.GetParamPendenteConfirma: Integer;
  var
    I:Integer;
  begin

      MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
      iRetorno := MyFunc_iGetResult (PWEnums.PWINFO_PNDREQNUM, vGetpszData, SizeOf(vGetpszData));
      for I := 0 to  SizeOf(gstConfirmData[0].szReqNum) do
        begin
          gstConfirmData[0].szReqNum[I] := vGetpszData[0].pszDataxx[I];
        end;

      MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
      iRetorno := MyFunc_iGetResult (PWEnums.PWINFO_PNDAUTEXTREF, vGetpszData, SizeOf(vGetpszData));
      for I := 0 to SizeOf(gstConfirmData[0].szExtRef) do
        begin
          gstConfirmData[0].szExtRef[I] := vGetpszData[0].pszDataxx[I];
        end;

      MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
      iRetorno := MyFunc_iGetResult (PWEnums.PWINFO_PNDAUTLOCREF, vGetpszData, SizeOf(vGetpszData));
      for I := 0 to SizeOf(gstConfirmData[0].szLocRef) do
        begin
          gstConfirmData[0].szLocRef[I] := vGetpszData[0].pszDataxx[I];
        end;

      MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
      iRetorno := MyFunc_iGetResult (PWEnums.PWINFO_PNDVIRTMERCH, vGetpszData, SizeOf(vGetpszData));
      for I := 0 to SizeOf(gstConfirmData[0].szVirtMerch) do
        begin
          gstConfirmData[0].szVirtMerch[I] := vGetpszData[0].pszDataxx[I];
        end;

      MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
      iRetorno := MyFunc_iGetResult (PWEnums.PWINFO_PNDAUTHSYST, vGetpszData, SizeOf(vGetpszData));
      for I := 0 to SizeOf(gstConfirmData[0].szAuthSyst) do
        begin
          gstConfirmData[0].szAuthSyst[I] := vGetpszData[0].pszDataxx[I];
        end;


      Result := iRetorno;





  end;







  //=================================================================================
  //  Carrega Lib
  //=================================================================================
  function TPGWLib.Carrega_Lib:integer;
  var
    iretornar:Integer;
    vDiretorio:string;
  begin

      // Path do executavel
      vDiretorio:=ExtractFilePath(Application.ExeName + 'TestePaygo.so');


     iretornar:= 0;

     if MyLibC <>  DynLibs.NilHandle then
            begin
             // ShowMessage('Já Carregada');
            end
         else
            begin
              //ShowMessage('Lib Será Carregada');

              try
                   //Set8087CW(Get8087CW or $3f);
                   MyLibC := LoadLibrary(vDiretorio + 'PGWebLib.so');

              except

                 on E:EOutOfMemory do
                  ShowMessage(' Erro : ' +  E.Message);
                 on E:EAccessViolation do
                 ShowMessage(' Erro : ' +  E.Message);

              end;

              if MyLibC = dynlibs.NilHandle then
                  begin
                    ShowMessage(' PGWebLib.so Não Localizada');
                    iretornar := 1;
                  end;
            end;

      Result := iretornar;

  end;


  //=================================================================================
  //  Descarrega Lib
  //=================================================================================
  function TPGWLib.Libera_Lib: integer;
  begin

    if (MyLibC <>  DynLibs.NilHandle) then
      begin
         if FreeLibrary(MyLibC) then
            begin
              //ShowMessage('Lib Será Descarregada');
              MyLibC:= DynLibs.NilHandle;  // Descarrega LIB se já Estiver Carregado
            end
      end
    else
      begin
        // ShowMessage('Lib Não estava Carregada');
      end;

    Result := 0;

  end;


  //=====================================================================================*\
    {
       Funcao     :  PrintResultParams

       Descricao  :  Esta função exibe na tela todas as informações de resultado disponíveis
                     no momento em que foi chamada.

       Entradas   :  nao ha.

       Saidas     :  nao ha.

       Retorno    :  nao ha.
    }
  //=====================================================================================*/
  function TPGWLib.PrintResultParams: Integer;
  var
    I:Integer;
    Ir:Integer;
    iRet:Integer;
    szAux : PSZ_GetData;
    volta:AnsiString;

  begin

     I := 0;

     while I < 32524  do   // 2200 MAXINT16 32767
     begin



         MyFunc_iGetResult := TPW_iGetResult(GetProcedureAddress(MyLibC, 'PW_iGetResult'));
         iRet := MyFunc_iGetResult (I, szAux, SizeOf(vGetpszData));

         if( iRet = PWEnums.PWRET_OK) then
            begin
                 MandaMemo(pszGetInfoDescription(I) + '<0x' + IntToHex(I,2) + '> = ');
                 volta := szAux[0].pszDataxx;
                 MandaMemo(volta);
                 MandaMemo('');
            end;

            I := I+1;

     end;

  end;


  //=====================================================================================*\
    {
       Função Auxiliar
    }
    //=====================================================================================*\
  function TPGWLib.Aguardando: string;
  var
      Y:Integer;
  begin

     if (txt = '') then
        begin
          txt := 'Processando ';
        end;

     if (Length(txt) > 40) then
         begin
            TelPrincipal.Memo1.Lines.Add(' ');
            txt := 'Processando ';
         end;

     txt := txt + '.';
     Y := TelPrincipal.Memo1.CaretPos.Y;
     TelPrincipal.Memo1.Lines.Strings[Y] :=  txt;

  end;


  //=====================================================================================
    {
     Funcao     :  AddMandatoryParams

     Descricao  :  Esta função adiciona os parâmetros obrigatórios de toda mensagem para o
                   Pay&Go Web.
    }
  //=====================================================================================*/
  procedure TPGWLib.AddMandatoryParams;
  var
    FuncResult: Integer;
    iretornar:Integer;
  begin

     iretornar := Carrega_Lib();
     if (iretornar <> 0) then
        Exit;

     MyFunc_iAddParam := TPW_iAddParam(GetProcedureAddress(MyLibC, 'PW_iAddParam'));

     FuncResult:= MyFunc_iAddParam (PWEnums.PWINFO_AUTDEV,PWEnums.PGWEBLIBTEST_AUTDEV);
     FuncResult:= MyFunc_iAddParam (PWEnums.PWINFO_AUTVER, PWEnums.PGWEBLIBTEST_VERSION);
     FuncResult:= MyFunc_iAddParam (PWEnums.PWINFO_AUTNAME, PWEnums.PGWEBLIBTEST_AUTNAME);
     FuncResult:= MyFunc_iAddParam (PWEnums.PWINFO_AUTCAP, PWEnums.PGWEBLIBTEST_AUTCAP);
     FuncResult:= MyFunc_iAddParam (PWEnums.PWINFO_AUTHTECHUSER, PWEnums.PGWEBLIBTEST_AUTHTECHUSER);


     Exit;


  end;




  //=====================================================================================
  { Funcao     :  iExecGetData

     Descricao  :  Esta função obtém dos usuários os dados requisitado pelo Pay&Go Web.

     Entradas   :  vstGetData  :  Vetor com as informações dos dados a serem obtidos.
                   iNumParam   :  Número de dados a serem obtidos.

     Saidas     :  nao ha.

     Retorno    :  Código de resultado da operação.
   }
//=====================================================================================
function TPGWLib.iExecGetData( vstGetData:PW_GetData; iNumParam:Integer):Integer;
var
  I : Int16;
  StrTagNFCe: string;
  falta:string;
  iRet:Integer;
  iRetByte:Byte;
  strNome:string;
  xloop: integer;
  ulEvent:UInt32;
  x:integer;
  iRetStr: string;
  wTipoDado:Integer;
  iKey:Int16;
begin

               strNome := '';
               StrTagNFCe := '';

               ulEvent := 0;
               I := 0;


              //==========================================================
              // Loop Para Capturar e Adicionar dados solicitados pela SO.
              // Enquanto houverem dados para capturar
              //==========================================================
              while I < iNumParam do

                begin

                     // Imprime na tela qual informação está sendo capturada
                     iRetStr := pszGetInfoDescription(vstGetData[I].wIdentificador);
                     MandaMemo('dado a Capturar: ' + iRetStr + ' ' + IntToStr(vstGetData[I].wIdentificador));

                     case (vstGetData[I].bTipoDeDado) of


                       // Dados de Menu

                       PWEnums.PWDAT_MENU:

                             begin

                                 iRetByte := vstGetData[I].bTipoDeDado;
                                 MandaMemo('Tipo de Dado: MENU - ' + IntToStr(iRetByte));
                                 MandaMemo(vstGetData[i].szPrompt);


                                // Caso o modo autoatendimento esteja ativado, faz o menu no PIN-pad

                                if (gfAutoAtendimento = True) then
                                    begin
                                       if( vstGetData[I].bNumOpcoesMenu > 2) then
                                          begin
                                            MandaMemo('MUITAS OPÇÕES! MENU NAO PODE SER FEITO NO PINPAD!!!');
                                            //Result := 999;
                                            //Exit;
                                          end
                                       else
                                          begin
                                            MandaMemo('EXECUTANDO MENU NO PINPAD');
                                          end;



                                          //falta := '<F1> - ' + vstGetData[I].vszTextoMenu[0] + chr(13) + '<F2> - ' + vstGetData[I].vszTextoMenu[1] + chr(13) + '<F3> - ' + vstGetData[I].vszTextoMenu[2];
                                          falta := '<F1> - ' + vstGetData[I].vszTextoMenu[0] + chr(13) + '<F2> - ' + vstGetData[I].vszTextoMenu[1];


                                          while I < 10 do
                                          begin

                                              // Exibe a mensagem no PIN-pad
                                              MyFunc_iPPDisplay := TPW_iPPDisplay(GetProcedureAddress(MyLibC, 'PW_iPPDisplay'));
                                              iRet := MyFunc_iPPDisplay(falta);
                                              //iRet := PW_iPPDisplay(falta);
                                              if (iRet <> PWEnums.PWRET_OK) then
                                                 begin
                                                   MandaMemo('Erro em PW_iPPDisplay =  ' + IntToStr(iRet));
                                                   MandaMemo(' ');
                                                   Result := iRet;
                                                   Exit;
                                                 end;



                                                 while I < 10 do
                                                 begin
                                                     MyFunc_iPPEventLoop := TPW_iPPEventLoop(GetProcedureAddress(MyLibC, 'PW_iPPEventLoop'));
                                                     iRet := MyFunc_iPPEventLoop (vGetpszDisplay, sizeof(vGetpszDisplay));
                                                     if (iRet = PWEnums.PWRET_DISPLAY) then
                                                        begin
                                                            MandaMemo(vGetpszDisplay[0].szDspMsg);
                                                            MandaMemo(' ');
                                                        end;


                                                       if (iRet = PWEnums.PWRET_TIMEOUT)  then
                                                         begin
                                                           Result := iRet;
                                                           Exit;
                                                         end;


                                                       if (iRet = PWEnums.PWRET_OK)  then
                                                         begin
                                                           Break;
                                                         end;


                                                       Sleep(1000);

                                                       Aguardando();


                                                 end;



                                                // Aguarda a seleção da opção pelo cliente
                                                ulEvent := PWEnums.PWPPEVTIN_KEYS;
                                                MyFunc_iPPWaitEvent := TPW_iPPWaitEvent(GetProcedureAddress(MyLibC, 'PW_iPPWaitEvent'));
                                                iRet := MyFunc_iPPWaitEvent (ulEvent);
                                                if(iRet <> PWEnums.PWRET_OK)then
                                                  begin
                                                      MandaMemo('Erro em PPWaitEvent ' + IntToStr(iRet));
                                                      Result := iRet;
                                                      Exit;
                                                  end;

                                                 while I < 10 do
                                                 begin
                                                     MyFunc_iPPEventLoop := TPW_iPPEventLoop(GetProcedureAddress(MyLibC, 'PW_iPPEventLoop'));
                                                     iRet := MyFunc_iPPEventLoop (vGetpszDisplay, sizeof(vGetpszDisplay));
                                                     if (iRet = PWEnums.PWRET_DISPLAY) then
                                                        begin
                                                            MandaMemo(vGetpszDisplay[0].szDspMsg);
                                                            MandaMemo(' ');
                                                        end;


                                                       if (iRet = PWEnums.PWRET_TIMEOUT)  then
                                                         begin
                                                           Result := iRet;
                                                           Exit;
                                                         end;


                                                       if (iRet = PWEnums.PWRET_OK)  then
                                                         begin
                                                           Break;
                                                         end;


                                                       Sleep(1000);

                                                       Aguardando();

                                                 end;



                                                 if(ulEvent = PWEnums.PWPPEVT_KEYF1) then
                                                     begin
                                                        iKey := 48;
                                                        Break;
                                                     end
                                                 else if(ulEvent = PWEnums.PWPPEVT_KEYF2) then
                                                     begin
                                                        iKey := 49;
                                                        Break;
                                                     end
                                                 else if(ulEvent = PWEnums.PWPPEVT_KEYCANC) then
                                                     begin
                                                        MyFunc_iPPDisplay := TPW_iPPDisplay(GetProcedureAddress(MyLibC, 'PW_iPPDisplay'));
                                                        iRet := MyFunc_iPPDisplay('    OPERACAO        CANCELADA   ');
                                                        if (iRet <> PWEnums.PWRET_OK) then
                                                           begin
                                                             MandaMemo('Erro em PW_iPPDisplay =  ' + IntToStr(iRet));
                                                             MandaMemo(' ');
                                                             Result := iRet;
                                                             Exit;
                                                           end;

                                                           while I < 10 do
                                                           begin
                                                               MyFunc_iPPEventLoop := TPW_iPPEventLoop(GetProcedureAddress(MyLibC, 'PW_iPPEventLoop'));
                                                               iRet := MyFunc_iPPEventLoop (vGetpszDisplay, sizeof(vGetpszDisplay));
                                                               if (iRet = PWEnums.PWRET_DISPLAY) then
                                                                  begin
                                                                      MandaMemo(vGetpszDisplay[0].szDspMsg);
                                                                      MandaMemo(' ');
                                                                  end;


                                                                 if (iRet = PWEnums.PWRET_TIMEOUT)  then
                                                                   begin
                                                                     Result := iRet;
                                                                     Exit;
                                                                   end;


                                                                 if (iRet = PWEnums.PWRET_OK)  then
                                                                   begin
                                                                     Result := PWEnums.PWRET_CANCEL;
                                                                     Exit;
                                                                   end;


                                                                 Sleep(1000);

                                                                 Aguardando();

                                                           end;



                                                     end

                                                   else

                                                     begin
                                                     MyFunc_iPPDisplay := TPW_iPPDisplay(GetProcedureAddress(MyLibC, 'PW_iPPDisplay'));
                                                     iRet := MyFunc_iPPDisplay('   UTILIZE AS   TECLAS F1 OU F2');
                                                     if (iRet <> PWEnums.PWRET_OK) then
                                                         begin
                                                           MandaMemo('Erro em PW_iPPDisplay =  ' + IntToStr(iRet));
                                                           MandaMemo(' ');
                                                           Result := iRet;
                                                           Exit;
                                                        end;


                                                       while I < 10 do
                                                       begin
                                                           MyFunc_iPPEventLoop := TPW_iPPEventLoop(GetProcedureAddress(MyLibC, 'PW_iPPEventLoop'));
                                                           iRet := MyFunc_iPPEventLoop (vGetpszDisplay, sizeof(vGetpszDisplay));
                                                           if (iRet = PWEnums.PWRET_DISPLAY) then
                                                              begin
                                                                  MandaMemo(vGetpszDisplay[0].szDspMsg);
                                                                  MandaMemo(' ');
                                                              end;


                                                             if (iRet = PWEnums.PWRET_TIMEOUT)  then
                                                               begin
                                                                 Result := iRet;
                                                                 Exit;
                                                               end;


                                                             if (iRet = PWEnums.PWRET_OK)  then
                                                               begin
                                                                 Result := iRet;
                                                                 Exit;
                                                               end;


                                                             Sleep(100);

                                                             Aguardando();


                                                       end;

                                                     end;


                                          end;


                                    end

                                    // Fim do AA

                               else


                                begin

                                     //falta := vstGetData[I].szPrompt;
                                     //falta := vstGetData[I].szPrompt + chr(13);
                                     //falta := falta + ' ' + chr(13);

                                     x := 0;

                                     while (X < vstGetData[I].bNumOpcoesMenu) do
                                         begin

                                            falta := falta + IntToStr(x) + ' - ' + vstGetData[I].vszTextoMenu[x] + chr(13);

                                            x := x+1;
                                         end;


                                     x := 0;

                                     strNome := '';

                                     while (X < 5) do
                                         begin
                                           strNome := vInputBox('Selecione Opção', falta, '', vstGetData[I].bNumOpcoesMenu );


                                           try
                                              if (strNome = 'CANCELA') then
                                                  begin
                                                     Break;
                                                  end;

                                              iRetErro := StrToInt(strNome);
                                           Except
                                              ShowMessage('Escolha uma opção Válida');
                                              Continue;
                                           end;

                                           if (StrToInt(strNome) > (vstGetData[I].bNumOpcoesMenu - 1)) then
                                               begin
                                                 ShowMessage('Opção Inexistente');
                                                 Continue;
                                               end;

                                            // Busca Código Referente em vszValorMenu
                                            strNome := vstGetData[I].vszValorMenu[StrToInt(strNome)];                                            Break;

                                         end;


                                end;

                                if (strNome = 'CANCELA') then
                                    begin
                                        Break;
                                    end
                                else
                                    begin
                                        // Caso seja Auto Atendimento pega pela tecla escolhida
                                        if (gfAutoAtendimento = True) then
                                           begin
                                              strNome := vstGetData[I].vszValorMenu[iKey - 48];
                                           end;

                                         // Busca Identificador do Menu Escolhido

                                         MyFunc_iAddParam := TPW_iAddParam(GetProcedureAddress(MyLibC, 'PW_iAddParam'));
                                         iRet := MyFunc_iAddParam (vstGetData[I].wIdentificador,strNome);


                                         if (iRet = PWEnums.PWRET_OK) then
                                            begin
                                              Result := PWEnums.PWRET_OK;
                                            end
                                         else
                                            begin
                                              Result := iRet;
                                            end;

                                         Break;


                                    end;


                             end;



                       // Entrada Digitada
                        //     end;

                       PWEnums.PWDAT_TYPED:
                             begin
                               iRetByte := vstGetData[I].bTipoDeDado;
                               MandaMemo('Tipo de Dado: DIGITADO - ' + IntToStr(iRetByte));
                               MandaMemo(vstGetData[i].szPrompt);
                               MandaMemo('Tamanho Minimo: ' + IntToStr(vstGetData[I].bTamanhoMinimo));
                               MandaMemo('Tamanho Maximo: ' + IntToStr(vstGetData[I].bTamanhoMaximo));
                               iRetStr := vstGetData[I].szValorInicial;
                               MandaMemo('Valor Atual: ' + iRetStr);
                               MandaMemo('Mascara: ' +  vstGetData[i].szMascaraDeCaptura);
                               iRetByte := vstGetData[I].bValidacaoDado;
                               MandaMemo('Validação de Dado: ' + inttostr(iRetByte));
                               MandaMemo(' ');

                               falta := vstGetData[I].szPrompt + chr(13);

                               x := 0;

                               while (X < 5) do
                                   begin

                                       wTipoDado := 0;

                                       // Data
                                       if  (vstGetData[I].wIdentificador = PWEnums.PWINFO_TRNORIGDATE) then
                                            begin
                                              if (vstGetData[i].szMascaraDeCaptura = '@@/@@/@@@@') then
                                                  begin
                                                    wTipoDado := 1;
                                                  end
                                               else
                                                  begin
                                                    wTipoDado := 4;
                                                  end;
                                            end;
                                       // Valor
                                       if  ((vstGetData[I].wIdentificador = PWEnums.PWINFO_TOTAMNT)
                                            or (vstGetData[I].wIdentificador = PWEnums.PWINFO_TRNORIGAMNT)) then
                                            begin
                                              wTipoDado := 2;
                                            end;
                                       // Horario
                                       if  ((vstGetData[I].wIdentificador = 123) or (vstGetData[I].wIdentificador = 124)) then
                                            begin
                                              wTipoDado := 3;
                                            end;

                                        if (wTipoDado = 2) then
                                            begin
                                              falta := falta + '  ' + vstGetData[i].szMascaraDeCaptura;
                                              //ImputBox Especifico Para Valores Monetarios
                                              StrTagNFCe := vMInputBox('Informar: ',falta,'',4,2);
                                              //Retira Ponto e virgula da String
                                              StrTagNFCe := tirapontos(StrTagNFCe);
                                              if (StrTagNFCe = '000') then
                                                  StrTagNFCe := '';
                                            end
                                        else if (wTipoDado = 0) then
                                            begin
                                               StrTagNFCe:= vInputBox('Informar: ', falta,'',1);
                                            end
                                        else
                                            begin
                                               StrTagNFCe:= vMInputBox('Informar: ',falta,'',1,wTipoDado);
                                            end;


                                       if (StrTagNFCe = 'CANCELA') then
                                           begin
                                             mRCancelado := 1;
                                             Break;
                                           end
                                       else
                                           begin
                                             mRCancelado := 0;
                                           end;

                                       if (Length(StrTagNFCe) > vstGetData[I].bTamanhoMaximo) then
                                          begin
                                              ShowMessage('Valor Maior que Tamanho Maximo');
                                              Continue;
                                          end;

                                       if (Length(StrTagNFCe) < vstGetData[I].bTamanhoMinimo) then
                                          begin
                                              ShowMessage('Valor Menor que Tamanho Minimo');
                                              Continue;
                                          end;


                                       MyFunc_iAddParam := TPW_iAddParam(GetProcedureAddress(MyLibC, 'PW_iAddParam'));
                                       iRet := MyFunc_iAddParam (vstGetData[I].wIdentificador,StrTagNFCe);

                                       if (iRet <> 0) then
                                          begin
                                             ShowMessage('Erro ao Adicionar Parametros ' + IntToStr(iRet));
                                             Result := iRet;
                                             Exit;
                                           end
                                       else
                                           begin
                                             Result := PWEnums.PWRET_OK;
                                             Break;
                                           end;

                                   end;



                                if (StrTagNFCe = 'CANCELA') then
                                    begin
                                        Result := 1;
                                        Break;
                                    end
                                else
                                    begin
                                      I := I+1;
                                      continue;
                                    end;

                             end;


                       // Dados do Cartão

                       PWEnums.PWDAT_CARDINF:
                             begin


                             iRetByte := vstGetData[I].bTipoDeDado;
                             MandaMemo('Tipo de Dado: DADOS DO CARTAO - ' + IntToStr(iRetByte));


                             if(vstGetData[I].ulTipoEntradaCartao = 1) then
                               begin
                                 ShowMessage('ulTipoEntrada = 1');
                               end;

                                 try

                                    MyFunc_iPPGetCard := TPW_iPPGetCard(GetProcedureAddress(MyLibC,'PW_iPPGetCard'));
                                    iRet := MyFunc_iPPGetCard(I);

                                 Except

                                    on E:EOutOfMemory do
                                     ShowMessage(' ErroM : ' +  E.Message);
                                    on E:EAccessViolation do
                                    ShowMessage(' ErroAc : ' +  E.ClassName);


                                 end;


                                 if (iRet <> PWEnums.PWRET_OK) then
                                    begin
                                       Result := iRet;
                                       Exit;
                                    end;



                                 xloop := 0;

                                 while xloop < 10000 do
                                 begin


                                   MyFunc_iPPEventLoop := TPW_iPPEventLoop(GetProcedureAddress(MyLibC, 'PW_iPPEventLoop'));
                                   iRet := MyFunc_iPPEventLoop (vGetpszDisplay, sizeof(vGetpszDisplay));
                                   if (iRet = PWEnums.PWRET_DISPLAY) then
                                      begin
                                          MandaMemo(vGetpszDisplay[0].szDspMsg);
                                          MandaMemo(' ');
                                      end;

                                   //if((iRet <> PWEnums.PWRET_OK) And (iRet <> PWEnums.PWRET_DISPLAY) And (iRet <> PWEnums.PWRET_NOTHING)) then
                                   if (iRet = PWEnums.PWRET_OK)  then
                                     begin
                                       Result := iRet;
                                       Exit;
                                     end;


                                    xloop := xloop+1;



                                   Sleep(1000);


                                   // Verifica se Teclou <ESC>

                                   if GetKeyState(VK_ESCAPE)<>0 then
                                      begin
                                        MyFunc_iPPAbort := TPW_iPPAbort(GetProcedureAddress(MyLibC, 'PW_iPPAbort'));
                                        iRetErro := MyFunc_iPPAbort();
                                        MandaMemo(' ');
                                        MandaMemo('TRANSAÇÃO ABORTADA PELA APLICAÇÃO');
                                        mRCancelado := 1;
                                        Result := 1;
                                        Exit;
                                        Break;
                                      end
                                   else
                                      begin
                                        mRCancelado := 0;
                                      end;



                                 end;




                             end;



                            // Remoção do cartão do PIN-pad.

                            PWEnums.PWDAT_PPREMCRD:
                              begin
                                 //  MandaMemo('Loop');
                                 //  Aguardando();
                                 //  Application.ProcessMessages;
                                 iRetByte := vstGetData[I].bTipoDeDado;
                                 MandaMemo('Tipo de Dado: PWDAT_PPREMCRD - ' + IntToStr(iRetByte));

                                 MyFunc_iPPRemoveCard := TPW_iPPRemoveCard(GetProcedureAddress(MyLibC, 'PW_iPPRemoveCard'));
                                 iRet := MyFunc_iPPRemoveCard();

                                 if (iRet <> PWEnums.PWRET_OK) then
                                    begin
                                       Result := iRet;
                                       Exit;
                                    end;

                                 xloop := 0;

                                 while xloop < 10000 do
                                 begin

                                   MyFunc_iPPEventLoop := TPW_iPPEventLoop(GetProcedureAddress(MyLibC, 'PW_iPPEventLoop'));
                                   iRet := MyFunc_iPPEventLoop (vGetpszDisplay, sizeof(vGetpszDisplay));

                                   if (iRet = PWEnums.PWRET_DISPLAY) then
                                      begin
                                          MandaMemo(vGetpszDisplay[0].szDspMsg);
                                          MandaMemo(' ');
                                      end;

                                   //if((iRet <> PWEnums.PWRET_OK) And (iRet <> PWEnums.PWRET_DISPLAY) And (iRet <> PWEnums.PWRET_NOTHING)) then
                                   if (iRet = PWEnums.PWRET_OK)  then
                                     begin
                                       Result := iRet;
                                       Exit;
                                     end
                                   else
                                     begin
                                       MandaMemo(vGetpszDisplay[0].szDspMsg);
                                       MandaMemo(' ');
                                     end;

                                    xloop := xloop+1;

                                   Sleep(100);

                                  end;

                                  ShowMessage('Xloop: ' + IntToStr(xloop));


                              end;




                            // Captura da senha criptografada

                            PWEnums.PWDAT_PPENCPIN:
                               begin



                                 iRetByte := vstGetData[I].bTipoDeDado;
                                 MandaMemo('Tipo de Dado: SENHA - ' + IntToStr(iRetByte));


                                 MyFunc_iPPGetPIN := TPW_iPPGetPIN(GetProcedureAddress(MyLibC, 'PW_iPPGetPIN'));
                                 iRet := MyFunc_iPPGetPIN (I);
                                 if (iRet <> PWEnums.PWRET_OK) then
                                    begin
                                       Result := iRet;
                                       Exit;
                                    end;


                                 while xloop < 1000 do
                                 begin

                                   MyFunc_iPPEventLoop := TPW_iPPEventLoop(GetProcedureAddress(MyLibC, 'PW_iPPEventLoop'));
                                   iRet := MyFunc_iPPEventLoop (vGetpszDisplay, sizeof(vGetpszDisplay));
                                   if (iRet = PWEnums.PWRET_DISPLAY) then
                                      begin
                                          MandaMemo(vGetpszDisplay[0].szDspMsg);
                                          MandaMemo(' ');
                                      end;


                                   //if((iRet <> PWEnums.PWRET_OK) And (iRet <> PWEnums.PWRET_DISPLAY) And (iRet <> PWEnums.PWRET_NOTHING)) then
                                   if (iRet = PWEnums.PWRET_OK)  then
                                     begin
                                       Result := iRet;
                                       Exit;
                                     end;

                                   if (iRet = PWEnums.PWRET_TIMEOUT)  then
                                     begin
                                       Result := iRet;
                                       Exit;
                                     end;

                                    xloop := xloop+1;



                                   Sleep(1000);

                                   // Verifica se Teclou <ESC>

                                   if GetKeyState(VK_ESCAPE)<>0 then
                                      begin
                                        MyFunc_iPPAbort := TPW_iPPAbort(GetProcedureAddress(MyLibC, 'PW_iPPAbort'));
                                        iRetErro := MyFunc_iPPAbort();
                                        MandaMemo(' ');
                                        MandaMemo('TRANSAÇÃO ABORTADA PELA APLICAÇÃO');
                                        mRCancelado := 1;
                                        Exit;
                                        Break;
                                      end
                                   else
                                      begin
                                        mRCancelado := 0;
                                      end;


                                 end;



                                //

                               end;



                            // processamento off-line de cartão com chip

                            PWEnums.pWDAT_CARDOFF:

                                begin



                                 iRetByte := vstGetData[I].bTipoDeDado;
                                 MandaMemo('Tipo de Dado: CHIP OFFLINE - ' + IntToStr(iRetByte));

                                 MyFunc_iPPGoOnChip := TPW_iPPGoOnChip(GetProcedureAddress(MyLibC, 'PW_iPPGoOnChip'));
                                 iRet := MyFunc_iPPGoOnChip(I);

                                 if (iRet <> PWEnums.PWRET_OK) then
                                    begin
                                       Result := iRet;
                                       Exit;
                                    end;

                                 xloop := 0;

                                 while xloop < 10000 do
                                 begin

                                   MyFunc_iPPEventLoop := TPW_iPPEventLoop(GetProcedureAddress(MyLibC, 'PW_iPPEventLoop'));
                                   iRet := MyFunc_iPPEventLoop (vGetpszDisplay, sizeof(vGetpszDisplay));
                                   if (iRet = PWEnums.PWRET_DISPLAY) then
                                      begin
                                          MandaMemo(vGetpszDisplay[0].szDspMsg);
                                          MandaMemo(' ');
                                      end;


                                   if (iRet = PWEnums.PWRET_TIMEOUT)  then
                                     begin
                                       Result := iRet;
                                       Exit;
                                     end;


                                   //if((iRet <> PWEnums.PWRET_OK) And (iRet <> PWEnums.PWRET_DISPLAY) And (iRet <> PWEnums.PWRET_NOTHING)) then
                                   if (iRet = PWEnums.PWRET_OK)  then
                                     begin
                                       Result := iRet;
                                       Exit;
                                     end;


                                    xloop := xloop+1;



                                   Sleep(1000);

                                   // Verifica se Teclou <ESC>

                                   if GetKeyState(VK_ESCAPE)<>0 then
                                      begin
                                        MyFunc_iPPAbort := TPW_iPPAbort(GetProcedureAddress(MyLibC, 'PW_iPPAbort'));
                                        iRetErro := MyFunc_iPPAbort ();
                                        MandaMemo(' ');
                                        MandaMemo('TRANSAÇÃO ABORTADA PELA APLICAÇÃO');
                                        mRCancelado := 1;
                                        Result := 1;
                                        Exit;
                                      end
                                   else
                                      begin
                                        mRCancelado := 0;
                                      end;



                                  end;

                                 //


                                end;



                                // Captura de dado digitado no PIN-pad

                                PWEnums.PWDAT_PPENTRY:
                                  begin


                                     iRetByte := vstGetData[I].bTipoDeDado;
                                     MandaMemo('Tipo de Dado: DADO DIGITADO NO PINPAD - ' + IntToStr(iRetByte));

                                     MyFunc_iPPGetData := TPW_iPPGetData(GetProcedureAddress(MyLibC, 'PW_iPPGetData'));
                                     iRet := MyFunc_iPPGetData (I);

                                     if (iRet <> PWEnums.PWRET_OK) then
                                        begin
                                           Result := iRet;
                                           Exit;
                                        end;

                                     xloop := 0;


                                     while xloop < 10000 do
                                     begin

                                       MyFunc_iPPEventLoop := TPW_iPPEventLoop(GetProcedureAddress(MyLibC, 'PW_iPPEventLoop'));
                                       iRet := MyFunc_iPPEventLoop (vGetpszDisplay, sizeof(vGetpszDisplay));
                                       if (iRet = PWEnums.PWRET_DISPLAY) then
                                          begin
                                              MandaMemo(vGetpszDisplay[0].szDspMsg);
                                              MandaMemo(' ');
                                          end;


                                       if (iRet = PWEnums.PWRET_TIMEOUT)  then
                                         begin
                                           Result := iRet;
                                           Exit;
                                         end;


                                       if (iRet = PWEnums.PWRET_OK)  then
                                         begin
                                           Result := iRet;
                                           Exit;
                                         end;


                                        xloop := xloop+1;



                                        Sleep(1000);

                                        Aguardando();

                                  end;

                                  //


                                  end;


                                  // Processamento online do cartão com chip

                                  PWEnums.PWDAT_CARDONL:
                                    begin


                                       iRetByte := vstGetData[I].bTipoDeDado;
                                       MandaMemo('Tipo de Dado: CHIP ONLINE - ' + IntToStr(iRetByte));


                                       MyFunc_iPPFinishChip := TPW_iPPFinishChip(GetProcedureAddress(MyLibC, 'PW_iPPFinishChip'));
                                       iRet := MyFunc_iPPFinishChip(I);

                                       if (iRet <> PWEnums.PWRET_OK) then
                                          begin
                                             Result := iRet;
                                             Exit;
                                          end;

                                       xloop := 0;

                                       while xloop < 10000 do
                                       begin

                                        MyFunc_iPPEventLoop := TPW_iPPEventLoop(GetProcedureAddress(MyLibC, 'PW_iPPEventLoop'));
                                        iRet := MyFunc_iPPEventLoop (vGetpszDisplay, sizeof(vGetpszDisplay));

                                         if (iRet = PWEnums.PWRET_DISPLAY) then
                                            begin
                                                MandaMemo(vGetpszDisplay[0].szDspMsg);
                                                MandaMemo(' ');
                                            end;


                                         if (iRet = PWEnums.PWRET_TIMEOUT)  then
                                           begin
                                             Result := iRet;
                                             Exit;
                                           end;


                                         if (iRet = PWEnums.PWRET_OK)  then
                                           begin
                                             Result := iRet;
                                             Exit;
                                           end;


                                          xloop := xloop+1;



                                         Sleep(1000);


                                         // Verifica se Teclou <ESC>



                                         if GetKeyState(VK_ESCAPE)<>0 then
                                            begin
                                              MyFunc_iPPAbort := TPW_iPPAbort(GetProcedureAddress(MyLibC, 'PW_iPPAbort'));
                                              iRetErro := MyFunc_iPPAbort ();
                                              MandaMemo(' ');
                                              MandaMemo('TRANSAÇÃO ABORTADA PELA APLICAÇÃO');
                                              mRCancelado := 1;
                                              Result := 1;
                                              Exit;
                                            end
                                         else
                                            begin
                                              mRCancelado := 0;
                                            end;



                                         //Aguardando();


                                       end;


                                      //


                                    end;



                                  // Confirmação de dado no PIN-pad

                                  PWEnums.PWDAT_PPCONF:
                                  begin


                                       iRetByte := vstGetData[I].bTipoDeDado;
                                       MandaMemo('Tipo de Dado: CONFIRMA DADO - ' + IntToStr(iRetByte));

                                       MyFunc_iPPConfirmData := TPW_iPPConfirmData(GetProcedureAddress(MyLibC,'PW_iPPConfirmData'));
                                       iRet := MyFunc_iPPConfirmData(I);

                                       if (iRet <> PWEnums.PWRET_OK) then
                                          begin
                                             Result := iRet;
                                             Exit;
                                          end;

                                       xloop := 0;

                                       while xloop < 10000 do
                                       begin

                                        MyFunc_iPPEventLoop := TPW_iPPEventLoop(GetProcedureAddress(MyLibC, 'PW_iPPEventLoop'));
                                        iRet := MyFunc_iPPEventLoop (vGetpszDisplay, sizeof(vGetpszDisplay));
                                         if (iRet = PWEnums.PWRET_DISPLAY) then
                                            begin
                                                MandaMemo(vGetpszDisplay[0].szDspMsg);
                                                MandaMemo(' ');
                                            end;


                                         if (iRet = PWEnums.PWRET_TIMEOUT)  then
                                           begin
                                             Result := iRet;
                                             Exit;
                                           end;


                                         //if((iRet <> PWEnums.PWRET_OK) And (iRet <> PWEnums.PWRET_DISPLAY) And (iRet <> PWEnums.PWRET_NOTHING)) then
                                         if (iRet = PWEnums.PWRET_OK)  then
                                           begin
                                             Result := iRet;
                                             Exit;
                                           end;


                                          xloop := xloop+1;



                                         Sleep(1000);

                                         aguardando();

                                       end;

                                      ///


                                  end;



                                else


                                  begin

                                      ShowMessage('TIPO DE DADOS DESCONHECIDO : ' + IntToStr(vstGetData[I].bTipoDeDado));

                                  end;





                     end;





                    I := I+1;

                    continue;


                end;

                if ((strNome = 'CANCELA') or (StrTagNFCe = 'CANCELA')) then
                    begin
                      Result := 1;
                      mRCancelado := 1;
                    end
                else
                    begin
                      mRCancelado := 0;
                      Result := PWEnums.PWRET_OK;
                    end;


          end;
//=====================================================================================*\
  {
     Função Auxiliar
  }
//=====================================================================================*\
function TPGWLib.MandaMemo(Descr:string): integer;
begin

    if (TelPrincipal.Memo1.Visible = False) then
       begin
         TelPrincipal.Memo1.Visible := True;
       end;
         TelPrincipal.Memo1.Lines.Add(Descr);
         TelPrincipal.Memo1.SelStart := Length(TelPrincipal.Memo1.Text);
    Result := 0;


end;


//=====================================================================================*\
  {
   Funcao     :  pszGetInfoDescription

   Descricao  :  Esta função recebe um código PWINFO_XXX e retorna uma string com a
                 descrição da informação representada por aquele código.

   Entradas   :  wIdentificador :  Código da informação (PWINFO_XXX).

   Saidas     :  nao ha.

   Retorno    :  String representando o código recebido como parâmetro.
  }
//=====================================================================================*/
  function TPGWLib.pszGetInfoDescription(wIdentificador:Integer):string;
  begin

       case wIdentificador of

        PWEnums.PWINFO_OPERATION:  Result := 'PWINFO_OPERATION';

        PWEnums.PWINFO_POSID            :  Result := 'PWINFO_POSID';
        PWEnums.PWINFO_AUTNAME          :  Result := 'PWINFO_AUTNAME';
        PWEnums.PWINFO_AUTVER           :  Result := 'PWINFO_AUTVER';
        PWEnums.PWINFO_AUTDEV           :  Result := 'PWINFO_AUTDEV';
        PWEnums.PWINFO_DESTTCPIP        : Result := 'PWINFO_DESTTCPIP';
        PWEnums.PWINFO_MERCHCNPJCPF     : Result := 'PWINFO_MERCHCNPJCPF';
        PWEnums.PWINFO_AUTCAP           : Result := 'PWINFO_AUTCAP';
        PWEnums.PWINFO_TOTAMNT          : Result := 'PWINFO_TOTAMNT';
        PWEnums.PWINFO_CURRENCY         : Result := 'PWINFO_CURRENCY';
        PWEnums.PWINFO_CURREXP          : Result := 'PWINFO_CURREXP';
        PWEnums.PWINFO_FISCALREF        : Result := 'PWINFO_FISCALREF';
        PWEnums.PWINFO_CARDTYPE         : Result := 'PWINFO_CARDTYPE';
        PWEnums.PWINFO_PRODUCTNAME      : Result := 'PWINFO_PRODUCTNAME';
        PWEnums.PWINFO_DATETIME         : Result := 'PWINFO_DATETIME';
        PWEnums.PWINFO_REQNUM           : Result := 'PWINFO_REQNUM';
        PWEnums.PWINFO_AUTHSYST         : Result := 'PWINFO_AUTHSYST';
        PWEnums.PWINFO_VIRTMERCH        : Result := 'PWINFO_VIRTMERCH';
        PWEnums.PWINFO_AUTMERCHID       : Result := 'PWINFO_AUTMERCHID';
        PWEnums.PWINFO_PHONEFULLNO      : Result := 'PWINFO_PHONEFULLNO';
        PWEnums.PWINFO_FINTYPE          : Result := 'PWINFO_FINTYPE';
        PWEnums.PWINFO_INSTALLMENTS     : Result := 'PWINFO_INSTALLMENTS';
        PWEnums.PWINFO_INSTALLMDATE     : Result := 'PWINFO_INSTALLMDATE';
        PWEnums.PWINFO_PRODUCTID        : Result := 'PWINFO_PRODUCTID';
        PWEnums.PWINFO_RESULTMSG        : Result := 'PWINFO_RESULTMSG';
        PWEnums.PWINFO_CNFREQ           : Result := 'PWINFO_CNFREQ';
        PWEnums.PWINFO_AUTLOCREF        : Result := 'PWINFO_AUTLOCREF';
        PWEnums.PWINFO_AUTEXTREF        : Result := 'PWINFO_AUTEXTREF';
        PWEnums.PWINFO_AUTHCODE         : Result := 'PWINFO_AUTHCODE';
        PWEnums.PWINFO_AUTRESPCODE      : Result := 'PWINFO_AUTRESPCODE';
        PWEnums.PWINFO_DISCOUNTAMT      : Result := 'PWINFO_DISCOUNTAMT';
        PWEnums.PWINFO_CASHBACKAMT      : Result := 'PWINFO_CASHBACKAMT';
        PWEnums.PWINFO_CARDNAME         : Result := 'PWINFO_CARDNAME';
        PWEnums.PWINFO_ONOFF            : Result := 'PWINFO_ONOFF';
        PWEnums.PWINFO_BOARDINGTAX      : Result := 'PWINFO_BOARDINGTAX';
        PWEnums.PWINFO_TIPAMOUNT        : Result := 'PWINFO_TIPAMOUNT';
        PWEnums.PWINFO_INSTALLM1AMT     : Result := 'PWINFO_INSTALLM1AMT';
        PWEnums.PWINFO_INSTALLMAMNT     : Result := 'PWINFO_INSTALLMAMNT';
        PWEnums.PWINFO_RCPTFULL         : Result := 'PWINFO_RCPTFULL';
        PWEnums.PWINFO_RCPTMERCH        : Result := 'PWINFO_RCPTMERCH';
        PWEnums.PWINFO_RCPTCHOLDER      : Result := 'PWINFO_RCPTCHOLDER';
        PWEnums.PWINFO_RCPTCHSHORT      : Result := 'PWINFO_RCPTCHSHORT';
        PWEnums.PWINFO_TRNORIGDATE      : Result := 'PWINFO_TRNORIGDATE';
        PWEnums.PWINFO_TRNORIGTIME      : Result := 'PWINFO_TRNORIGTIME';
        PWEnums.PWINFO_TRNORIGNSU       : Result := 'PWINFO_TRNORIGNSU';
        PWEnums.PWINFO_TRNORIGAMNT      : Result := 'PWINFO_TRNORIGAMNT';
        PWEnums.PWINFO_TRNORIGAUTH      : Result := 'PWINFO_TRNORIGAUTH';
        PWEnums.PWINFO_TRNORIGREQNUM    : Result := 'PWINFO_TRNORIGREQNUM';
        PWEnums.PWINFO_CARDFULLPAN      : Result := 'PWINFO_CARDFULLPAN';
        PWEnums.PWINFO_CARDEXPDATE      : Result := 'PWINFO_CARDEXPDATE';
        PWEnums.PWINFO_CARDNAMESTD      : Result := 'PWINFO_CARDNAMESTD';
        PWEnums.PWINFO_CARDPARCPAN      : Result := 'PWINFO_CARDPARCPAN';
        PWEnums.PWINFO_BARCODENTMODE    : Result := 'PWINFO_BARCODENTMODE';
        PWEnums.PWINFO_BARCODE          : Result := 'PWINFO_BARCODE';
        PWEnums.PWINFO_MERCHADDDATA1    : Result := 'PWINFO_MERCHADDDATA1';
        PWEnums.PWINFO_MERCHADDDATA2    : Result := 'PWINFO_MERCHADDDATA2';
        PWEnums.PWINFO_MERCHADDDATA3    : Result := 'PWINFO_MERCHADDDATA3';
        PWEnums.PWINFO_MERCHADDDATA4    : Result := 'PWINFO_MERCHADDDATA4';
        PWEnums.PWINFO_PAYMNTTYPE       : Result := 'PWINFO_PAYMNTTYPE';
        PWEnums.PWINFO_USINGPINPAD      : Result := 'PWINFO_USINGPINPAD';
        PWEnums.PWINFO_PPCOMMPORT       : Result := 'PWINFO_PPCOMMPORT';
        PWEnums.PWINFO_IDLEPROCTIME     : Result := 'PWINFO_IDLEPROCTIME';
        PWEnums.PWINFO_PNDAUTHSYST      : Result := 'PWINFO_PNDAUTHSYST';
        PWEnums.PWINFO_PNDVIRTMERCH     : Result := 'PWINFO_PNDVIRTMERCH';
        PWEnums.PWINFO_PNDREQNUM        : Result := 'PWINFO_PNDREQNUM';
        PWEnums.PWINFO_PNDAUTLOCREF     : Result := 'PWINFO_PNDAUTLOCREF';
        PWEnums.PWINFO_PNDAUTEXTREF     : Result := 'PWINFO_PNDAUTEXTREF';
        else
        begin
          Result := 'PWINFO_XXX';
        end;

      end;


      end;


  //=====================================================================================*\
    {
     Funcao     :  PrintReturnDescription

     Descricao  :  Esta função recebe um código PWRET_XXX e imprime na tela a sua descrição.

     Entradas   :  iResult :   Código de resultado da transação (PWRET_XXX).

     Saidas     :  nao ha.

     Retorno    :  nao ha.
    }
  //=====================================================================================*/
  function TPGWLib.PrintReturnDescription(iReturnCode: Integer;
    pszDspMsg: string): Integer;
  begin

      case iReturnCode of


        PWEnums.PWRET_OK:
          begin
           MandaMemo('PWRET_OK');
          end;

        PWEnums.PWRET_INVCALL:
          begin
           MandaMemo('PWRET_INVCALL');
          end;

        PWEnums.PWRET_INVPARAM:
          begin
           MandaMemo('PWRET_INVPARAM');
          end;

        PWEnums.PWRET_NODATA:
          begin
           MandaMemo('PWRET_NODATA');
          end;

        PWEnums.PWRET_BUFOVFLW:
          begin
           MandaMemo('PWRET_BUFOVFLW');
          end;

        PWEnums.PWRET_MOREDATA:
          begin
           MandaMemo('PWRET_MOREDATA');
          end;

        PWEnums.PWRET_DLLNOTINIT:
          begin
           MandaMemo('PWRET_DLLNOTINIT');
          end;

        PWEnums.PWRET_NOTINST:
          begin
           MandaMemo('PWRET_NOTINST');
          end;

        PWEnums.PWRET_TRNNOTINIT:
          begin
           MandaMemo('PWRET_TRNNOTINIT');
          end;

        PWEnums.PWRET_NOMANDATORY:
          begin
           MandaMemo('PWRET_NOMANDATORY');
          end;

        PWEnums.PWRET_TIMEOUT:
          begin
           MandaMemo('PWRET_TIMEOUT');
          end;

        PWEnums.PWRET_CANCEL:
          begin
           MandaMemo('PWRET_CANCEL');
          end;

        PWEnums.PWRET_FALLBACK:
          begin
           MandaMemo('PWRET_FALLBACK');
          end;

        PWEnums.PWRET_DISPLAY:
          begin
           MandaMemo('PWRET_DISPLAY');
          end;
        PWEnums.PWRET_NOTHING:
          begin
           MandaMemo('PWRET_NOTHING');
          end;

        PWEnums.PWRET_FROMHOST:
        //printf("\nRetorno = ERRO DO HOST");
          begin
           MandaMemo('PWRET_FROMHOST');
          end;

        PWEnums.PWRET_SSLCERTERR:
          begin
           MandaMemo('PWRET_SSLCERTERR');
          end;

        PWEnums.PWRET_SSLNCONN:
          begin
           MandaMemo('PWRET_SSLNCONN');
          end;

        PWEnums.PWRET_FROMHOSTPENDTRN:
          begin
           MandaMemo('PWRET_FROMHOSTPENDTRN');
          end;

     else

        begin
          begin
           MandaMemo('OUTRO ERRO: ' + IntToStr(iReturnCode));
          end;

        end;



        if(iReturnCode <> PWEnums.PWRET_MOREDATA) and (iReturnCode <> PWEnums.PWRET_DISPLAY) and
            (iReturnCode <> PWEnums.PWRET_NOTHING) and (iReturnCode <> PWEnums.PWRET_FALLBACK) then
           begin
             //intResultParams();
           end;




      end;



  end;




end.

