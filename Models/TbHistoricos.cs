using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Aperfeicoa.Models;

[PrimaryKey("IdEmpregado", "DtInicio")]
[Table("tb_historicos")]
public partial class TbHistoricos
{
    [Key]
    [Column("id_empregado")]
    public int IdEmpregado { get; set; }

    [Key]
    [Column("dt_inicio", TypeName = "date")]
    public DateTime DtInicio { get; set; }

    [Column("ano_inicio")]
    public int AnoInicio { get; set; }

    [Column("dt_final", TypeName = "date")]
    public DateTime? DtFinal { get; set; }

    [Column("id_departamento")]
    public int IdDepartamento { get; set; }

    [Column("salario", TypeName = "numeric(7, 2)")]
    public decimal Salario { get; set; }

    [Column("comentarios")]
    [StringLength(60)]
    [Unicode(false)]
    public string? Comentarios { get; set; }

    [Column("fg_ativo")]
    public bool? FgAtivo { get; set; }

    [ForeignKey("IdDepartamento")]
    [InverseProperty("TbHistoricos")]
    public virtual TbDepartamentos IdDepartamentoNavigation { get; set; } = null!;

    [ForeignKey("IdEmpregado")]
    [InverseProperty("TbHistoricos")]
    public virtual TbEmpregados IdEmpregadoNavigation { get; set; } = null!;
}
