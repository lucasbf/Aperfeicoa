using Aperfeicoa.Models;
using Aperfeicoa.Data;
using Aperfeicoa.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace Aperfeicoa.Services;

public class DepartamentoDBContext : AperfeicoaDBContext<TbDepartamentos>, IDepartamentoService 
{
    public DepartamentoDBContext(AcademicoContext context) : base(context)
    {

    }

    public override DbSet<TbDepartamentos> Set => (_context as AcademicoContext)!.TbDepartamentos;
}