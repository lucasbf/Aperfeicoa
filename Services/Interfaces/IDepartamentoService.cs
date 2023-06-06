using Microsoft.AspNetCore.Mvc;
using Aperfeicoa.Models;

namespace Aperfeicoa.Services.Interfaces;

public interface IDepartamentoService : IService<TbDepartamentos>
{
      public int GetNextId();
}