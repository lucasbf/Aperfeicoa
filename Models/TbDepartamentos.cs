﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Aperfeicoa.Models;

[Table("tb_departamentos")]
[Index("NmDepartamento", Name = "un_tb_departamentos_nm_depto", IsUnique = true)]
public partial class TbDepartamentos
{
    [Key]
    [Column("id_departamento")]
    [Display(Name = "Id Depto")]
    public int IdDepartamento { get; set; }

    [Column("nm_departamento")]
    [StringLength(40)]
    [Unicode(false)]
    [Display(Name = "Nome")]
    public string NmDepartamento { get; set; } = null!;

    [Column("localizacao")]
    [StringLength(60)]
    [Unicode(false)]
    [Display(Name = "Localização")]
    public string Localizacao { get; set; } = null!;

    [Column("id_gerente")]
    [Display(Name = "Id Gerente")]
    public int? IdGerente { get; set; }

    [Column("fg_ativo")]
    [Display(Name = "Ativo")]
    public bool? FgAtivo { get; set; }

    [ForeignKey("IdGerente")]
    [InverseProperty("TbDepartamentos")]
    public virtual TbEmpregados? IdGerenteNavigation { get; set; }

    [InverseProperty("IdDepartamentoNavigation")]
    public virtual ICollection<TbHistoricos> TbHistoricos { get; set; } = new List<TbHistoricos>();
}
