--FUNCAO PARA REMOVER SEQUENCES
  create or replace function remove_sequence() returns void language 'plpgsql' as 
 $$
 declare
	nomeDaSequence pg_class.relname%TYPE;
	crSequences CURSOR FOR SELECT c.relname FROM pg_class c WHERE c.relkind = 'S';
 begin

	OPEN crSequences;
	LOOP
		FETCH crSequences INTO nomeDaSequence;
		EXIT WHEN NOT FOUND;
		IF UPPER(nomeDaSequence) <> 'SQ_FIDELIZACAO_NUMERO' AND
		   UPPER(nomeDaSequence) <> 'SQ_NSU' AND
		   UPPER(nomeDaSequence) <> 'SQ_NSU_GARANTIA' AND
		   UPPER(nomeDaSequence) <> 'SQ_NUMERO_CARTAO' AND
		   UPPER(nomeDaSequence) <> 'SQ_ALIQUOTA_ICMS' AND
		   UPPER(nomeDaSequence) <> 'ASSISTENTE_COMPRA_ACA_ID_SEQ' AND
		   UPPER(nomeDaSequence) <> 'ASSISTENTE_COMPRA_ITEM_ACI_ID_SEQ'AND
		   UPPER(nomeDaSequence) <> 'ASSISTENTE_COMPRA_PERFORMANCE_ACP_ID_SEQ' AND
		   UPPER(nomeDaSequence) <> 'ESTATISTICA_PENDENTE_EPT_ID_SEQ' AND
		   UPPER(nomeDaSequence) <> 'ESTATISTICA_PRODUTO_COMPRA_EPC_ID_SEQ' AND
		   UPPER(nomeDaSequence) <> 'ESTATISTICA_PRODUTO_MOVIMENTACAO_EPM_ID_SEQ' AND
		   UPPER(nomeDaSequence) <> 'ESTATISTICA_PRODUTO_VENDA_EPV_ID_SEQ'
		THEN
			execute 'DROP SEQUENCE IF EXISTS ' || UPPER(nomeDaSequence); 
		ELSE
			RAISE NOTICE 'Sequences não será excluída : %', UPPER(nomeDaSequence);
			
		END IF;
		
	END LOOP;
	CLOSE crSequences;
 
 end;
 $$