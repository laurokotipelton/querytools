------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- NOTA_FISCAL SAIDA ---------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

DO $$
DECLARE
  P_REGIME VARCHAR;
  P_USA_ALIQ_ESPEC BOOLEAN;
  P_CODIGO_DA_LOJA BIGINT;
  P_DATA_INICIAL TIMESTAMP WITHOUT TIME ZONE;
  P_DATA_FINAL TIMESTAMP WITHOUT TIME ZONE;
BEGIN
  P_CODIGO_DA_LOJA := 1;
  P_USA_ALIQ_ESPEC := FALSE;
  P_DATA_INICIAL   := '2018-02-01';
  P_DATA_FINAL     := '2018-03-31';

  SELECT LOJ_REGIME_FEDERAL, LOJ_USA_ALICOTAS_ESPECIFICAS
    INTO P_REGIME, P_USA_ALIQ_ESPEC
    FROM PESSOA_LOJA
   WHERE LOJ_CODIGO = P_CODIGO_DA_LOJA
  ;

  IF (P_REGIME IS NOT NULL AND P_REGIME IN ('R', 'P')) THEN
    IF (P_REGIME = 'R') THEN
      -----------------------------------------------------------------------------------------------------------------------
      -----------------------------------------------------------------------------------------------------------------------
      -- LUCRO REAL ---------------------------------------------------------------------------------------------------------
      -----------------------------------------------------------------------------------------------------------------------
      -----------------------------------------------------------------------------------------------------------------------
      UPDATE ITEM_NOTA_FISCAL INF2
         SET ITN_CST_PIS = CAST(CASE WHEN ((P_USA_ALIQ_ESPEC IS NOT NULL) AND (P_USA_ALIQ_ESPEC = TRUE))
                                     THEN (CASE 
                                               WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'ATACADO') THEN (IFA.IMPFEDSTSAI)
                                               WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'VAREJO')  THEN (IFV.IMPFEDSTSAI)
                                               WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'SIMPLES') THEN (IFS.IMPFEDSTSAI)
                                               ELSE (IFG.IMPFEDSTSAI)
                                           END)
                                     ELSE (IFG.IMPFEDSTSAI)
                                END AS BIGINT)
           , ITN_ALIQUOTA_PIS = CASE WHEN ((P_USA_ALIQ_ESPEC IS NOT NULL) AND (P_USA_ALIQ_ESPEC = TRUE))
                                     THEN (CASE 
                                               WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'ATACADO') THEN (IFA.IMPFEDALQSAI)
                                               WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'VAREJO')  THEN (IFV.IMPFEDALQSAI)
                                               WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'SIMPLES') THEN (IFS.IMPFEDALQSAI)
                                               ELSE (IFG.IMPFEDALQSAI)
                                           END)
                                     ELSE (IFG.IMPFEDALQSAI)
                                END
           , ITN_VALOR_PIS = ROUND(INF2.ITN_BASE_CALCULO_PIS * ((CASE WHEN ((P_USA_ALIQ_ESPEC IS NOT NULL) AND (P_USA_ALIQ_ESPEC = TRUE))
                                                                      THEN (CASE 
                                                                                WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'ATACADO') THEN (IFA.IMPFEDALQSAI)
                                                                                WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'VAREJO')  THEN (IFV.IMPFEDALQSAI)
                                                                                WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'SIMPLES') THEN (IFS.IMPFEDALQSAI)
                                                                                ELSE (IFG.IMPFEDALQSAI)
                                                                            END)
                                                                      ELSE (IFG.IMPFEDALQSAI)
                                                                 END) / 100), 2)
        FROM      PRODUTO                     P
       INNER JOIN IMPOSTOS_FEDERAIS_PRODUTO   IFP    ON (P.PROCOD = IFP.PROCOD)
       INNER JOIN IMPOSTOS_FEDERAIS           IF     ON (IF.IMPFEDSIM = IFP.IMPFEDSIM
                                                    AND  IF.IMPFEDTIP = 'PIS')
       INNER JOIN IMPOSTOS_FEDERAIS_GERAL     IFG    ON (IF.IMPFEDGERALID = IFG.IMPFEDGERALID)
       INNER JOIN IMPOSTOS_FEDERAIS_ATACADO   IFA    ON (IF.IMPFEDATACADOID = IFA.IMPFEDATACADOID)
       INNER JOIN IMPOSTOS_FEDERAIS_VAREJO    IFV    ON (IF.IMPFEDVAREJOID = IFV.IMPFEDVAREJOID)
       INNER JOIN IMPOSTOS_FEDERAIS_SIMPLES   IFS    ON (IF.IMPFEDSIMPLESID = IFS.IMPFEDSIMPLESID)
       INNER JOIN ITEM_NOTA_FISCAL            INF    ON (INF.PROCOD = P.PROCOD)
       INNER JOIN NOTA_FISCAL                 NF     ON (NF.NTA_CODIGO = INF.NTA_CODIGO
                                                    AND  NF.LOJ_CODIGO = P_CODIGO_DA_LOJA
                                                    AND  NF.NTA_SITUACAO = 'EFETIVADA'
                                                    AND  NF.NTA_TIPO_OPERACAO = 'SAIDA'
                                                    AND  NF.NTA_DATA_OPERACAO BETWEEN P_DATA_INICIAL AND P_DATA_FINAL)
        LEFT JOIN PESSOA_CLIENTE              PC     ON (PC.PES_CODIGO = NF.PES_CODIGO)
       WHERE INF.ITN_ID = INF2.ITN_ID
      ;

      UPDATE ITEM_NOTA_FISCAL INF2
         SET ITN_CST_COFINS = CAST(CASE WHEN ((P_USA_ALIQ_ESPEC IS NOT NULL) AND (P_USA_ALIQ_ESPEC = TRUE))
                                        THEN (CASE 
                                                  WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'ATACADO') THEN (IFA.IMPFEDSTSAI)
                                                  WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'VAREJO')  THEN (IFV.IMPFEDSTSAI)
                                                  WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'SIMPLES') THEN (IFS.IMPFEDSTSAI)
                                                  ELSE (IFG.IMPFEDSTSAI)
                                              END)
                                        ELSE (IFG.IMPFEDSTSAI)
                                   END AS BIGINT)
           , ITN_ALIQUOTA_COFINS = CASE WHEN ((P_USA_ALIQ_ESPEC IS NOT NULL) AND (P_USA_ALIQ_ESPEC = TRUE))
                                        THEN (CASE 
                                                  WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'ATACADO') THEN (IFA.IMPFEDALQSAI)
                                                  WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'VAREJO')  THEN (IFV.IMPFEDALQSAI)
                                                  WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'SIMPLES') THEN (IFS.IMPFEDALQSAI)
                                                  ELSE (IFG.IMPFEDALQSAI)
                                              END)
                                        ELSE (IFG.IMPFEDALQSAI)
                                   END
           , ITN_VALOR_COFINS = ROUND(INF2.ITN_BASE_CALCULO_PIS * ((CASE WHEN ((P_USA_ALIQ_ESPEC IS NOT NULL) AND (P_USA_ALIQ_ESPEC = TRUE))
                                                                         THEN (CASE 
                                                                                   WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'ATACADO') THEN (IFA.IMPFEDALQSAI)
                                                                                   WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'VAREJO')  THEN (IFV.IMPFEDALQSAI)
                                                                                   WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'SIMPLES') THEN (IFS.IMPFEDALQSAI)
                                                                                   ELSE (IFG.IMPFEDALQSAI)
                                                                               END)
                                                                         ELSE (IFG.IMPFEDALQSAI)
                                                                    END) / 100), 2)
        FROM      PRODUTO                     P
       INNER JOIN IMPOSTOS_FEDERAIS_PRODUTO   IFP    ON (P.PROCOD = IFP.PROCOD)
       INNER JOIN IMPOSTOS_FEDERAIS           IF     ON (IF.IMPFEDSIM = IFP.IMPFEDSIM
                                                    AND  IF.IMPFEDTIP = 'COFINS')
       INNER JOIN IMPOSTOS_FEDERAIS_GERAL     IFG    ON (IF.IMPFEDGERALID = IFG.IMPFEDGERALID)
       INNER JOIN IMPOSTOS_FEDERAIS_ATACADO   IFA    ON (IF.IMPFEDATACADOID = IFA.IMPFEDATACADOID)
       INNER JOIN IMPOSTOS_FEDERAIS_VAREJO    IFV    ON (IF.IMPFEDVAREJOID = IFV.IMPFEDVAREJOID)
       INNER JOIN IMPOSTOS_FEDERAIS_SIMPLES   IFS    ON (IF.IMPFEDSIMPLESID = IFS.IMPFEDSIMPLESID)
       INNER JOIN ITEM_NOTA_FISCAL            INF    ON (INF.PROCOD = P.PROCOD)
       INNER JOIN NOTA_FISCAL                 NF     ON (NF.NTA_CODIGO = INF.NTA_CODIGO
                                                    AND  NF.LOJ_CODIGO = P_CODIGO_DA_LOJA
                                                    AND  NF.NTA_SITUACAO = 'EFETIVADA'
                                                    AND  NF.NTA_TIPO_OPERACAO = 'SAIDA'
                                                    AND  NF.NTA_DATA_OPERACAO BETWEEN P_DATA_INICIAL AND P_DATA_FINAL)
        LEFT JOIN PESSOA_CLIENTE              PC     ON (PC.PES_CODIGO = NF.PES_CODIGO)
       WHERE INF.ITN_ID = INF2.ITN_ID
      ;
    ELSE
      -----------------------------------------------------------------------------------------------------------------------
      -----------------------------------------------------------------------------------------------------------------------
      -- LUCRO PRESUMIDO ----------------------------------------------------------------------------------------------------
      -----------------------------------------------------------------------------------------------------------------------
      -----------------------------------------------------------------------------------------------------------------------
      UPDATE ITEM_NOTA_FISCAL INF2
         SET ITN_CST_PIS = CAST(CASE WHEN ((P_USA_ALIQ_ESPEC IS NOT NULL) AND (P_USA_ALIQ_ESPEC = TRUE))
                                     THEN (CASE
                                               WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'ATACADO') THEN (IFA.IMPFEDSTSAIPRE)
                                               WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'VAREJO')  THEN (IFV.IMPFEDSTSAIPRE)
                                               WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'SIMPLES') THEN (IFS.IMPFEDSTSAIPRE)
                                               ELSE (IFG.IMPFEDSTSAIPRE)
                                           END)
                                     ELSE (IFG.IMPFEDSTSAIPRE)
                                END AS BIGINT)
           , ITN_ALIQUOTA_PIS = CASE WHEN ((P_USA_ALIQ_ESPEC IS NOT NULL) AND (P_USA_ALIQ_ESPEC = TRUE))
                                     THEN (CASE 
                                               WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'ATACADO') THEN (IFA.IMPFEDALQSAIPRE)
                                               WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'VAREJO')  THEN (IFV.IMPFEDALQSAIPRE)
                                               WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'SIMPLES') THEN (IFS.IMPFEDALQSAIPRE)
                                               ELSE (IFG.IMPFEDALQSAIPRE)
                                           END)
                                     ELSE (IFG.IMPFEDALQSAIPRE)
                                END
           , ITN_VALOR_PIS = ROUND(INF2.ITN_BASE_CALCULO_PIS * ((CASE WHEN ((P_USA_ALIQ_ESPEC IS NOT NULL) AND (P_USA_ALIQ_ESPEC = TRUE))
                                                                      THEN (CASE 
                                                                                WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'ATACADO') THEN (IFA.IMPFEDALQSAIPRE)
                                                                                WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'VAREJO')  THEN (IFV.IMPFEDALQSAIPRE)
                                                                                WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'SIMPLES') THEN (IFS.IMPFEDALQSAIPRE)
                                                                                ELSE (IFG.IMPFEDALQSAIPRE)
                                                                            END)
                                                                      ELSE (IFG.IMPFEDALQSAIPRE)
                                                                 END) / 100), 2)
        FROM      PRODUTO                     P
       INNER JOIN IMPOSTOS_FEDERAIS_PRODUTO   IFP    ON (P.PROCOD = IFP.PROCOD)
       INNER JOIN IMPOSTOS_FEDERAIS           IF     ON (IF.IMPFEDSIM = IFP.IMPFEDSIM
                                                    AND  IF.IMPFEDTIP = 'PIS')
       INNER JOIN IMPOSTOS_FEDERAIS_GERAL     IFG    ON (IF.IMPFEDGERALID = IFG.IMPFEDGERALID)
       INNER JOIN IMPOSTOS_FEDERAIS_ATACADO   IFA    ON (IF.IMPFEDATACADOID = IFA.IMPFEDATACADOID)
       INNER JOIN IMPOSTOS_FEDERAIS_VAREJO    IFV    ON (IF.IMPFEDVAREJOID = IFV.IMPFEDVAREJOID)
       INNER JOIN IMPOSTOS_FEDERAIS_SIMPLES   IFS    ON (IF.IMPFEDSIMPLESID = IFS.IMPFEDSIMPLESID)
       INNER JOIN ITEM_NOTA_FISCAL            INF    ON (INF.PROCOD = P.PROCOD)
       INNER JOIN NOTA_FISCAL                 NF     ON (NF.NTA_CODIGO = INF.NTA_CODIGO
                                                    AND  NF.LOJ_CODIGO = P_CODIGO_DA_LOJA
                                                    AND  NF.NTA_SITUACAO = 'EFETIVADA'
                                                    AND  NF.NTA_TIPO_OPERACAO = 'SAIDA'
                                                    AND  NF.NTA_DATA_OPERACAO BETWEEN P_DATA_INICIAL AND P_DATA_FINAL)
        LEFT JOIN PESSOA_CLIENTE              PC     ON (PC.PES_CODIGO = NF.PES_CODIGO)
       WHERE INF.ITN_ID = INF2.ITN_ID
      ;

      UPDATE ITEM_NOTA_FISCAL INF2
         SET ITN_CST_COFINS = CAST(CASE WHEN ((P_USA_ALIQ_ESPEC IS NOT NULL) AND (P_USA_ALIQ_ESPEC = TRUE))
                                        THEN (CASE 
                                                  WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'ATACADO') THEN (IFA.IMPFEDSTSAIPRE)
                                                  WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'VAREJO')  THEN (IFV.IMPFEDSTSAIPRE)
                                                  WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'SIMPLES') THEN (IFS.IMPFEDSTSAIPRE)
                                                  ELSE (IFG.IMPFEDSTSAIPRE)
                                              END)
                                        ELSE (IFG.IMPFEDSTSAIPRE)
                                   END AS BIGINT)
           , ITN_ALIQUOTA_COFINS = CASE WHEN ((P_USA_ALIQ_ESPEC IS NOT NULL) AND (P_USA_ALIQ_ESPEC = TRUE))
                                        THEN (CASE 
                                                  WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'ATACADO') THEN (IFA.IMPFEDALQSAIPRE)
                                                  WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'VAREJO')  THEN (IFV.IMPFEDALQSAIPRE)
                                                  WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'SIMPLES') THEN (IFS.IMPFEDALQSAIPRE)
                                                  ELSE (IFG.IMPFEDALQSAIPRE)
                                              END)
                                        ELSE (IFG.IMPFEDALQSAIPRE)
                                   END
           , ITN_VALOR_COFINS = ROUND(INF2.ITN_BASE_CALCULO_PIS * ((CASE WHEN ((P_USA_ALIQ_ESPEC IS NOT NULL) AND (P_USA_ALIQ_ESPEC = TRUE))
                                                                         THEN (CASE 
                                                                                   WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'ATACADO') THEN (IFA.IMPFEDALQSAIPRE)
                                                                                   WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'VAREJO')  THEN (IFV.IMPFEDALQSAIPRE)
                                                                                   WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'SIMPLES') THEN (IFS.IMPFEDALQSAIPRE)
                                                                                   ELSE (IFG.IMPFEDALQSAIPRE)
                                                                               END)
                                                                         ELSE (IFG.IMPFEDALQSAIPRE)
                                                                    END) / 100), 2)
        FROM      PRODUTO                     P
       INNER JOIN IMPOSTOS_FEDERAIS_PRODUTO   IFP    ON (P.PROCOD = IFP.PROCOD)
       INNER JOIN IMPOSTOS_FEDERAIS           IF     ON (IF.IMPFEDSIM = IFP.IMPFEDSIM
                                                    AND  IF.IMPFEDTIP = 'COFINS')
       INNER JOIN IMPOSTOS_FEDERAIS_GERAL     IFG    ON (IF.IMPFEDGERALID = IFG.IMPFEDGERALID)
       INNER JOIN IMPOSTOS_FEDERAIS_ATACADO   IFA    ON (IF.IMPFEDATACADOID = IFA.IMPFEDATACADOID)
       INNER JOIN IMPOSTOS_FEDERAIS_VAREJO    IFV    ON (IF.IMPFEDVAREJOID = IFV.IMPFEDVAREJOID)
       INNER JOIN IMPOSTOS_FEDERAIS_SIMPLES   IFS    ON (IF.IMPFEDSIMPLESID = IFS.IMPFEDSIMPLESID)
       INNER JOIN ITEM_NOTA_FISCAL            INF    ON (INF.PROCOD = P.PROCOD)
       INNER JOIN NOTA_FISCAL                 NF     ON (NF.NTA_CODIGO = INF.NTA_CODIGO
                                                    AND  NF.LOJ_CODIGO = P_CODIGO_DA_LOJA
                                                    AND  NF.NTA_SITUACAO = 'EFETIVADA'
                                                    AND  NF.NTA_TIPO_OPERACAO = 'SAIDA'
                                                    AND  NF.NTA_DATA_OPERACAO BETWEEN P_DATA_INICIAL AND P_DATA_FINAL)
        LEFT JOIN PESSOA_CLIENTE              PC     ON (PC.PES_CODIGO = NF.PES_CODIGO)
       WHERE INF.ITN_ID = INF2.ITN_ID
      ;
    END IF;

    UPDATE NOTA_FISCAL NF
       SET NTA_TOTAL_VALOR_PIS = (SELECT SUM(INF1.ITN_VALOR_PIS) FROM ITEM_NOTA_FISCAL INF1 WHERE INF1.NTA_CODIGO = NF.NTA_CODIGO)
         , NTA_TOTAL_VALOR_COFINS = (SELECT SUM(INF2.ITN_VALOR_COFINS) FROM ITEM_NOTA_FISCAL INF2 WHERE INF2.NTA_CODIGO = NF.NTA_CODIGO)
     WHERE NF.LOJ_CODIGO = P_CODIGO_DA_LOJA
       AND NF.NTA_SITUACAO = 'EFETIVADA'
       AND NF.NTA_TIPO_OPERACAO = 'SAIDA'
       AND NF.NTA_DATA_OPERACAO BETWEEN P_DATA_INICIAL AND P_DATA_FINAL
    ;
  END IF;
END;
$$ LANGUAGE PLPGSQL;

