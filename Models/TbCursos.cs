using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace Aperfeicoa.Models;

[Table("tb_cursos")]
public partial class TbCursos
{
    [Key]
    [Column("id_curso")]
    [StringLength(6)]
    [Unicode(false)]
    public string IdCurso { get; set; } = null!;

    [Column("ds_curso")]
    [StringLength(60)]
    [Unicode(false)]
    public string DsCurso { get; set; } = null!;

    [Column("categoria")]
    [StringLength(3)]
    [Unicode(false)]
    public string Categoria { get; set; } = null!;

    [Column("duracao")]
    public int Duracao { get; set; }

    [Column("fg_ativo")]
    public bool? FgAtivo { get; set; }

    [InverseProperty("IdCursoNavigation")]
    public virtual ICollection<TbCursosOferecidos> TbCursosOferecidos { get; set; } = new List<TbCursosOferecidos>();
}
