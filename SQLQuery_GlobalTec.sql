select cts.Numero as "Numero Processo", cts.NOME as "Nome Fornecedor",
cts.DataVencimento as "Data Vencimento", cts.DataProrrogacao as "Data Pagamento",
case when cts.DifData > 0 then cts.Valor - cts.Desconto else (
case when cts.DifData < 0 then cts.valor + cts.Acrescimo else cts.valor end) end as "Valor Liquido",
cts.ident as "Status Conta"
from
(select ca.Numero, p.NOME, ca.DataVencimento, ca.DataProrrogacao,
DATEDIFF(day,ca.DataProrrogacao,ca.DataVencimento) as DifData, ca.valor, ca.Acrescimo, ca.Desconto,
'Contas A Pagar' as ident
from Pessoas p inner join ContasAPagar ca on (p.CODIGO = ca.CodigoFornecedor)
union all
select cp.Numero, p.NOME, cp.DataVencimento, cp.DataPagamento,
DATEDIFF(day,cp.DataPagamento,cp.DataVencimento) as DifData, cp.valor, cp.Acrescimo, cp.Desconto,
'Contas Pagas' as ident
from Pessoas p inner join ContasPagas cp on (p.CODIGO = cp.CodigoFornecedor)) cts
order by cts.NOME