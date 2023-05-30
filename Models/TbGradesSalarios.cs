using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Aperfeicoa.Models;

[Table("tb_grades_salarios")]
public partial class TbGradesSalarios
{
    [Key]
    [Column("id_grade")]
    public int IdGrade { get; set; }

    [Column("limite_inferior", TypeName = "numeric(7, 2)")]
    public decimal LimiteInferior { get; set; }

    [Column("limite_superior", TypeName = "numeric(7, 2)")]
    public decimal LimiteSuperior { get; set; }

    [Column("bonus")]
    public double Bonus { get; set; }

    [Column("fg_ativo")]
    public bool? FgAtivo { get; set; }
}
