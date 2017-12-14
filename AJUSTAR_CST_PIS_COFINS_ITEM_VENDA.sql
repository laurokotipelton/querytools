------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- ITEM DE VENDA -------------------------------------------------------------------
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
  P_DATA_INICIAL   := '2017-10-01';
  P_DATA_FINAL     := '2017-10-30';

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
      UPDATE ITEM_VENDA IV
         SET ITVCSTPIS = CASE WHEN ((P_USA_ALIQ_ESPEC IS NOT NULL) AND (P_USA_ALIQ_ESPEC = TRUE))
                              THEN (CASE 
                                         WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'ATACADO') THEN (IFA.IMPFEDSTSAI)
                                         WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'VAREJO')  THEN (IFV.IMPFEDSTSAI)
                                         WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'SIMPLES') THEN (IFS.IMPFEDSTSAI)
                                         ELSE (IFG.IMPFEDSTSAI)
                                    END)
                              ELSE (IF.IMPFEDSTSAI)
                         END
           , ITVALQPIS = CASE WHEN ((P_USA_ALIQ_ESPEC IS NOT NULL) AND (P_USA_ALIQ_ESPEC = TRUE))
                              THEN (CASE 
                                         WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'ATACADO') THEN (IFA.IMPFEDALQSAI)
                                         WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'VAREJO')  THEN (IFV.IMPFEDALQSAI)
                                         WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'SIMPLES') THEN (IFS.IMPFEDALQSAI)
                                         ELSE (IFG.IMPFEDALQSAI)
                                    END)
                              ELSE (IF.IMPFEDALQSAI)
                         END
        FROM      PRODUTO                     P
       INNER JOIN TRANSACAO                   T     ON (T.LOJCOD = P_CODIGO_DA_LOJA
                                                   AND  T.TRNDAT BETWEEN P_DATA_INICIAL AND P_DATA_FINAL)
       INNER JOIN IMPOSTOS_FEDERAIS_PRODUTO   IFP   ON (P.PROCOD = IFP.PROCOD)
       INNER JOIN IMPOSTOS_FEDERAIS           IF    ON (IF.IMPFEDSIM = IFP.IMPFEDSIM
                                                   AND  IF.IMPFEDTIP = 'P')
       INNER JOIN IMPOSTOS_FEDERAIS_GERAL     IFG   ON (IF.IMPFEDGERALID = IFG.IMPFEDGERALID)
       INNER JOIN IMPOSTOS_FEDERAIS_ATACADO   IFA   ON (IF.IMPFEDATACADOID = IFA.IMPFEDATACADOID)
       INNER JOIN IMPOSTOS_FEDERAIS_VAREJO    IFV   ON (IF.IMPFEDVAREJOID = IFV.IMPFEDVAREJOID)
       INNER JOIN IMPOSTOS_FEDERAIS_SIMPLES   IFS   ON (IF.IMPFEDSIMPLESID = IFS.IMPFEDSIMPLESID)
        LEFT JOIN PESSOA_CLIENTE              PC    ON (PC.CLI_CODIGO = T.CLICOD)
       WHERE IV.LOJCOD = P_CODIGO_DA_LOJA
         AND IV.LOJCOD = T.LOJCOD
         AND IV.TRNDAT = T.TRNDAT
         AND IV.CXANUM = T.CXANUM
         AND IV.TRNSEQ = T.TRNSEQ
         AND IV.TRNDAT BETWEEN P_DATA_INICIAL AND P_DATA_FINAL
         AND P.PROCOD = IV.PROCOD
         AND (IV.ITVCSTPIS IS NULL
          OR  TRIM(IV.ITVCSTPIS) = '')
      ;

      UPDATE ITEM_VENDA IV
         SET ITVCSTCOFINS = CASE WHEN ((P_USA_ALIQ_ESPEC IS NOT NULL) AND (P_USA_ALIQ_ESPEC = TRUE))
                                 THEN (CASE 
                                            WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'ATACADO') THEN (IFA.IMPFEDSTSAI)
                                            WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'VAREJO')  THEN (IFV.IMPFEDSTSAI)
                                            WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'SIMPLES') THEN (IFS.IMPFEDSTSAI)
                                            ELSE (IFG.IMPFEDSTSAI)
                                       END)
                                 ELSE (IF.IMPFEDSTSAI)
                            END
           , ITVALQCOFINS = CASE WHEN ((P_USA_ALIQ_ESPEC IS NOT NULL) AND (P_USA_ALIQ_ESPEC = TRUE))
                                 THEN (CASE 
                                            WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'ATACADO') THEN (IFA.IMPFEDALQSAI)
                                            WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'VAREJO')  THEN (IFV.IMPFEDALQSAI)
                                            WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'SIMPLES') THEN (IFS.IMPFEDALQSAI)
                                            ELSE (IFG.IMPFEDALQSAI)
                                       END)
                                 ELSE (IF.IMPFEDALQSAI)
                            END
        FROM      PRODUTO                     P
       INNER JOIN TRANSACAO                   T     ON (T.LOJCOD = P_CODIGO_DA_LOJA
                                                   AND  T.TRNDAT BETWEEN P_DATA_INICIAL AND P_DATA_FINAL)
       INNER JOIN IMPOSTOS_FEDERAIS_PRODUTO   IFP   ON (P.PROCOD = IFP.PROCOD)
       INNER JOIN IMPOSTOS_FEDERAIS           IF    ON (IF.IMPFEDSIM = IFP.IMPFEDSIM
                                                   AND  IF.IMPFEDTIP = 'C')
       INNER JOIN IMPOSTOS_FEDERAIS_GERAL     IFG   ON (IF.IMPFEDGERALID = IFG.IMPFEDGERALID)
       INNER JOIN IMPOSTOS_FEDERAIS_ATACADO   IFA   ON (IF.IMPFEDATACADOID = IFA.IMPFEDATACADOID)
       INNER JOIN IMPOSTOS_FEDERAIS_VAREJO    IFV   ON (IF.IMPFEDVAREJOID = IFV.IMPFEDVAREJOID)
       INNER JOIN IMPOSTOS_FEDERAIS_SIMPLES   IFS   ON (IF.IMPFEDSIMPLESID = IFS.IMPFEDSIMPLESID)
        LEFT JOIN PESSOA_CLIENTE              PC    ON (PC.CLI_CODIGO = T.CLICOD)
       WHERE IV.LOJCOD = P_CODIGO_DA_LOJA
         AND IV.LOJCOD = T.LOJCOD
         AND IV.TRNDAT = T.TRNDAT
         AND IV.CXANUM = T.CXANUM
         AND IV.TRNSEQ = T.TRNSEQ
         AND IV.TRNDAT BETWEEN P_DATA_INICIAL AND P_DATA_FINAL
         AND P.PROCOD = IV.PROCOD
         AND (IV.ITVCSTCOFINS IS NULL
          OR  TRIM(IV.ITVCSTCOFINS) = '')
      ;
    ELSE
      -----------------------------------------------------------------------------------------------------------------------
      -----------------------------------------------------------------------------------------------------------------------
      -- LUCRO PRESUMIDO ----------------------------------------------------------------------------------------------------
      -----------------------------------------------------------------------------------------------------------------------
      -----------------------------------------------------------------------------------------------------------------------
      UPDATE ITEM_VENDA IV
         SET ITVCSTPIS = CASE WHEN ((P_USA_ALIQ_ESPEC IS NOT NULL) AND (P_USA_ALIQ_ESPEC = TRUE))
                              THEN (CASE 
                                         WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'ATACADO') THEN (IFA.IMPFEDSTSAIPRE)
                                         WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'VAREJO')  THEN (IFV.IMPFEDSTSAIPRE)
                                         WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'SIMPLES') THEN (IFS.IMPFEDSTSAIPRE)
                                         ELSE (IFG.IMPFEDSTSAIPRE)
                                    END)
                              ELSE (IF.IMPFEDSTSAIPRE)
                         END
           , ITVALQPIS = CASE WHEN ((P_USA_ALIQ_ESPEC IS NOT NULL) AND (P_USA_ALIQ_ESPEC = TRUE))
                              THEN (CASE 
                                         WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'ATACADO') THEN (IFA.IMPFEDALQSAIPRE)
                                         WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'VAREJO')  THEN (IFV.IMPFEDALQSAIPRE)
                                         WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'SIMPLES') THEN (IFS.IMPFEDALQSAIPRE)
                                         ELSE (IFG.IMPFEDALQSAIPRE)
                                    END)
                              ELSE (IF.IMPFEDALQSAIPRE)
                         END
        FROM      PRODUTO                     P
       INNER JOIN TRANSACAO                   T     ON (T.LOJCOD = P_CODIGO_DA_LOJA
                                                   AND  T.TRNDAT BETWEEN P_DATA_INICIAL AND P_DATA_FINAL)
       INNER JOIN IMPOSTOS_FEDERAIS_PRODUTO   IFP   ON (P.PROCOD = IFP.PROCOD)
       INNER JOIN IMPOSTOS_FEDERAIS           IF    ON (IF.IMPFEDSIM = IFP.IMPFEDSIM
                                                   AND  IF.IMPFEDTIP = 'P')
       INNER JOIN IMPOSTOS_FEDERAIS_GERAL     IFG   ON (IF.IMPFEDGERALID = IFG.IMPFEDGERALID)
       INNER JOIN IMPOSTOS_FEDERAIS_ATACADO   IFA   ON (IF.IMPFEDATACADOID = IFA.IMPFEDATACADOID)
       INNER JOIN IMPOSTOS_FEDERAIS_VAREJO    IFV   ON (IF.IMPFEDVAREJOID = IFV.IMPFEDVAREJOID)
       INNER JOIN IMPOSTOS_FEDERAIS_SIMPLES   IFS   ON (IF.IMPFEDSIMPLESID = IFS.IMPFEDSIMPLESID)
        LEFT JOIN PESSOA_CLIENTE              PC    ON (PC.CLI_CODIGO = T.CLICOD)
       WHERE IV.LOJCOD = P_CODIGO_DA_LOJA
         AND IV.LOJCOD = T.LOJCOD
         AND IV.TRNDAT = T.TRNDAT
         AND IV.CXANUM = T.CXANUM
         AND IV.TRNSEQ = T.TRNSEQ
         AND IV.TRNDAT BETWEEN P_DATA_INICIAL AND P_DATA_FINAL
         AND P.PROCOD = IV.PROCOD
         AND (IV.ITVCSTPIS IS NULL
          OR  TRIM(IV.ITVCSTPIS) = '')
      ;

      UPDATE ITEM_VENDA IV
         SET ITVCSTCOFINS = CASE WHEN ((P_USA_ALIQ_ESPEC IS NOT NULL) AND (P_USA_ALIQ_ESPEC = TRUE))
                                 THEN (CASE 
                                            WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'ATACADO') THEN (IFA.IMPFEDSTSAIPRE)
                                            WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'VAREJO')  THEN (IFV.IMPFEDSTSAIPRE)
                                            WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'SIMPLES') THEN (IFS.IMPFEDSTSAIPRE)
                                            ELSE (IFG.IMPFEDSTSAIPRE)
                                       END)
                                 ELSE (IF.IMPFEDSTSAIPRE)
                            END
           , ITVALQCOFINS = CASE WHEN ((P_USA_ALIQ_ESPEC IS NOT NULL) AND (P_USA_ALIQ_ESPEC = TRUE))
                                 THEN (CASE 
                                            WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'ATACADO') THEN (IFA.IMPFEDALQSAIPRE)
                                            WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'VAREJO')  THEN (IFV.IMPFEDALQSAIPRE)
                                            WHEN (COALESCE(PC.CLI_TIPO_ALICOTAS_ESPEC, 'GERAL') = 'SIMPLES') THEN (IFS.IMPFEDALQSAIPRE)
                                            ELSE (IFG.IMPFEDALQSAIPRE)
                                       END)
                                 ELSE (IF.IMPFEDALQSAIPRE)
                            END
        FROM      PRODUTO                     P
       INNER JOIN TRANSACAO                   T     ON (T.LOJCOD = P_CODIGO_DA_LOJA
                                                   AND  T.TRNDAT BETWEEN P_DATA_INICIAL AND P_DATA_FINAL)
       INNER JOIN IMPOSTOS_FEDERAIS_PRODUTO   IFP   ON (P.PROCOD = IFP.PROCOD)
       INNER JOIN IMPOSTOS_FEDERAIS           IF    ON (IF.IMPFEDSIM = IFP.IMPFEDSIM
                                                   AND  IF.IMPFEDTIP = 'C')
       INNER JOIN IMPOSTOS_FEDERAIS_GERAL     IFG   ON (IF.IMPFEDGERALID = IFG.IMPFEDGERALID)
       INNER JOIN IMPOSTOS_FEDERAIS_ATACADO   IFA   ON (IF.IMPFEDATACADOID = IFA.IMPFEDATACADOID)
       INNER JOIN IMPOSTOS_FEDERAIS_VAREJO    IFV   ON (IF.IMPFEDVAREJOID = IFV.IMPFEDVAREJOID)
       INNER JOIN IMPOSTOS_FEDERAIS_SIMPLES   IFS   ON (IF.IMPFEDSIMPLESID = IFS.IMPFEDSIMPLESID)
        LEFT JOIN PESSOA_CLIENTE              PC    ON (PC.CLI_CODIGO = T.CLICOD)
       WHERE IV.LOJCOD = P_CODIGO_DA_LOJA
         AND IV.LOJCOD = T.LOJCOD
         AND IV.TRNDAT = T.TRNDAT
         AND IV.CXANUM = T.CXANUM
         AND IV.TRNSEQ = T.TRNSEQ
         AND IV.TRNDAT BETWEEN P_DATA_INICIAL AND P_DATA_FINAL
         AND P.PROCOD = IV.PROCOD
         AND (IV.ITVCSTCOFINS IS NULL
          OR  TRIM(IV.ITVCSTCOFINS) = '')
      ;
    END IF;

    UPDATE ITEM_VENDA ITV
       SET ITVNATUREZA = P.NATCODIGO
      FROM PRODUTO P
     WHERE ITV.LOJCOD = P_CODIGO_DA_LOJA
       AND ITV.TRNDAT BETWEEN P_DATA_INICIAL AND P_DATA_FINAL
       AND P.PROCOD = ITV.PROCOD
       AND ((ITV.ITVNATUREZA IS NULL)
        OR  (TRIM(ITV.ITVNATUREZA) = ''))
       AND ((ITV.ITVCSTPIS IN ('02', '03', '04', '05', '06', '07', '08', '09'))
        OR  (ITV.ITVCSTCOFINS IN ('02', '03', '04', '05', '06', '07', '08', '09')))
    ;
  END IF;
END;
$$ LANGUAGE PLPGSQL;
