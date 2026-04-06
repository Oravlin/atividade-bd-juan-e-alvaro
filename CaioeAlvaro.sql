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
	A. int pois é um número e não tem tamanho definido
	B. varchar porque é um texto, e diferente do char que obriga a preencher todas as caracteres disponiveis.
 
 7. o nome deve ser unique pois não é necessário existir duas categorias de mesmo nome.
 8. seria possível a inserção de duas categorias de mesmo nome no sistema, causando conflitos.
 9. sem primary key, não seria possível identificar o item na tabela
*/

-- etapa 3

alter table tbproduto add FKcategoria int not null;
alter table tbproduto add constraint FkcCategoria foreign key (FKcategoria) references tbcategoria (id_categoria) on delete restrict;

/* 
10) usamos o protocolo de exclusão RESTRICT, porque esse método bloqueia a exclusão de registros que possuem relacionamento
11) deve-se usar quando é necessário apagar tudo relacionado à tabela pai
12) quando for necessário a restrição de exclusão ao possuir relacionamento à tabelas filhas
13) ao usar SET NULL os dados apagados se tornarão NULL, ou seja, será uma substituição
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

