# Sistema-Gestão-Biblioteca
Banco de Dados MySQL para gerenciamento de bibliotecas com foco em regras de negócio e integridade. Implementação de automações para controle de acervo, fluxo de empréstimos, cálculo de multas por atraso e arquitetura normalizada para rastreabilidade de exemplares e usuários. 📚📖⚙️

*Sistema-Gestao-Biblioteca*

Repositório contendo a arquitetura de banco de dados relacional para o gerenciamento de acervos literários, usuários e controle de circulação de exemplares. O projeto foca em integridade referencial e automação de regras de negócio.

Especificações Técnicas
Engine: MySQL 8.0

Objetos: Tabelas normalizadas, Constraints (Chaves Estrangeiras e Unicidade), Triggers de Status.

Modelagem: Estrutura preparada para suporte a múltiplos exemplares, categorias de obras e histórico de movimentações.

Funcionalidades Implementadas
Gestão de Acervo: Cadastro detalhado de obras, autores e editoras com controle de disponibilidade por exemplar.

Controle de Empréstimos: Sistema de registro de datas de saída e previsão de entrega, garantindo a rastreabilidade do item.

Automação de Status: Gatilhos configurados para atualizar automaticamente a disponibilidade do livro (Disponível/Emprestado) no momento da transação.

Integridade de Usuários: Validação de cadastros e vínculos de empréstimos ativos para evitar inconsistências no banco de dados.

Instruções de Uso:
- Certifique-se de que o ambiente MySQL esteja configurado corretamente.
- Execute o script de definição de dados (DDL) para criar o Schema e a estrutura de tabelas.
- Utilize o script de manipulação de dados (DML) para popular o banco com registros iniciais de teste e validar as chaves estrangeiras.
