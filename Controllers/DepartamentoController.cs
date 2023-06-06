using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Aperfeicoa.Models;
using Aperfeicoa.Services.Interfaces;

namespace Aperfeicoa.Controllers;

public class DepartamentoController : Controller
{
    
    private readonly ILogger<DepartamentoController> _logger;
    private readonly IDepartamentoService _service;
    private readonly IEmpregadoService _serviceEmpregado;

    public DepartamentoController(ILogger<DepartamentoController> logger, 
                                  IDepartamentoService service,
                                  IEmpregadoService serviceEmpregado)
    {
        _logger = logger;
        _service = service;
        _serviceEmpregado = serviceEmpregado;
    }

    public List<SelectListItem> GetEmpregadosListItem()
    {
        return _serviceEmpregado.GetAll()
            .OrderBy(e => e.NmEmpregado)
            .Select(m => new SelectListItem() { 
                Value = m.IdEmpregado.ToString(),
                Text = m.NmEmpregado 
            }).ToList(); 
    }

    public IActionResult CreateOrUpdate(TbDepartamentos departamento, Action<TbDepartamentos> action)
    {
        if (!ModelState.IsValid)
        {
            ViewData["Empregados"] = GetEmpregadosListItem();
            return View(departamento);   
        }
        action(departamento);
        return RedirectToAction("Index");
    }

    public IActionResult Index()
    {
        var departamentos = _service.GetAll();
        return View(departamentos);
    }

    public IActionResult Create()
    {
        ViewData["Empregados"] = GetEmpregadosListItem();
        return View();
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Create([Bind("NmDepartamento", "Localizacao", "IdGerente")]TbDepartamentos departamento)
    {
        return CreateOrUpdate(departamento, _service.Create);
    }

    public IActionResult Update(int id)
    {
        ViewData["Editar"] = true;
        ViewData["Empregados"] = GetEmpregadosListItem();
        return View("Create", _service.Get(new TbDepartamentos { IdDepartamento = id }));
    }
    
    [HttpPost]
    [ValidateAntiForgeryToken]
    public IActionResult Update([Bind("IdDepartamento", "NmDepartamento", "Localizacao", "IdGerente")]TbDepartamentos departamento)
    {
        return CreateOrUpdate(departamento, _service.Update);
    }
    
    public IActionResult Delete_Undelete(int id, bool ativo)
    {
        var departamento = _service.Get(new TbDepartamentos { IdDepartamento = id});
        departamento.FgAtivo = ativo;
        _service.Update(departamento);
        return RedirectToAction("Index");
    }

    [HttpPost]
    public IActionResult Delete(int id)
    {
        return Delete_Undelete(id, false);
    }

    public IActionResult Undelete(int id)
    {
        return Delete_Undelete(id, true);
    }
}