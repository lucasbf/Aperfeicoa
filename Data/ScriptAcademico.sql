USE master;

CREATE DATABASE Academico;
GO

USE Academico;

DROP TABLE IF EXISTS tb_historicos;			-- 1
DROP TABLE IF EXISTS tb_matriculas;			-- 2
DROP TABLE IF EXISTS tb_departamentos;		-- 3
DROP TABLE IF EXISTS tb_cursos_oferecidos;	-- 4
DROP TABLE IF EXISTS tb_cursos;				-- 5
DROP TABLE IF EXISTS tb_empregados;			-- 6
DROP TABLE IF EXISTS tb_grades_salarios;	-- 7

-- ==========================
-- tabela tb_grades_salarios
-- ==========================

CREATE TABLE tb_grades_salarios( 
id_grade      		INTEGER, 
limite_inferior		NUMERIC(7,2) CONSTRAINT nn_tb_grades_limite_inferior NOT NULL,
				      			 CONSTRAINT ck_tb_grades_limite_inferior CHECK (limite_inferior >= 0), 
limite_superior 	NUMERIC(7,2) CONSTRAINT nn_tb_grades_limite_superior NOT NULL, 
bonus      		 	FLOAT		 CONSTRAINT nn_tb_grades_bonus NOT NULL, 
								 CONSTRAINT ck_tb_grades_bonus CHECK (limite_inferior <= limite_superior),
fg_ativo			BIT,                               
CONSTRAINT pk_tb_grades_id_grade PRIMARY KEY(id_grade)
);

-- =================
-- tabela tb_cursos 
-- =================

CREATE TABLE tb_cursos( 
id_curso        	VARCHAR(6), 
ds_curso 			VARCHAR(60) CONSTRAINT nn_tb_cursos_ds_curso NOT NULL, 
categoria    		CHAR(3) 	CONSTRAINT nn_tb_cursos_categoria NOT NULL, 
                                -- GEN (general), para cursos introdut�rios
								-- DSG (design), para analise e projeto
								-- BLD (build), para desenvolvimento de aplicativos
								CONSTRAINT ck_tb_cursos_categoria CHECK(categoria IN ('GEN','BLD','DSG')), 								
duracao    			INTEGER 	CONSTRAINT nn_tb_cursos_duracao NOT NULL,				   	
fg_ativo			BIT, 				   					   
CONSTRAINT  ck_tb_cursos_id_curso CHECK (id_curso = UPPER(id_curso)),			           
CONSTRAINT pk_tb_cursos_id_curso PRIMARY KEY(id_curso)
);

SELECT *
FROM tb_cursos;

-- =====================
-- tabela tb_empregados
-- =====================

CREATE TABLE tb_empregados( 
id_empregado      	INTEGER 	CONSTRAINT ck_tb_emp_id_emp CHECK (id_empregado > 7000), 
nm_empregado      	VARCHAR(60) CONSTRAINT nn_tb_emp_nm_emp NOT NULL, 
iniciais_empregado  VARCHAR(5)  CONSTRAINT nn_tb_emp_iniciais NOT NULL, 
ds_cargo        	VARCHAR(40), 
id_gerente        	INTEGER 	CONSTRAINT fk_tb_emp_id_gerente REFERENCES tb_empregados, 
dt_nascimento      	DATE 		CONSTRAINT nn_tb_emp_dt_nascimento NOT NULL, 
salario       		NUMERIC(7,2) CONSTRAINT nn_tb_emp_salario NOT NULL, 
comissao       		FLOAT, 
id_departamento     INTEGER DEFAULT 10, 
fg_ativo			BIT,
CONSTRAINT pk_tb_emp_id_emp PRIMARY KEY(id_empregado)
);

SELECT *
FROM tb_empregados;


-- =======================
-- tabela tb_departamentos
-- =======================

CREATE TABLE tb_departamentos( 
id_departamento		INTEGER		CONSTRAINT ck_tb_departamentos_id_depto CHECK ((id_departamento % 10) = 0), 
nm_departamento  	VARCHAR(40) CONSTRAINT nn_tb_departamentos_nm_depto NOT NULL,		        				
								CONSTRAINT ck_tb_departamentos_nm_depto 
								           CHECK(nm_departamento = UPPER(nm_departamento)), 
localizacao 		VARCHAR(60) CONSTRAINT nn_tb_departamentos_localizacao NOT NULL
								CONSTRAINT ck_tb_departamentos_localizacao 
								           CHECK (localizacao = UPPER(localizacao)), 
id_gerente    		INTEGER,
fg_ativo			BIT,
CONSTRAINT pk_tb_departamentos_id_depto PRIMARY KEY(id_departamento),
CONSTRAINT un_tb_departamentos_nm_depto UNIQUE(nm_departamento),
CONSTRAINT fk_tb_departamentos_id_gerente FOREIGN KEY(id_gerente) REFERENCES tb_empregados
);

SELECT *
FROM tb_departamentos;

-- ============================
-- tabela tb_cursos_oferecidos
-- ============================

CREATE TABLE tb_cursos_oferecidos( 
id_curso     		VARCHAR(6)	CONSTRAINT nn_tb_cursos_oferecidos_id_curso NOT NULL, 
dt_inicio    		DATE		CONSTRAINT nn_tb_cursos_oferecidos_dt_inicio NOT NULL, 
id_instrutor 		INTEGER, 
localizacao  		VARCHAR(60), 
fg_ativo			BIT,
CONSTRAINT pk_tb_cursos_oferecidos PRIMARY KEY(id_curso, dt_inicio),
CONSTRAINT fk_tb_cursos_oferecidos_id_curso FOREIGN KEY(id_curso) REFERENCES tb_cursos,
CONSTRAINT fk_tb_cursos_oferecidos_id_instrutor FOREIGN KEY(id_instrutor) REFERENCES tb_empregados
);

-- =====================
-- tabela tb_matriculas
-- =====================

CREATE TABLE tb_matriculas( 
id_participante    	INTEGER 	CONSTRAINT nn_tb_matriculas_id_participante NOT NULL, 
id_curso      	   	VARCHAR(6) 	CONSTRAINT nn_tb_matriculas_id_curso NOT NULL, 
dt_inicio   	   	DATE 		CONSTRAINT nn_tb_matriculas_dt_inicio NOT NULL, 
avaliacao  	   		INTEGER 	CONSTRAINT ck_tb_matriculas_avaliacao CHECK (avaliacao IN (1,2,3,4,5)), 
fg_ativo	   		BIT,
CONSTRAINT pk_tb_matriculas PRIMARY KEY (id_participante, id_curso, dt_inicio), 
CONSTRAINT fk_tb_matriculas FOREIGN KEY (id_curso, dt_inicio) REFERENCES tb_cursos_oferecidos,
CONSTRAINT fk_tb_matriculas_id_participante FOREIGN KEY(id_participante) REFERENCES tb_empregados
);

SELECT *
FROM tb_matriculas;


-- ====================
-- tabela tb_historico
-- ====================

CREATE TABLE tb_historicos( 
id_empregado      	INTEGER CONSTRAINT nn_tb_historicos_id_emp NOT NULL, 
dt_inicio  	  		DATE	CONSTRAINT nn_tb_historicos_dt_inicio NOT NULL, 
ano_inicio  	  	INTEGER CONSTRAINT nn_tb_historicos_ano_inicio NOT NULL, 
dt_final    	  	DATE, 
id_departamento   	INTEGER CONSTRAINT nn_tb_historicos_id_depto NOT NULL, 
salario       	  	NUMERIC(7,2) CONSTRAINT nn_tb_historicos_salario NOT NULL, 
comentarios   	  	VARCHAR(60), 
fg_ativo	  		BIT,
CONSTRAINT pk_tb_historicos PRIMARY KEY(id_empregado, dt_inicio), 
CONSTRAINT ck_tb_historicos_dt_inicio CHECK (dt_inicio < dt_final),
CONSTRAINT fk_tb_historicos_id_emp FOREIGN KEY(id_empregado) REFERENCES tb_empregados ON DELETE CASCADE,
CONSTRAINT fk_tb_historicos_id_depto FOREIGN KEY(id_departamento) REFERENCES tb_departamentos                    
);

-- ====================================================
-- Realizando a carga de dados
-- ====================================================
-- ====================================================
-- Disable PK constraints (to make inserting easier)
-- ====================================================

GO  
ALTER TABLE tb_empregados 
NOCHECK CONSTRAINT fk_tb_emp_id_gerente;  
GO  

-- ===================================================
-- tb_empregados (id_empregado, nm_empregado, 
--                iniciais_empregado, ds_cargo, 
--                id_gerente, dt_nascimento, 
--                salario, comissao, id_departamento, 
--                fg_ativo)
-- ===================================================

INSERT INTO tb_empregados(id_empregado, nm_empregado, iniciais_empregado, 
						  ds_cargo, id_gerente, dt_nascimento, salario, 
						  comissao, id_departamento, fg_ativo)
VALUES
(7369,'SMITH','N', 'TRAINER', 7902, '1965-12-17',  8000.00 , NULL,  20, 1),
(7499,'ALLEN','JAM', 'SALESREP',7698, '1961-02-20',  16000.00, 300,   30, 1),
(7521,'WARD','TF' , 'SALESREP',7698, '1962-02-22',  12500.00, 500,   30, 1),
(7566,'JONES','JM', 'MANAGER', 7839, '1967-04-02',  29750.00, NULL,  20, 1),
(7654,'MARTIN','P', 'SALESREP',7698, '1956-09-28',  12500.00, 1400,  30, 1),
(7698,'BLAKE','R', 'MANAGER', 7839, '1963-11-01',  28500.00, NULL,  30, 1),
(7782,'CLARK','AB', 'MANAGER', 7839, '1965-06-09',  24500.00, NULL,  10, 1),
(7788,'SCOTT','SCJ', 'TRAINER', 7566, '1959-11-26',  30000.00, NULL,  20, 1),
(7839,'KING','CC', 'DIRECTOR',NULL, '1952-11-17',  50000.00, NULL,  10, 1),
(7844,'TURNER','JJ', 'SALESREP',7698, '1968-09-28',  15000.00, 0, 30, 1),
(7876,'ADAMS','AA',  'TRAINER', 7788, '1966-12-30',  11000.00, NULL,  20, 1),
(7900,'JONES','R', 'ADMIN',   7698, '1969-12-03',  8000.00 , NULL,  30, 1),
(7902,'FORD','MG', 'TRAINER', 7566, '1959-02-13',  30000.00, NULL,  20, 1),
(7934,'MILLER','TJA','ADMIN', 7782, '1962-01-23',  13000.00, NULL,  10, 1);

GO
ALTER TABLE tb_empregados   
CHECK CONSTRAINT fk_tb_emp_id_gerente;  
GO

SELECT *
FROM tb_empregados;

-- =======================================
-- tb_departamentos (id_departamento, nm_departamento, 
--                   localizacao, id_gerente, fg_ativo)
-- =======================================

INSERT INTO tb_departamentos(id_departamento, nm_departamento, localizacao, id_gerente, fg_ativo) 
VALUES 
(10,'ACCOUNTING','NEW YORK',7782, 1),
(20,'TRAINING', 'DALLAS', 7566, 1),
(30,'SALES', 'CHICAGO', 7698, 1),
(40,'HR', 'BOSTON', 7839, 1);

SELECT *
FROM tb_departamentos;

-- ============================================================
-- tb_grades_salarios (id_grade, limite_inferior, 
--                     limite_superior, bonus, fg_ativo)
-- ============================================================

INSERT INTO tb_grades_salarios (id_grade, 
	                            limite_inferior, 
	                            limite_superior, 
	                            bonus, 
	                            fg_ativo)
VALUES 
(1,  7000.00, 12000.00,   0, 1),
(2, 12001.00, 14000.00,  50, 1),
(3, 14001.00, 20000.00, 100, 1),
(4, 20001.00, 30000.00, 200, 1),
(5, 30001.00, 99999.00, 500, 1);

SELECT *
FROM tb_grades_salarios;

-- ===================================================================
-- tb_cursos (id_curso, ds_curso, categoria, duracao, fg_ativo)
-- ===================================================================

INSERT INTO tb_cursos(id_curso, ds_curso, categoria, duracao, fg_ativo) 
VALUES
('SQL','Introducao ao SQL', 'GEN',4, 1),
('OAU','Oracle para usuarios de aplicativos','GEN',1, 1),
('JAV','Java para desenvolvedores Oracle', 'BLD',4, 1),
('PLS','Introducao ao PL/SQL', 'BLD',1, 1),
('XML','XML para desenvolvedores Oracle', 'BLD',2, 1),
('ERM','Modelagem de Dados com DER', 'DSG',3, 1),
('PMT','Tecnicas de Modelagem de Processos', 'DSG',1, 1),
('RSD','Modelagem de Sistema Relacional','DSG',2, 1),
('PRO','Prototipagem','DSG',5, 1),
('GEN','Implementa��o de Sistemas','DSG',4, 1);

SELECT *
FROM tb_cursos;

-- ======================================================================================
-- tb_cursos_oferecidos (id_curso, dt_inicio, id_instrutor, localizacao, fg_ativo)
-- ======================================================================================

INSERT INTO tb_cursos_oferecidos (id_curso, dt_inicio, id_instrutor, localizacao, fg_ativo)
VALUES 
('SQL', '1999-04-12', 7902,'DALLAS', 1),
('OAU', '1999-08-10', 7566, 'CHICAGO', 1),
('SQL', '1999-10-04', 7369, 'SEATTLE', 1),
('SQL', '1999-12-13', 7369, 'DALLAS', 1),
('JAV', '1999-12-13', 7566, 'SEATTLE', 1),
('XML', '2000-02-03', 7369, 'DALLAS', 1),
('JAV', '2000-02-01', 7876, 'DALLAS', 1),
('PLS', '2000-09-11', 7788, 'DALLAS', 1),
('XML', '2000-09-18', NULL, 'SEATTLE', 1),
('OAU', '2000-09-27', 7902, 'DALLAS', 1),
('ERM', '2001-01-15', NULL, NULL, 1),
('PRO', '2001-02-19', NULL, 'DALLAS', 1),
('RSD', '2001-02-24', 7788, 'CHICAGO', 1);

SELECT *
FROM tb_cursos_oferecidos;

-- ================================================================================
-- tabela tb_matriculas (id_participante, id_curso, dt_inicio, avaliacao, fg_ativo)
-- ================================================================================

INSERT INTO tb_matriculas(id_participante, id_curso, dt_inicio, avaliacao, fg_ativo)
VALUES 
(7499, 'SQL', '1999-04-12', 4, 1),
(7934, 'SQL', '1999-04-12', 5, 1), 
(7698, 'SQL', '1999-04-12', 4, 1),
(7876, 'SQL', '1999-04-12', 2, 1),
(7788, 'SQL', '1999-10-04', NULL, 1),
(7839, 'SQL', '1999-10-04', 3, 1),
(7902, 'SQL', '1999-10-04', 4, 1),
(7902, 'SQL', '1999-12-13', NULL, 1),
(7698, 'SQL', '1999-12-13', NULL, 1),
(7521, 'OAU', '1999-08-10', 4, 1);

INSERT INTO tb_matriculas(id_participante, id_curso, dt_inicio, avaliacao, fg_ativo)
VALUES 
(7900, 'OAU', '1999-08-10', 4, 1),
(7902, 'OAU', '1999-08-10', 5, 1),
(7844, 'OAU', '2000-09-27', 5, 1),
(7499, 'JAV', '1999-12-13', 2, 1),
(7782, 'JAV', '1999-12-13', 5, 1),
(7876, 'JAV', '1999-12-13', 5, 1),
(7788, 'JAV', '1999-12-13', 5, 1);

INSERT INTO tb_matriculas(id_participante, id_curso, dt_inicio, avaliacao, fg_ativo) 
VALUES 
(7839, 'JAV', '1999-12-13', 4, 1),
(7566, 'JAV', '2000-02-01', 3, 1),
(7788, 'JAV', '2000-02-01', 4, 1),
(7698, 'JAV', '2000-02-01', 5, 1),
(7900, 'XML', '2000-02-03', 4, 1);

INSERT INTO tb_matriculas(id_participante, id_curso, dt_inicio, avaliacao, fg_ativo) 
VALUES 
(7499, 'XML', '2000-02-03', 5, 1),
(7566, 'PLS', '2000-09-11', NULL, 1),
(7499, 'PLS', '2000-09-11', NULL, 1),
(7876, 'PLS', '2000-09-11', NULL, 1);

SELECT *
FROM tb_matriculas;


-- ======================================================================
-- tabela tb_historicos (id_empregado, ano_inicio, dt_inicio, dt_final, 
--                       id_departamento, salario, comentarios, fg_ativo)                        
-- ======================================================================

INSERT INTO tb_historicos (id_empregado, ano_inicio, dt_inicio, dt_final, id_departamento, salario, comentarios, fg_ativo)
VALUES 
(7369, 2000, '2000-01-01', '2000-02-01', 40, 950, NULL, 1),
(7369, 2000, '2000-02-01', NULL, 20, 800, 'Transfer to training department -- salary "correction" 150', 1),
(7499, 1988, '1988-06-01', '1989-07-01', 30, 1000, NULL, 1),
(7499, 1989, '1989-07-01', '1993-12-01', 30, 1300, NULL, 1),
(7499, 1993, '1993-12-01', '1995-10-01', 30, 1500, NULL, 1),
(7499, 1995, '1995-10-01', '1999-11-01', 30, 1700, NULL, 1),
(7499, 1999, '1999-11-01', NULL, 30, 1600, 'Missed targets again; salary reduction', 1),
(7521, 1986, '1986-10-01', '1987-08-01', 20, 1000, NULL, 1),
(7521, 1987, '1987-08-01', '1989-01-01', 30, 1000, 'Transfer to sales department: own request', 1),
(7521, 1989, '1989-01-01', '1992-12-15', 30, 1150, NULL, 1),
(7521, 1992, '1992-12-15', '1994-10-01', 30, 1250, NULL, 1);

INSERT INTO tb_historicos (id_empregado, ano_inicio, dt_inicio, dt_final, id_departamento, salario, comentarios, fg_ativo)
VALUES 
(7521, 1994, '1994-10-01', '1997-10-01', 20, 1250, NULL, 1),
(7521, 1997, '1997-10-01', '2000-02-01', 30, 1300, NULL, 1),
(7521, 2000, '2000-02-01', NULL, 30, 1250, NULL, 1),
(7566, 1982, '1982-01-01', '1982-12-01', 20, 900, NULL, 1),
(7566, 1982, '1982-12-01', '1984-08-15', 20, 950, NULL, 1),
(7566, 1984, '1984-08-15', '1986-01-01', 30, 1000, 'Not a great trainer; let''s try the sales department!', 1),
(7566, 1986, '1986-01-01', '1986-07-01', 30, 1175, 'Sales also turns out to be not a success...', 1),
(7566, 1986, '1986-07-01', '1987-03-15', 10, 1175, NULL, 1),
(7566, 1987, '1987-03-15', '1987-04-01', 10, 2200, NULL, 1),
(7566, 1987, '1987-04-01', '1989-06-01', 10, 2300, NULL, 1),
(7566, 1989, '1989-06-01', '1992-07-01', 40, 2300, 'From accounting to human resources; 0% salary change', 1);
           
INSERT INTO tb_historicos (id_empregado, ano_inicio, dt_inicio, dt_final, id_departamento, salario, comentarios, fg_ativo)
VALUES 
(7566, 1992, '1992-07-01', '1992-11-01', 40, 2450, NULL, 1),
(7566, 1992, '1992-11-01', '1994-09-01', 20, 2600, 'Back to the training department, as manager', 1),
(7566, 1994, '1994-09-01', '1995-03-01', 20, 2550, NULL, 1),
(7566, 1995, '1995-03-01', '1999-10-15', 20, 2750, NULL, 1),
(7566, 1999, '1999-10-15', NULL, 20, 2975, NULL, 1),
(7654, 1999, '1999-01-01', '1999-10-15', 30, 1100, 'Senior sales rep; high potential?', 1),
(7654, 1999, '1999-10-15', NULL, 30, 1250, 'Turns out to be slightly disappointing :-( ', 1),
(7698, 1982, '1982-06-01', '1983-01-01', 30, 900, NULL, 1),
(7698, 1983, '1983-01-01', '1984-01-01', 30, 1275, NULL, 1),
(7698, 1984, '1984-01-01', '1985-04-15', 30, 1500, NULL, 1);

INSERT INTO tb_historicos (id_empregado, ano_inicio, dt_inicio, dt_final, id_departamento, salario, comentarios, fg_ativo)
VALUES 
(7698, 1985, '1985-04-15','1986-01-01', 30, 2100, NULL, 1),
(7698, 1986, '1986-01-01','1989-10-15', 30, 2200, NULL, 1),
(7698, 1989, '1989-10-15', NULL, 30, 2850, 'Promoted to become manager of the sales department', 1),
(7782, 1988, '1988-07-01', NULL, 10, 2450, 'Hired as the new manager for the accounting department', 1),
(7788, 1982, '1982-07-01', '1983-01-01', 20, 900, NULL, 1),
(7788, 1983, '1983-01-01', '1985-04-15', 20, 950, NULL, 1),
(7788, 1985, '1985-04-15', '1985-06-01', 40, 950, 'Transfer to human resources; 0% salary raise', 1),
(7788, 1985, '1985-06-01', '1986-04-15', 40, 1100, NULL, 1),
(7788, 1986, '1986-04-15', '1986-05-01', 20, 1100, NULL, 1),
(7788, 1986, '1986-05-01', '1987-02-15', 20, 1800, NULL, 1);

INSERT INTO tb_historicos (id_empregado, ano_inicio, dt_inicio, dt_final, id_departamento, salario, comentarios, fg_ativo)
VALUES 
(7788, 1987, '1987-02-15', '1989-12-01', 20, 1250, 'Salary reduction 550, insufficient achievements', 1),
(7788, 1989, '1989-12-01', '1992-10-15', 20, 1350, NULL, 1),
(7788, 1992, '1992-10-15', '1998-01-01', 20, 1400, NULL, 1),
(7788, 1998, '1998-01-01', '1999-01-01', 20, 1700, NULL, 1),
(7788, 1999, '1999-01-01', '1999-07-01', 20, 1800, NULL, 1),
(7788, 1999, '1999-07-01', '2000-06-01', 20, 1800, NULL, 1),
(7788, 2000, '2000-06-01', NULL, 20, 3000, NULL, 1),
(7839, 1982, '1982-01-01', '1982-08-01', 30, 1000, 'Founder and first employee of the company', 1),
(7839, 1982, '1982-08-01', '1984-05-15', 30, 1200, NULL, 1),
(7839, 1984, '1984-05-15', '1985-01-01', 30, 1500, NULL, 1);

INSERT INTO tb_historicos (id_empregado, ano_inicio, dt_inicio, dt_final, id_departamento, salario, comentarios, fg_ativo)
VALUES 
(7839, 1985, '1985-01-01', '1985-07-01', 30, 1750, NULL, 1),
(7839, 1985, '1985-07-01', '1985-11-01', 10, 2000, 'Accounting established as an independent department', 1),
(7839, 1985, '1985-11-01', '1986-02-01', 10, 2200, NULL, 1),
(7839, 1986, '1986-02-01', '1989-06-15', 10, 2500, NULL, 1),
(7839, 1989, '1989-06-15', '1993-12-01', 10, 2900, NULL, 1),
(7839, 1993, '1993-12-01', '1995-09-01', 10, 3400, NULL, 1),
(7839, 1995, '1995-09-01', '1997-10-01', 10, 4200, NULL, 1),
(7839, 1997, '1997-10-01', '1998-10-01', 10, 4500, NULL, 1),
(7839, 1998, '1998-10-01', '1999-11-01', 10, 4800, NULL, 1),
(7839, 1999, '1999-11-01', '2000-02-15', 10, 4900, NULL, 1);

INSERT INTO tb_historicos (id_empregado, ano_inicio, dt_inicio, dt_final, id_departamento, salario, comentarios, fg_ativo)
VALUES 
(7839, 2000, '2000-02-15', NULL, 10, 5000, NULL, 1),
(7844, 1995, '1995-05-01', '1997-01-01', 30, 900, NULL, 1),
(7844, 1998, '1998-10-15', '1998-11-01', 10, 1200, 'Project (half a month) for the ACCOUNTING department', 1),
(7844, 1998, '1998-11-01', '2000-01-01', 30, 1400, NULL, 1),
(7844, 2000, '2000-01-01', NULL, 30, 1500, NULL, 1),
(7876, 2000, '2000-01-01', '2000-02-01', 20, 950, NULL, 1),
(7876, 2000, '2000-02-01', NULL, 20, 1100, NULL, 1),
(7900, 2000, '2000-07-01', NULL, 30, 800, 'Junior sales rep -- has lots to learn... :-)', 1),
(7902, 1998, '1998-09-01', '1998-10-01', 40, 1400, NULL, 1),
(7902, 1998, '1998-10-01', '1999-03-15', 30, 1650, NULL, 1);

INSERT INTO tb_historicos (id_empregado, ano_inicio, dt_inicio, dt_final, id_departamento, salario, comentarios, fg_ativo)
VALUES 
(7902, 1999, '1999-03-15', '2000-01-01', 30, 2500, NULL, 1),
(7902, 2000, '2000-01-01', '2000-08-01', 30, 3000, NULL, 1),
(7902, 2000, '2000-08-01', NULL, 20, 3000, NULL, 1),
(7934, 1998, '1998-02-01', '1998-05-01', 10, 1275, NULL, 1),
(7934, 1998, '1998-05-01', '1999-02-01', 10, 1280, NULL, 1),
(7934, 1999, '1999-02-01', '2000-01-01', 10, 1290, NULL, 1),
(7934, 2000, '2000-01-01', NULL, 10, 1300, NULL, 1);

SELECT *
FROM tb_historicos;