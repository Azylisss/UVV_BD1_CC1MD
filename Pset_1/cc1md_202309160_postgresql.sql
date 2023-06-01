-- SQL Script solicitado pelo Professor Abrantes  
-- Nome do aluno: Sandro Ricardo Magalhães Filho--
-- Matrícula: 202309160                    --

-- Deletando o Banco de dados UVV caso Exista --

DROP DATABASE IF EXISTS uvv;

-- Deletando meu Usuario caso exista --

DROP USER IF EXISTS sandro;

-- Criando o usuário com o meu nome conforme solicitado --

CREATE USER sandro
   CREATEDB
   LOGIN;

-- Criando o Banco de Dados --

CREATE DATABASE uvv
       OWNER sandro
       TEMPLATE = template0
       ENCODING = UTF8
       LC_COLLATE = 'pt_BR.UTF-8'
       LC_CTYPE = 'pt_BR.UTF-8';
-- Deletando o esquema (SCHEMA) caso ele já exista --

DROP SCHEMA IF EXISTS lojas;

-- Criando o esquema (SCHEMA) --

CREATE SCHEMA lojas
AUTHORIZATION sandro;

-- Alterando o SEARCH_PATH  para criacao das tabelas --

SET SEARCH_PATH TO lojas, public;

-- Alterando o SEARCH_PATH  do Postgres para o usuario sandro assim incluindo o esquema lojas na frente em prioridade de "public" e "user" --

ALTER USER sandro
SET SEARCH_PATH TO lojas, public;

-- Criando a tabela "lojas" --

CREATE TABLE lojas (
                loja_id 		NUMERIC(38) 	NOT NULL,
                nome 			VARCHAR(255) 	NOT NULL,
                endereco_web 		VARCHAR(100)		,
                endereco_fisico 	VARCHAR(512)		,
                latitude 		NUMERIC			,
                longitude 		NUMERIC			,
                logo 			BYTEA			,
                logo_mine_type 		VARCHAR(512)		,
                logo_arquivo 		VARCHAR(512)		,
                logo_charset 		VARCHAR(512)		,
                logo_ultima_atualizacao DATE	,
                CONSTRAINT loja_pk PRIMARY KEY (loja_id));

-- fazendo os comentarios atributos na tabela lojas --
 
COMMENT ON TABLE lojas 				
IS 'tabela representando as lojas na uvv';
COMMENT ON COLUMN lojas.loja_id 		
IS ' key primaria da tabela loja representando o id das lojas.';
COMMENT ON COLUMN lojas.nome 			
IS 'nome das lojas  na tabela.';
COMMENT ON COLUMN lojas.endereco_web 		
IS 'atributo da tabela loja que representa o endereço web de uma loja.';
COMMENT ON COLUMN lojas.endereco_fisico 	
IS 'O atributo presente na tabela que representa o endereço fisico da loja.';
COMMENT ON COLUMN lojas.latitude 		
IS 'É o atributo na tabela que representa a latitude da loja.';
COMMENT ON COLUMN lojas.longitude 		
IS 'Atributo da tabela logica que representa a longitude da loja.';
COMMENT ON COLUMN lojas.logo 			
IS 'Atributo que representa a imagem do ''logo da loja.';
COMMENT ON COLUMN lojas.logo_mine_type 		
IS 'MIME type da logo da loja cadastrada.';
COMMENT ON COLUMN lojas.logo_arquivo 		
IS 'Arquivo da logo da loja cadastrada.';
COMMENT ON COLUMN lojas.logo_charset 		
IS 'Charset da logo da loja cadastrada.';
COMMENT ON COLUMN lojas.logo_ultima_atualizacao 
IS 'Última atualização da logo da loja cadastrada.';

-- Criando a verificação para o endereço, exigindo que a loja tenha pelo menos um endereço associado a ela. --

ALTER TABLE lojas 
ADD CONSTRAINT endereco_check 
CHECK ((endereco_web IS NULL OR endereco_fisico IS NOT NULL) OR
       (endereco_web IS NOT NULL OR endereco_fisico IS NULL)
);

-- Criando a verificação para não permitir que a latitude ultrapasse 90 graus e que ela seja negativa.--

ALTER TABLE lojas
ADD CONSTRAINT latitude_check
CHECK (latitude >= -90 AND
       latitude <= 90
);

-- Criando a verificação para não permitir que a longitude ultrapasse 180 graus e que ela não seja menor que -180 .--

ALTER TABLE lojas
ADD CONSTRAINT longitude_check
CHECK (longitude >= -180 AND
       longitude <= 180
);

-- Criando a verificação que permite apenas que o atributo "logo_ultima_atualizacao" seja uma data passada ou a data atual, nunca uma data que ainda não ocorreu. --

ALTER TABLE lojas
ADD CONSTRAINT data_hora_lojas_check
CHECK (logo_ultima_atualizacao <= current_timestamp);

-- Criando a tabela produtos --

CREATE TABLE produtos (
    produto_id       NUMERIC(38)	NOT NULL,
    nome             VARCHAR(255) 	NOT NULL,
    preco_unitario   NUMERIC(10,2)		,
    detalhes         BYTEA			,
    imagem           BYTEA			,
    imagem_mime_type VARCHAR(512)		,
    imagem_arquivo   VARCHAR(512)		,
    imagem_charset   VARCHAR(512)		,
    imagem_ultima_atualizacao DATE,
    CONSTRAINT produto_pk PRIMARY KEY (produto_id));


--Faz os comentários das colunas da tabela Produtos--   
COMMENT ON TABLE lojas.produtos                            IS 'Tabela referente aos produtos das lojas cadastradas';
COMMENT ON COLUMN lojas.produtos.produto_id                IS 'ID dos produtos das lojas cadastradas';
COMMENT ON COLUMN lojas.produtos.nome                      IS 'Nome dos produtos das lojas cadastradas';
COMMENT ON COLUMN lojas.produtos.preco_unitario            IS 'Preço unitário dos produtos';
COMMENT ON COLUMN lojas.produtos.detalhes                  IS 'Detalhes do produto cadastrado';
COMMENT ON COLUMN lojas.produtos.imagem                    IS 'Imagem dos produtos cadastrados';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type          IS 'MIME type da imagem dos produtos cadastrados';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo            IS 'Arquivo da imagem dos produtos cadastrados';
COMMENT ON COLUMN lojas.produtos.imagem_charset            IS 'Charset da imagem dos produtos cadastrados';
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS 'Última atualização da imagem do produto';




-- cria uma verificação para que  "imagem_ultima_atualizacao" seja uma data passada ou a data atual --

ALTER TABLE produtos
ADD CONSTRAINT data_hora_produtos_check
CHECK (imagem_ultima_atualizacao <= current_timestamp);

-- Criando a tabela "estoques". --

CREATE TABLE lojas.estoques (
    estoque_id SERIAL     PRIMARY KEY,
    loja_id               INT NOT NULL,
    produto_id            INT NOT NULL,
    quantidade            NUMERIC(38) NOT NULL,
    CONSTRAINT   fk_estoques_lojas      FOREIGN KEY (loja_id)      REFERENCES lojas.lojas (loja_id),
    CONSTRAINT   fk_estoques_produtos   FOREIGN KEY (produto_id)   REFERENCES lojas.produtos (produto_id));

-- Comentando sobre os atributos e a tabela "estoque". --

--Faz os comentários das colunas da tabela Estoques--
COMMENT ON COLUMN   lojas.estoques.estoque_id   IS 'ID do estoque da loja cadastrada';
COMMENT ON COLUMN   lojas.estoques.loja_id      IS 'ID da loja associada ao estoque';
COMMENT ON COLUMN   lojas.estoques.produto_id   IS 'ID do produto associado ao estoque';
COMMENT ON COLUMN   lojas.estoques.quantidade   IS 'Quantidade em estoque do produto';


-- Criando a constante de verificação que impede que a quantidade de itens seja menor que zero. --

ALTER TABLE estoques  
ALTER TABLE lojas.estoques ADD CONSTRAINT 
CHECK (quantidade >= 0);

-- Criando a tabela "clientes" --

CREATE TABLE clientes (
    client_id NUMERIC(38) 	NOT NULL,
    email     VARCHAR(255) 	NOT NULL,
    nome      VARCHAR(255) 	NOT NULL,
    telefone1 VARCHAR(20)		,
    telefone2 VARCHAR(20)		,	
    telefone3 VARCHAR(20)		,
    CONSTRAINT clientes_pk PRIMARY KEY (client_id));

-- Comentando nos atributos e na tabela "clientes" --

COMMENT ON TABLE clientes 
IS 'Tabela que representa os clientes e suas informações.';
COMMENT ON COLUMN clientes.client_id
IS 'Chave principal da tabela cliente que representa o id dos clientes.';
COMMENT ON COLUMN clientes.email     
IS 'Representa o email dos clientes.';
COMMENT ON COLUMN clientes.nome
IS 'Representa o nome do cliente.';
COMMENT ON COLUMN clientes.telefone1 
IS 'Representa o 1º telefone dos clientes.';
COMMENT ON COLUMN clientes.telefone2 
IS 'Representa o 2º Telefone dos clientes.';
COMMENT ON COLUMN clientes.telefone3 
IS 'Representa o 3º telefone do cliente.';

-- Criando a validação de email, verificando a presença do símbolo '@' antes de considerá-lo válido. --

ALTER TABLE clientes
ADD CONSTRAINT email_check
CHECK (email LIKE '%@%' AND 
       email LIKE '%.%' AND	
       email NOT LIKE '%@%@%'
);

-- Criando a tabela "envios" --

CREATE TABLE envios (
                envio_id 		NUMERIC(38)  NOT NULL,
                loja_id 		NUMERIC(38)  NOT NULL,
                client_id 		NUMERIC(38)  NOT NULL,
                endereco_entrega 	VARCHAR(512) NOT NULL,
                status 			VARCHAR(15)  NOT NULL,
                CONSTRAINT envios_pk PRIMARY KEY (envio_id));

--Faz os comentários das colunas da tabela Envios--
COMMENT ON COLUMN lojas.envios.envio_id            IS 'ID de envio do pedido';
COMMENT ON COLUMN lojas.envios.loja_id             IS 'ID da loja associada ao envio';
COMMENT ON COLUMN lojas.envios.cliente_id          IS 'ID do cliente associado ao envio';
COMMENT ON COLUMN lojas.envios.endereco_entrega    IS 'Endereço de entrega do pedido';
COMMENT ON COLUMN lojas.envios.status              IS 'Status do envio do pedido';




-- Criando a tabela "pedidos" --

CREATE TABLE pedidos (
    pedido_id 	NUMERIC(38) NOT NULL,
    data_hora 	TIMESTAMP   NOT NULL,
    client_id 	NUMERIC(38) NOT NULL,
    status 		VARCHAR(15) NOT NULL,
    loja_id 	NUMERIC(38) NOT NULL,
    CONSTRAINT pedidos_pk PRIMARY KEY (pedido_id));


-- Comentando nos atributos e na tabela "pedidos" --

COMMENT ON TABLE pedidos 		
IS 'Tabela que representa os pedidos';
COMMENT ON COLUMN pedidos.pedido_id 	
IS 'É a chave principal da tabela produto que representa o id dos pedidos.';
COMMENT ON COLUMN pedidos.data_hora 	
IS 'Hora que o pedido foi solicitado.';
COMMENT ON COLUMN pedidos.client_id 	
IS 'Chave principal da tabela cliente que representa o id dos clientes.';
COMMENT ON COLUMN pedidos.status 	
IS 'Representa o status do pedido em questão.';
COMMENT ON COLUMN pedidos.loja_id 	
IS 'Chave primaria da tabela loja, representando o id das lojas.';

-- Foi criada uma constante de validação para o atributo "status", a qual permite que aceite e receba exclusivamente os seguintes termos: CANCELADO, COMPLETO, ABERTO, PAGO, REEMBOLSADO e ENVIADO. --

ALTER TABLE pedidos 
ADD CONSTRAINT status_check 
CHECK  (status = 'CANCELADO'    OR 
	status = 'COMPLETO'     OR
	status = 'ABERTO'       OR
	status = 'PAGO'	        OR
	status = 'REEMBOLSADO'	OR
	status = 'ENVIADO');

-- Foi implementada uma validação que garante que o horário do pedido seja apenas a hora atual ou uma hora aproximada no futuro, evitando assim a inserção de um horário passado. --

ALTER TABLE pedidos
ADD CONSTRAINT data_hora_check
CHECK (data_hora >= current_timestamp);

-- Criando a tabela "pedido_itens". --

CREATE TABLE pedido_itens (
    produto_id NUMERIC(38) NOT NULL,
    pedido_id NUMERIC(38) NOT NULL,
    numero_da_linha NUMERIC(38) NOT NULL,
    preco_unitario NUMERIC(10,2) NOT NULL,
    quantidade NUMERIC(38) NOT NULL,
    envio_id NUMERIC(38),
    CONSTRAINT pedido_itens_pk PRIMARY KEY (produto_id, pedido_id));



--Faz os comentários das colunas da tabela Pedidos_Itens--
COMMENT ON COLUMN lojas.pedidos_itens.produto_id        IS 'ID do produto associado ao item do pedidos';
COMMENT ON COLUMN lojas.pedidos_itens.pedido_id         IS 'ID do pedido associado ao item do pedidos';
COMMENT ON COLUMN lojas.pedidos_itens.envio_id          IS 'ID do envio associado ao item do pedidos';
COMMENT ON COLUMN lojas.pedidos_itens.numero_da_linha   IS 'Número da linhaS do item dos pedidos';
COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario    IS 'Preço unitário do item do pedidos';
COMMENT ON COLUMN lojas.pedidos_itens.quantidade        IS 'Quantidade do item do pedidos;

--Essa alteração adiciona uma restrição que garante que o valor do campo "preco_unitario" não seja menor que zero.--
ALTER TABLE pedido_itens 
ADD CONSTRAINT preco_itens_check 
CHECK (preco_unitario > 0);

-- Alterando os as tabelas para o criador seja meu usuario --

ALTER TABLE clientes 	 OWNER TO sandro;
ALTER TABLE produtos 	 OWNER TO sandro;
ALTER TABLE lojas    	 OWNER TO sandro;
ALTER TABLE envios    	 OWNER TO sandro;
ALTER TABLE pedidos  	 OWNER TO sandro;
ALTER TABLE pedido_itens OWNER TO sandro;
ALTER TABLE estoques     OWNER TO sandro;

--Essa alteração altera o atributo "client_id" na tabela "pedidos" para que seja uma chave estrangeira (FK) referenciando a chave primária (PK) "client_id" na tabela "clientes".. --
 
ALTER TABLE pedidos 
ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (client_id)
REFERENCES clientes (client_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Alterando tambem o atributo "client_id" da tabela "envios" para que seja uma foreign key (FK) da chave primária (PK) "client_id" da tabela "clientes". --

ALTER TABLE envios 
ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (client_id)
REFERENCES clientes (client_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Essa alteração altera o atributo "produto_id" na tabela "estoques" para que seja uma chave estrangeira (FK) referenciando a chave primária (PK) "produto_id" na tabela "produtos".. --                          

ALTER TABLE estoques 
ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Mudando tambem o atributo "loja_id" da tabela "estoques" para que ele seja uma foreign key(FK) da chave primária(PK) "loja_id" da tabela "lojas". --                           

ALTER TABLE estoques 
ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Alterando o atributo "produto_id" da tabela "pedido_itens", tornando ela uma foreign key(FK) da chave primária(PK) "produto_id" da tabela "produtos". --  

ALTER TABLE pedido_itens 
ADD CONSTRAINT produtos_pedido_itens_fk
FOREIGN KEY (produto_id)
REFERENCES produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Alterando também o atributo "pedido_id" da tabela "pedido_itens", tornando-o uma foreign key (FK) da chave primária (PK) "pedido_id" da tabela "pedidos". --

ALTER TABLE pedido_itens 
ADD CONSTRAINT pedidos_pedido_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- alterand o atributo "loja_id" da tabela "pedidos", fazendo ela virar uma foreign key (FK) da chave primária (PK) "loja_id" da tabela "lojas". --

ALTER TABLE pedidos 
ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Mudando o "loja_id" da tabela "envios", para que ela vire uma foreign key (FK) da chave primária (PK) "loja_id" da tabela "lojas". --

ALTER TABLE envios 
ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Alterando o atributo "envio_id" da tabela "pedido_itens", para que ela se transforme na foreign key (FK) da chave primária (PK) "envio_id" da tabela "envios". --

ALTER TABLE pedido_itens 
ADD CONSTRAINT envios_pedido_itens_fk
FOREIGN KEY (envio_id)
REFERENCES envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Creditos: Sandro Ricardo Magalhães Filho --
-- Matricula: 202309160 --

