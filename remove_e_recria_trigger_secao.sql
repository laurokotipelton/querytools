DROP TRIGGER trigger_produto_update_secao ON public.produto;

CREATE TRIGGER trigger_produto_update_secao
  AFTER UPDATE
  ON public.produto
  FOR EACH ROW
  WHEN ((old.seccod IS DISTINCT FROM new.seccod))
  EXECUTE PROCEDURE public.bi_reprocessa_metas_secoes();