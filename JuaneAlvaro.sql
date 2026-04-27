CREATE DATABASE IF NOT EXISTS empresa
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;
  
USE empresa;

CREATE TABLE if not exists tbcliente(
id_cliente INT AUTO_INCREMENT PRIMARY KEY,
nome_cliente VARCHAR(100) NOT NULL,
email_cliente VARCHAR(100) UNIQUE,
ativo_cliente TINYINT NOT NULL DEFAULT 1,
data_cadastro_cliente DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE if not exists tbproduto (
id_produto INT AUTO_INCREMENT PRIMARY KEY,
nome_produto VARCHAR(100) NOT NULL,
preco_produto DECIMAL(10,2) CHECK (preco_produto > 0),
qtd_estoque_produto INT DEFAULT 1,
data_cadastro_produto DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

/*
1. Decimal
2. Pois o FLOAT pode causar imprecisões no valor, que não é tolerável para valores monetários.
3. Pode resultar em erros de cálculo, inconsistências em auditorias e até fraudes não intencionais.
4. O estoque não começa com um valor padrão
5. É obrigatório no uso profissional, pois oferece Transações, Foreign Key, Row-level locking, crash recovery e MVCC
*/ 

-- etapa 2

create table if not exists tbcategoria(
	id_categoria int auto_increment primary key, 
    nome_categoria varchar(100) unique 
) engine=InnoDB;

/* 6. 
	A. int pois é um número inteiro e não tem tamanho definido
	B. varchar porque é um texto, e diferente do char que obriga a preencher todas as caracteres disponiveis.
 
 7. o nome deve ser unique pois não é necessário existir duas categorias de mesmo nome.
 8. seria possível a inserção de duas categorias de mesmo nome no sistema, causando conflitos.
 9. sem primary key, não seria possível identificar o item na tabela e não fazer relacionamentos
*/

-- etapa 3

alter table tbproduto add FKcategoria int not null;
alter table tbproduto add constraint FkcCategoria foreign key (FKcategoria) references tbcategoria (id_categoria) on delete restrict;

/* 
10) usamos o protocolo de exclusão RESTRICT, porque esse método bloqueia a exclusão de registros que possuem relacionamento
11) deve-se usar quando é necessário apagar tudo relacionado à tabela pai
12) quando for necessário a restrição de exclusão ao possuir relacionamento à tabelas filhas
13) ao usar SET NULL os dados apagados se tornarão NULL, ou seja, será uma substituição de dados
14) regra no banco se refere a como o banco irá se portar com os dados inseridos nele, regra na aplicação
refere-se ao comportamento de dados que seram enviados para o banco
 */
 
 -- criando tabela pedido
create table if not exists tbpedido(
	id_pedido int primary key auto_increment,
    data_pedido timestamp default current_timestamp,
    valor_pedido decimal(8,2) check (valor_pedido > 0),
    id_cliente_fk int
)engine=InnoDB;
alter table tbpedido add constraint FkCliente foreign key (id_cliente_fk) references tbcliente (id_cliente) on delete cascade;

-- exercicios evoluindo o sistema
create table if not exists tbpedido_item(
	id_item int primary key,
	id_pedido int,
    id_produto int,
    qtd_pedido int check (qtd_pedido > 0),
    preco_unitario decimal(8,2)
)engine=InnoDB;
alter table tbpedido_item add constraint Fkpedido foreign key (id_pedido) references tbpedido (id_pedido) on delete cascade;
alter table tbpedido_item add constraint Fkproduto foreign key (id_produto) references tbproduto (id_produto) on delete restrict;


-- teste de integridade
insert into tbcliente (nome_cliente, email_cliente) values ("Enildo Candida Santos", "enildoprofessor@email.com");
insert into tbcliente (nome_cliente, email_cliente) values ("Nivia Professora Basilides", "nivia@email.com");
insert into tbcliente (nome_cliente, email_cliente) values ("Felipe Mendes Dahmer", "dahmerfelipe@email.com");

-- criando categorias
insert into tbcategoria (nome_categoria) values ("comidas");
insert into tbcategoria (nome_categoria) values ("roupas");
insert into tbcategoria (nome_categoria) values ("brinquedos");


-- os produtos são para fazer pedidos válidos
insert into tbproduto (nome_produto, preco_produto, qtd_estoque_produto, FKcategoria) values ("Maçã", 3.67, 900, 1);
insert into tbproduto (nome_produto, preco_produto, qtd_estoque_produto, FKcategoria) values ("Banana", 5, 9000, 1);
insert into tbproduto (nome_produto, preco_produto, qtd_estoque_produto, FKcategoria) values ("Carta Pokémon", 25.63, 35, 3);
insert into tbproduto (nome_produto, preco_produto, qtd_estoque_produto, FKcategoria) values ("Camiseta", 67.69, 10, 2);

insert into tbpedido (valor_pedido, id_cliente_fk) values (44444, 1);
insert into tbpedido (valor_pedido, id_cliente_fk) values (7667, 3);
insert into tbpedido (valor_pedido, id_cliente_fk) values (3.99, 1);
insert into tbpedido (valor_pedido, id_cliente_fk) values (780.87, 2);

insert into tbpedido_item (id_pedido, id_produto, qtd_pedido, preco_unitario, id_item) values (1, 1, 2, 3.67, 1);
insert into tbpedido_item (id_pedido, id_produto, qtd_pedido, preco_unitario, id_item) values (4, 3, 99, 25.63, 2);
insert into tbpedido_item (id_pedido, id_produto, qtd_pedido, preco_unitario, id_item) values (3, 2, 2, 5, 3);
insert into tbpedido_item (id_pedido, id_produto, qtd_pedido, preco_unitario, id_item) values (2, 4, 5, 67.69, 4);

-- inserindo pedido com cliente inexistente
insert into tbpedido (valor_pedido, id_cliente_fk) values (780.87, 10);
-- Explicação: a constraint que faz o relacionamento falha porque não há um cliente que fez esse pedido, e o grau de relacionamento exige que exista um cliente para cada pedido

-- teste de cascade
delete from tbcliente where id_cliente = 1;
select * from tbcliente;
select * from tbpedido;
select * from tbproduto;
select * from tbpedido_item;

-- explicação do comportamento: quando se deleta um cliente e há pedidos registrado no nome dele, será apagado tudo referente


-- evolução real
alter table tbpedido add column (desconto_pedido decimal(5,2) check (desconto_pedido >= 0 and desconto_pedido <= 100));
insert into tbpedido_item (id_pedido, id_produto, qtd_pedido, preco_unitario, id_item, desconto_pedido) values (2, 4, 5, 67.69, 4, 101);

-- etapa mercado
-- o delete on cascade no pedido item é necessário caso um pedido seja apagado. Porque não há mais necessidade de ter um pedido_item
-- o restrict impede que os produtos sejam apagados caso um pedido referenciando-os for apagado.