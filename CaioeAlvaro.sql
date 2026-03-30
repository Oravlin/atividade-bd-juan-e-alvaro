CREATE DATABASE IF NOT EXISTS empresa
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;
  
USE empresa;

CREATE TABLE cliente(
id_cliente INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
email VARCHAR(100) UNIQUE,
ativo TINYINT NOT NULL DEFAULT 1,
data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE produto (
id_produto INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
preco DECIMAL(10,2) CHECK (preco > 0),
qtd_estoque INT DEFAULT 1,
data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

/*
1. Decimal
2. Pois o FLOAT pode causar imprecisões no valor, que não é tolerável para valores monetários.
3. Pode resultar em erros de cálculo, inconsistências em auditorias e até fraudes não intencionais.
4. O estoque não começa com um valor padrão
5. É obrigatório no uso profissional, pois oferece Transações, Foreign Key, Row-level locking, crash recovery e MVCC
*/ 

-- etapa 2

create table categoria(
	id int auto_increment primary key, 
    nome varchar(100) unique 
) engine=InnoDB;

/* 6. 
	A. int pois é um número e não tem tamanho definido
	B. varchar porque é um texto, e diferente do char que obriga a preencher todas as caracteres disponiveis.
 
 7. o nome deve ser unique pois não é necessário existir duas categorias de mesmo nome.
 8. seria possível a inserção de duas categorias de mesmo nome no sistema, causando conflitos.
 9. sem primary key, não seria possível identificar o item na tabela
*/

-- etapa 3

alter table produto add FKcategoria int not null;
alter table produto add constraint FkcCategoria foreign key (FKcategoria) references categoria (id) on delete restrict;

/* 
10) usamos o protocolo de exclusão RESTRICT, porque esse método bloqueia a exclusão de registros que possuem relacionamento
11) deve-se usar quando é necessário apagar tudo relacionado à tabela pai
12) quando for necessário a restrição de exclusão ao possuir relacionamento à tabelas filhas
13) ao usar SET NULL os dados apagados se tornarão NULL, ou seja, será uma substituição
14) regra no banco se refere 
 */