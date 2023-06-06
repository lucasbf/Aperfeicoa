using Aperfeicoa.Models;
using Aperfeicoa.Data;
using Aperfeicoa.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace Aperfeicoa.Services;

public class EmpregadoDBContext : AperfeicoaDBContext<TbEmpregados>, IEmpregadoService 
{
    protected override DbSet<TbEmpregados> Set => (_context as AcademicoContext)!.TbEmpregados;

    protected override List<string> GetIncludeRelationship()
    {
        return new() { "InverseIdGerenteNavigation", 
                       "TbCursosOferecidos", 
                       "TbDepartamentos", 
                       "TbHistoricos", 
                       "TbMatriculas" };
    }

    public TbEmpregados Get(TbEmpregados entity)
    {
        return base.Get(e => e.IdEmpregado == entity.IdEmpregado);
    }

    public EmpregadoDBContext(AcademicoContext context) : base(context)
    {
        
    }
}