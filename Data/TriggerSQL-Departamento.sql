USE Academico
GO
CREATE TRIGGER SetIdDepartamento ON tb_departamentos INSTEAD OF INSERT AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @iddepto INT;
    SELECT @iddepto = MAX(id_departamento) + 10 FROM tb_departamentos;
    SELECT * INTO #tmp FROM INSERTED;
    UPDATE #tmp SET id_departamento = @iddepto;
    INSERT INTO tb_departamentos SELECT * FROM #tmp;
END
GO