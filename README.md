Sistema-Gestão-Biblioteca
Banco de Dados MySQL de Alta Integridade com Automação Procedural e BI. 📊📚

Este repositório contém uma arquitetura robusta de banco de dados relacional voltada para o gerenciamento de acervos, usuários e fluxos financeiros de uma biblioteca. O projeto se destaca pela implementação de regras de negócio diretamente na camada de dados, garantindo consistência e automação total.

Diferenciais Técnicos
Engine: MySQL 8.0+

Arquitetura: Normalização avançada (3NF) para rastreabilidade total.

Camada de Inteligência: Uso de Stored Procedures para relatórios financeiros e Triggers para automação de estoque e multas.

Integridade Proativa: Travas de segurança que impedem inconsistências (ex: avaliar livros não lidos ou emprestar itens sem estoque).

Funcionalidades e Automações
1. Gestão Inteligente de Acervo (Triggers)
Controle de Estoque Real-time: O campo quant_disponivel é atualizado automaticamente via gatilhos (AFTER INSERT / BEFORE DELETE), impedindo empréstimos de itens indisponíveis.

Validação de Avaliações: Uma regra de integridade garante que apenas usuários que efetivamente concluíram um empréstimo possam registrar uma nota/comentário para a obra.

2. Fluxo de Multas e Histórico
Cálculo Automático de Atraso: Ao encerrar um empréstimo, o sistema calcula via Trigger a diferença entre a data atual e a data prevista, gerando automaticamente um registro na tabela de multas com o valor devido.

Auditoria Permanente: Todos os movimentos são espelhados em uma tabela de historico_emprestimos para consultas futuras de comportamento do usuário.

3. Business Intelligence (Stored Procedure) 
Fechamento Financeiro Mensal: Implementação da procedure sp_fechamento_financeiro_mensal.

Com apenas um comando, o gestor obtém um relatório consolidado contendo:

Total de multas geradas no mês.

Montante já arrecadado (Pago).

Valores pendentes em aberto.

Previsão de faturamento total.

📂 Instruções de Uso
Instalação: Execute o script SQL completo para criar o Schema, as tabelas e todos os gatilhos/procedimentos.
Testes: O script já inclui uma massa de dados (DML) para validar todas as triggers.
Executar Relatório: Para visualizar a inteligência financeira em ação, utilize o comando:
call sp_fechamento_financeiro_mensal(3, 2026);
