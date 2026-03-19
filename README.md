# Sistema-Gestão-Biblioteca 📚📖⚙️

![MySQL](https://img.shields.io/badge/mysql-%2300f.svg?style=for-the-badge&logo=mysql&logoColor=white)
![Status](https://img.shields.io/badge/Status-Conclu%C3%ADdo-brightgreen?style=for-the-badge)

**Banco de Dados MySQL de Alta Integridade com Automação Procedural e Business Intelligence.**

Repositório contendo a arquitetura de banco de dados relacional para o gerenciamento de acervos literários, usuários e controle rigoroso de circulação de exemplares. O projeto foca na implementação de **regras de negócio diretamente na camada de dados**, garantindo consistência e automação total dos processos.

##  Especificações Técnicas
* **Engine:** MySQL 8.0+
* **Modelagem:** Estrutura normalizada (3NF) preparada para suporte a múltiplos exemplares e rastreabilidade total de movimentações.
* **Objetos:** Tabelas, Constraints (FKs, Unicidade e Checks), Triggers de automação e Stored Procedures.

##  Funcionalidades Implementadas

### 1. Gestão Automática de Acervo (Triggers)
* **Controle de Estoque Real-time:** O campo `quant_disponivel` é atualizado automaticamente via gatilhos (`AFTER INSERT` e `BEFORE DELETE`), impedindo o empréstimo de livros sem estoque físico.
* **Validação de Avaliações:** Uma regra de integridade garante que apenas usuários que efetivamente concluíram um empréstimo possam registrar notas ou comentários para a obra.

### 2. Fluxo de Multas e Histórico
* **Cálculo de Atraso:** Ao encerrar um empréstimo, o sistema calcula via Trigger (`DATEDIFF`) a diferença entre a data atual e a prevista, gerando automaticamente um registro na tabela de `multas` com o valor devido.
* **Auditoria Permanente:** Todos os movimentos são espelhados em uma tabela de `historico_emprestimos`, garantindo que nenhum dado de circulação seja perdido após a devolução.

### 3. Business Intelligence com Stored Procedures 
O sistema conta com a procedure `sp_fechamento_financeiro_mensal`, que permite ao gestor obter um relatório consolidado de faturamento com apenas um comando. O relatório inclui:
* Total de multas geradas no mês/ano selecionado.
* Montante total já arrecadado (**Pago**).
* Valores pendentes (**Em aberto**).
* Faturamento total previsto.

## 📂 Instruções de Uso

1.  **Definição (DDL):** Execute o script principal para criar o Schema, tabelas, constraints e gatilhos.
2.  **Manipulação (DML):** O script já inclui uma massa de dados de teste para validar as chaves estrangeiras e o funcionamento das Triggers.
3.  **Executar Relatório:** Para visualizar a inteligência financeira em ação, utilize o comando:
    ```sql
    CALL sp_fechamento_financeiro_mensal(3, 2026);
    ```
