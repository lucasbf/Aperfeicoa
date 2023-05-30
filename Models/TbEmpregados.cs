using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Aperfeicoa.Models;

[Table("tb_empregados")]
public partial class TbEmpregados
{
    [Key]
    [Column("id_empregado")]
    public int IdEmpregado { get; set; }

    [Column("nm_empregado")]
    [StringLength(60)]
    [Unicode(false)]
    public string NmEmpregado { get; set; } = null!;

    [Column("iniciais_empregado")]
    [StringLength(5)]
    [Unicode(false)]
    public string IniciaisEmpregado { get; set; } = null!;

    [Column("ds_cargo")]
    [StringLength(40)]
    [Unicode(false)]
    public string? DsCargo { get; set; }

    [Column("id_gerente")]
    public int? IdGerente { get; set; }

    [Column("dt_nascimento", TypeName = "date")]
    public DateTime DtNascimento { get; set; }

    [Column("salario", TypeName = "numeric(7, 2)")]
    public decimal Salario { get; set; }

    [Column("comissao")]
    public double? Comissao { get; set; }

    [Column("id_departamento")]
    public int? IdDepartamento { get; set; }

    [Column("fg_ativo")]
    public bool? FgAtivo { get; set; }

    [ForeignKey("IdGerente")]
    [InverseProperty("InverseIdGerenteNavigation")]
    public virtual TbEmpregados? IdGerenteNavigation { get; set; }

    [InverseProperty("IdGerenteNavigation")]
    public virtual ICollection<TbEmpregados> InverseIdGerenteNavigation { get; set; } = new List<TbEmpregados>();

    [InverseProperty("IdInstrutorNavigation")]
    public virtual ICollection<TbCursosOferecidos> TbCursosOferecidos { get; set; } = new List<TbCursosOferecidos>();

    [InverseProperty("IdGerenteNavigation")]
    public virtual ICollection<TbDepartamentos> TbDepartamentos { get; set; } = new List<TbDepartamentos>();

    [InverseProperty("IdEmpregadoNavigation")]
    public virtual ICollection<TbHistoricos> TbHistoricos { get; set; } = new List<TbHistoricos>();

    [InverseProperty("IdParticipanteNavigation")]
    public virtual ICollection<TbMatriculas> TbMatriculas { get; set; } = new List<TbMatriculas>();
}
