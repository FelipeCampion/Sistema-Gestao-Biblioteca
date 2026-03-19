create database Sistema_Biblioteca
character set utf8mb4 
collate utf8mb4_0900_ai_ci;

use Sistema_Biblioteca;

-- Criação de tabelas

-- Criação da tabela de usuários
create table usuarios(
id_usuario int auto_increment primary key,
nome varchar(100) not null,
email varchar(100) unique not null,
data_cadastro timestamp default current_timestamp
);

-- Criação da tabela de livros
create table livros(
id_livro int auto_increment primary key,
titulo varchar(200) not null,
isbn varchar(50) unique,
ano_publicacao int,
quant_disponivel int default 1
);

-- Criação da tabela de autores
create table autores(
id_autor int auto_increment primary key,
nome_autor varchar(100) not null,
nacionalidade varchar(50) null default 'Desconhecida'
);

-- Criação da tabela relacional para Autores x Livros
create table livro_autor(
primary key (id_livro, id_autor),
id_livro int,
id_autor int
);

-- Criação da tabela de emprestimos
create table emprestimos(
id_emprestimo int auto_increment primary key,
id_livro int,
id_usuario int,
data_emprestimo timestamp default current_timestamp,
data_devolucao_prevista date not null,
status enum('Ativo', 'Devolvido', 'Atrasado') default 'Ativo'
);

-- Criação da tabela de registro do histórico de emprestimos
create table historico_emprestimos(
id_historico int auto_increment primary key,
id_livro int,
id_usuario int,
data_emprestimo date not null,
status enum('Ativo', 'Devolvido', 'Atrasado') default 'Ativo'
);

-- Criação da tabela de registro de multas
create table multas(
id_multa int auto_increment primary key,
id_usuario int,
id_livro int,
valor_total decimal(10,2) not null,
data_geracao timestamp default current_timestamp,
dias_atraso int,
status_pagamento enum('Pendente', 'Pago') not null default 'Pendente'
);

-- Criação da tabela de registro de avaliações de usuários
create table avaliacoes(
id_avaliacao int auto_increment primary key,
id_livro int not null,
id_usuario int not null,
nota int not null,
comentario text,
data_avaliacao timestamp default current_timestamp
);

-- Criação das Foreign Keys (Pontes de ligação)

Alter table livro_autor
add foreign key (id_livro) references livros (id_livro) on delete cascade,
add foreign key (id_autor) references autores (id_autor) on delete cascade;

alter table emprestimos
add foreign key (id_livro) references livros (id_livro),
add foreign key (id_usuario) references usuarios (id_usuario);

alter table historico_emprestimos
add constraint id_livro_h foreign key (id_livro) references livros (id_livro) on delete set null,
add constraint id_usuario_h foreign key (id_usuario) references usuarios (id_usuario) on delete set null;

alter table multas
add constraint fk_mult_usu foreign key (id_usuario) references usuarios (id_usuario),
add constraint fk_mult_livro foreign key (id_livro) references livros (id_livro);

alter table avaliacoes
add constraint fk_ava_usu foreign key (id_usuario) references usuarios (id_usuario),
add constraint fk_ava_livro foreign key (id_livro) references livros (id_livro),
add constraint chk_nota check (nota >= 1 and nota <= 5);

-- Criação do monitoramento de estoque vazio
delimiter //

create trigger trg_monitorar_estoque_vazio
before insert on emprestimos
for each row
begin
declare v_estoque int;
select quant_disponivel into v_estoque
from livros
where id_livro = new.id_livro;

if v_estoque <= 0 then
signal sqlstate '45000'
set message_text =  'Livro indisponível em estoque';

    end if;

end //
delimiter ;

-- Criação do gatilho de Upload na quantidade de estoque
delimiter //
create trigger trg_monitorar_emprestimos
after insert on emprestimos
for each row
begin 
update livros set quant_disponivel = quant_disponivel - 1 where id_livro = new.id_livro;
end //
delimiter ;

-- Criação do gatilho de cauculo de multas para emprestimos fora do prazo de devolução
delimiter //

create trigger trg_calculo_multa
before delete on emprestimos
for each row
begin

declare v_dias_atraso int;
declare v_dia_atraso decimal(10,2) default 2.00;

set v_dias_atraso = datediff(curdate(), old.data_devolucao_prevista);

if v_dias_atraso > 0 then
insert into multas (id_usuario, id_livro, valor_total, dias_atraso)
values (old.id_usuario, old.id_livro, (v_dia_atraso * v_dias_atraso),  v_dias_atraso);
end if;

insert into historico_emprestimos (id_livro, id_usuario, data_emprestimo, status)
values (old.id_livro, old.id_usuario, old.data_emprestimo, if (v_dias_atraso > 0, 'Atrasado', 'Devolvido'));

update livros set quant_disponivel = quant_disponivel + 1
where id_livro = old.id_livro;

end //
delimiter ;

-- Criação do gatilho de validação de possibilidade de avaliação dos usuários
delimiter //

create trigger trg_validar_avaliacao
before insert on avaliacoes
for each row
begin
declare v_leu_livro int;

select count(*) into v_leu_livro 
from historico_emprestimos 
where id_usuario = new.id_usuario and id_livro = new.id_livro;

if v_leu_livro = 0 then
signal sqlstate '45000'
set message_text = 'Erro: O usuário só pode avaliar livros que já tomou emprestado.';
end if;

end //
delimiter ;

-- Ligação de Livros x Autores de ambas as tabelas respectivamante as suas colunas da tabela livro_autor
select livros.titulo, autores.nome_autor 
from livros 
join livro_autor on livros.id_livro = livro_autor.id_livro
join autores on livro_autor.id_autor = autores.id_autor;
